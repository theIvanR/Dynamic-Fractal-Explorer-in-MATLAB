function juliafract(fractalFunction, x_max, x_min, y_min, y_max, res, iterations, opt, lyapunov)

high = 1e22; low = 1e-8; %bounds for turbo break
lambda = 0; %initial lyapunov exponent

X = linspace(x_min, x_max, res);
Y = linspace(y_min, y_max, res);
[x, y] = meshgrid(X, Y);

z = x + 1i * y;
%% GPU Acceleration (to disable, redefine z without gpu's and no gather)
% Transfer x and y data to the GPU
x_gpu = gpuArray(x);
y_gpu = gpuArray(y);
z = x_gpu + 1i * y_gpu;
% Transfer z to the GPU
z = gpuArray(z);

%% Fractal Generator
for k = 1:iterations + 1

    % Turbo Mode (check first to break, skips one step!)
    if opt && (any(abs(z(:)) > high) || all(abs(z(:)) < low)) && lyapunov == false
        break;
    end

    % Fractal Generator
    z_prev = z;
    z = fractalFunction(z);

    % Lyapunov Exponential
    if lyapunov
        lambda = lambda + log(z - z_prev);
    end
end

%% Mapping: (z->t on [0;1])
if lyapunov
    lambda = abs(lambda / iterations);
    t = lambda;

else
    %t=exp(-abs(z));
    %t = 1.0 ./ (abs(z) + 1); 
    %t = real(z);
    %t = imag(z);
    %t=abs(z);
    t = gather(exp(-abs(z)));
    %t = gather(1.0 ./ (abs(z) + 1)); 
end

%% Plotting
    imagesc(X, Y, t);
    colormap jet;
    colormap turbo;
    colorbar;
    axis image;

%% Title and Labels
titleText = sprintf('%s | %d Iterations |', func2str(fractalFunction), iterations);
if lyapunov == 1
    titleText = [titleText, ' Lyapunov'];
elseif opt == 0
    titleText = [titleText, ' Normal'];
elseif opt == 1
    titleText = [titleText, ' Turbo Mode'];
end
title(titleText);

xlabel(['X Axis (', num2str(res), ' steps)']);
ylabel(['Y Axis (', num2str(res), ' steps)']);

end

function juliafract(x_max, x_min, y_min, y_max, res, iterations, opt, lyapunov)

high = 1e22; low = 1e-8; %bounds for turbo break
lambda = 0; %initial lyapunov exponent

X = linspace(x_min, x_max, res);
Y = linspace(y_min, y_max, res);
[x, y] = meshgrid(X, Y);

z = x + 1i * y;

%% Fractal Generator
for k = 1:iterations + 1
    
    % Turbo Mode (check first to break, skips one step!)
    if opt && (any(abs(z(:)) > high) || all(abs(z(:)) < low)) && lyapunov == false
        break;
    end
    
    % Fractal Generator
    z_prev = z;
    z = 1.25 - z.^2;
    
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
    t = 1.0 ./ (abs(z) + 1); 
end

%% Plotting
    imagesc(X, Y, t);
    colormap jet;
    colorbar;
    axis image;

%% Title and Labels
titleText = sprintf('Julia Fractal (%d Iterations)', iterations);
if lyapunov == 1
    titleText = [titleText, ' (Lyapunov Mode)'];
elseif opt == 0
    titleText = [titleText, ' (Normal Mode)'];
elseif opt == 1
    titleText = [titleText, ' (Turbo Mode)'];
end
title(titleText);

xlabel(['X Axis (', num2str(res), ' steps)']);
ylabel(['Y Axis (', num2str(res), ' steps)']);

end

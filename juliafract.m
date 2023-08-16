function juliafract(x_max,x_min,y_min,y_max,res,iterations,opt);

X = linspace(x_min,x_max,res);
Y = linspace(y_min,y_max,res);

[x,y] = meshgrid(X,Y);
z=x+i.*y;

%% Main Loop (exp)
high = 1e22; low = 1e-8; %cutoff detectors

%Fractal Generator
    for k=1:iterations+1;
        
        %Turbo Mode
        if opt 
            %stability container
            if any(abs(z(:)) > high) || all(abs(z(:)) < low)
                break;
            end
        end

        %Fractal Generator
        z = 1.25 - z.^2;
    end

% Mapping function to compress values (z->t)
    %t=real(z);
    %t=imag(z);

    %t=exp(-abs(z)); %negative exponential
    t=1./(abs(z)+1);
    %t=2*atan(abs(z))/pi;

%% Plotting
    imagesc(X, Y, t);
    colormap jet;
    colorbar;
    axis image;

%Title
    titleText = sprintf('Julia Fractal (%d Iterations)', iterations);

    if opt == 0
        titleText = [titleText, ' (Normal Mode)'];
    elseif opt == 1
        titleText = [titleText, ' (Turbo Mode)'];
    end
    title(titleText);

%Label
    xlabel(['X Axis (', num2str(res), ' steps)']);
    ylabel(['Y Axis (', num2str(res), ' steps)']);

end

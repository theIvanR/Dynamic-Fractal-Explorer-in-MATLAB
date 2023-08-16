function juliafract(x_max,x_min,y_min,y_max,res,opt);

X = linspace(x_min,x_max,res);
Y = linspace(y_min,y_max,res);

[x,y] = meshgrid(X,Y);
z=x+i.*y;

%% Main Loop (exp)
steps = 500;
    high = 1e32; low = 1e-8; %cutoff detectors
    epsilon = 0.01; %convergence detector, useful for other fractals

%fractal generator faster (old was WO lims)
    for k=1:steps+1;
        
        %Turbo Mode
        if opt 
            %stability container
            if any(abs(z(:)) > high) || all(abs(z(:)) < low)
                break;
            end
        end

        %Fractal Generator
            prev=z;
            z= 1.25 - z.^2;
        
        %Convg Detector
%         if abs(z-prev) < epsilon
%             break;
%         end
    end

% Mapping   
    t=exp(-abs(z)); %negative exponential

imagesc(X, Y, t);
colormap jet;
colorbar;
axis image;

end
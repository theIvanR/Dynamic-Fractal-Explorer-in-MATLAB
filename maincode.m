% Set initial window size and position
x_min = -2; x_max = 2;
y_min = -2; y_max = 2;
res = 600; % Default resolution

% Set step size and zoom factor
global step_size;
step_size = 0.1;
zoom_factor = 0.9;

% Options
global mode resl iterations lyapunov;
mode = false;   % Fast mode off
resl = 1;       % Resolution multiplier
iterations = 100; % Default iteration count
lyapunov = false; % Lyapunov Exponential

% Generate initial plot
juliafract(x_max, x_min, y_min, y_max, res, iterations, mode, lyapunov);

% Key definitions
while true
    % Wait for user input
    key = waitforbuttonpress;
    if key == 1
        % Get current axis limits
        xlims = get(gca, 'xlim');
        ylims = get(gca, 'ylim');
        
        % Get the key pressed
        key = get(gcf, 'CurrentCharacter');
        
        % Calculate current zoom level
        x_range = x_max - x_min;
        y_range = y_max - y_min;
        zoom_level = sqrt(x_range * y_range);
        
        % Calculate panning step size based on zoom level
        pan_step_size = step_size / zoom_level;
        
        % Pan the plot
        if key == 's' % Down arrow
            y_min = y_min + pan_step_size * zoom_level;
            y_max = y_max + pan_step_size * zoom_level;
        
        elseif key == 'w' % Up arrow
            y_min = y_min - pan_step_size * zoom_level;
            y_max = y_max - pan_step_size * zoom_level;
        
        elseif key == 'd' % Right arrow
            x_min = x_min + pan_step_size * zoom_level;
            x_max = x_max + pan_step_size * zoom_level;
        
        elseif key == 'a' % Left arrow
            x_min = x_min - pan_step_size * zoom_level;
            x_max = x_max - pan_step_size * zoom_level;
        
        elseif key == '+' || key == '='  % Plus key (zoom in)
            x_min = x_min - (zoom_factor - 1) / 2 * x_range;
            x_max = x_max + (zoom_factor - 1) / 2 * x_range;
            y_min = y_min - (zoom_factor - 1) / 2 * y_range;
            y_max = y_max + (zoom_factor - 1) / 2 * y_range;
            step_size = step_size * zoom_factor;
        
        elseif key == '-' % Minus key (zoom out)
            x_min = x_min + (zoom_factor - 1) / 2 * x_range;
            x_max = x_max - (zoom_factor - 1) / 2 * x_range;
            y_min = y_min + (zoom_factor - 1) / 2 * y_range;
            y_max = y_max - (zoom_factor - 1) / 2 * y_range;
            step_size = step_size / zoom_factor;
        
        % Toggle Resolution
        elseif key == 'q'
            resl = 0.5 * resl;
        elseif key == 'e'
            resl = 2 * resl;

        % Toggle modes
        elseif key == 'h'
            mode = ~mode; % Toggle HQ mode
        elseif key == 'l'
            lyapunov = ~lyapunov;
        
        % Iterations
        elseif key == 'z'
            iterations = floor(2 * iterations);
        elseif key == 'x'
            iterations = floor(iterations / 2);

        end
        
        % Redraw the plot with the new window size and position
        tic
        juliafract(x_max, x_min, y_min, y_max, res * resl, iterations, mode, lyapunov);
        toc
        
        % Display step size and resolution
        step_size
        res * resl
    end
end

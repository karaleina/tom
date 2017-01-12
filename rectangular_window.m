function [rectangular_window] = rectangular_window(columns, fg)
% RECTANGULAR_WINDOW
    rectangular_window = zeros(1, columns);
    center = columns - columns/2 - 1;
    rectangular_window(1, (center - fg):(center + fg)) = 1;
end


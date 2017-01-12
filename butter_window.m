function [butter_window] = butter_window(columns, co_ktora)
%BUTTER WINDOW
    n = 5;
    f = 2e9;
    [zb,pb,kb] = butter(n,2*pi*f,'s');
    [bb,ab] = zp2tf(zb,pb,kb);
    [hb,wb] = freqs(bb,ab,4096);
    y_butter = mag2db(abs(hb));
    %x_butter = wb/(2e9*pi);

    max_y_butter = max(y_butter);
    min_y_butter = -40; 
    %max_x_butter = 0.2;
    %min_x_butter = min(x_butter);

    %Normalizacja Butterwortha:
    y_norm_butter = (y_butter-min_y_butter)/(max_y_butter-min_y_butter);
    %x_norm_butter = (columns/2)*(x_butter-min_x_butter)/(max_x_butter-min_x_butter);
    
    %x = x_norm_butter(1:co_ktora:co_ktora*(columns/2));
    y = y_norm_butter(1:co_ktora:co_ktora*(columns/2));
    y_inverse = zeros(size(y));
    y_inverse = y(end:-1:1);
    butter_window = [y_inverse; y ];
    


end


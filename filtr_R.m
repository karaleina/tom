function [ filtr_norm ] = filtr_R( columns )
%FILTR_R  
    k = linspace(1, columns, columns);
    shift = k - columns/2 - 1;
    filtr_norm = abs(shift)/max(abs(shift));
end


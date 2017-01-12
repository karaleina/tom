function reko = mbp(przefiltrowany_sinogram, columns, rows)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

    sigma = pi/rows;
    przesuniecie = columns/2+0.5;
    reko = zeros(columns);
    for x = 1:columns 
        for y = 1:columns 

            reko(x,y) = 0;

            for alfa = 1:rows

                jakiesk = (x-przesuniecie)*cos(alfa*sigma) + ...
                    (y-przesuniecie)*sin(alfa*sigma)+przesuniecie;
                jakiesk = round(jakiesk);

                if (jakiesk<1 || jakiesk>columns)
                    continue;
                end

                reko(x,y) = reko(x,y) + przefiltrowany_sinogram(jakiesk,alfa);

            end

            reko(x,y) = reko(x,y)*sigma;

        end
    end

end


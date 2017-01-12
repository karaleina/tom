function [ img ] = add_noise( img, percent )
%ADD_NOISE Function which add noise to the image
    szum = randn(size(img))*percent/100*mean(img(:));
    img = img + szum;
end


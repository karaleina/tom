clear all;
close all;
clc;

%% Wczytywanie danych i dodawanie szumu
sinogram=fopen('wyjscie_bez_szumu.txt','r');
A = fread(sinogram, [256, 300],'short');

procent_szumu = 0.1;
A = add_noise(A, procent_szumu);

figure(1)
imagesc(A);
title(['Sinogram dla szumu: ' num2str(procent_szumu) '%']);
colormap(gray(256));
colorbar;

%% Robienie widma FFT
widma = fft(A);

%% Filtr |R|, okna dla filtru, postać kołowa

figure(2)
columns = 256;
x = linspace(1, columns, columns) - columns/2 - 1;
filtr = filtr_R(columns);

% Symetryczny filtr |R|
subplot(2,2,1)
plot(x, filtr);
title('Filtr |R|');

% Okno protokątne
fg = 100;
rectangular_window = rectangular_window(columns, fg);

% Okno Butterwortha


%Rysowanie okien
subplot(2,2,2)
plot(x, rectangular_window);
title('Okno')
legend(['prostokątne o fg = ' num2str(fg)]);

% Filtr kołowy
filtr_fft = ifftshift(filtr);
subplot(2,2,3)
plot(filtr_fft);
title('Filtr kołowy |R|');

% Dziedzina f - filtr kołowy z oknem
rectangular_window_fft = ifftshift(rectangular_window); 
filtr_with_rectangular_window = filtr_fft .* rectangular_window_fft;
subplot(2,2,4)
plot(filtr_with_rectangular_window)
title('Filtr kołowy z funkcją okna');
legend(['prostokątne o fg = ' num2str(fg)]);

%% 

for i=1:size(widma,2)
    
iloczyn(:,i)=widma(:,i).*filtr_fft';

end

przefiltrowany=(ifft(iloczyn));
figure(3)
imagesc(przefiltrowany, [0 25]);     %[0 25] CLIM czyli CLOW i CHIGH - scaling
title('Przefiltrowany sinogram')
colormap(gray(256));
colorbar;

%%
%Robimy wsteczną projekcję

sigma=pi/size(widma,2);
przesuniecie=columns/2+0.5;
reko=zeros(256);
for x=1:256 
    for y=1:256 

        reko(x,y)=0;
        
        for alfa=1:300
        
            jakiesk=(x-przesuniecie)*cos(alfa*sigma) + ...
                (y-przesuniecie)*sin(alfa*sigma)+przesuniecie;
            jakiesk=round(jakiesk);
              
            if (jakiesk<1 || jakiesk>columns)
                continue;
            end
        
            reko(x,y)=reko(x,y)+przefiltrowany(jakiesk,alfa);
        
        end
        
        reko(x,y)=reko(x,y)*sigma;
        
    end
end
%%
figure(4)
imagesc(reko, [15 25]);
title('Zrekonstruowany Fantom')
colormap(gray(256));
colorbar;

%%

figure(5)
plot(reko(256/2,:));
clear all;
close all;
clc;

%% Wczytywanie danych i dodawanie szumu
sinogram=fopen('wyjscie_bez_szumu.txt','r');
A = fread(sinogram, [256, 300],'short');
columns = 256;
rows = 300;

procent_szumu = 1;
A = add_noise(A, procent_szumu);

figure(1)
imagesc(A);
title(['Sinogram dla szumu: ' num2str(procent_szumu) '%']);
colormap(gray(256));
colorbar;

%% Robienie widma FFT
widma = fft(A);

%% Filtr |R|, okna dla filtru, postać kołowa
filtr = filtr_R(columns);

rectangular_window = rectangular_window(columns, 100);
butter_window = butter_window(columns, 22)';
hamming_window = hamming(columns)';

rectangular_window_fft = ifftshift(rectangular_window);
butter_window_fft = ifftshift(butter_window);
hamming_window_fft = ifftshift(hamming_window);

filtr_fft = ifftshift(filtr);
filtr_with_rectangular_window_fft = filtr_fft .* rectangular_window_fft;
filtr_with_butter_window_fft = filtr_fft .* butter_window_fft;
filtr_with_hamming_window_fft = filtr_fft .* hamming_window_fft;

%% Rysowanie wyników działania filtrów
figure(2)
x = linspace(1, columns, columns) - columns/2 - 0.5;

subplot(2,2,1)
plot(x, filtr);
title('Filtr |R|');
axis([-128, 128, 0, 1.1]);
grid on;

subplot(2,2,2)
plot(x, rectangular_window, 'r'); hold on;
plot(x, butter_window, 'b');
plot(x, hamming_window, 'g');
legend('prostokątne', 'Butterwortha', 'Hamminga');
title('Okna')
axis([-128, 128, 0, 1.1]);
grid on;

subplot(2,2,3)
plot(filtr_fft);
title('Filtr kołowy |R|');
axis([-1,257, 0, 1.1]);
grid on;

subplot(2,2,4)
plot(filtr_with_rectangular_window_fft, 'r'); hold on;
plot(filtr_with_butter_window_fft, 'b'); hold on;
plot(filtr_with_hamming_window_fft, 'g');
title('Filtr kołowy z funkcją okna');
legend('prostokątną', 'Butterwortha', 'Hamminga');
axis([-1,257, 0, 1.1]);
grid on;

%% Dla wszystkich filtrów przefiltrowane sinogramy
filtry_fft = [filtr_fft;
              filtr_with_rectangular_window_fft;
              filtr_with_butter_window_fft;
              filtr_with_hamming_window_fft;];
titles = {' dla filtru |R|';
    ' dla filtru |R| z oknem prostokątnym';
    ' dla filtru |R| z oknem Butterwortha';
    ' dla filtru |R| z oknem Hamminga'} ;
 
%Pętla po wszystkich filtach    
for j = 1:1:length(filtry_fft(:,1)) 
    iloczyn = [];
    mpb = [];
    przefiltrowany_sinogram = [];
    for i = 1:size(widma, 2)
        iloczyn(:,i) = widma(:,i).*filtry_fft(j,:)';
    end
    przefiltrowany_sinogram = real((ifft(iloczyn)));

    figure(3)
    subplot(2,2, j)
    imagesc(przefiltrowany_sinogram, [0 25]);
    title(['Przefiltrowany sinogram' titles(j, :)]);
    colormap(gray(256));
    colorbar;
   
    %Robimy wsteczną projekcję
    mpb = mbp(przefiltrowany_sinogram, columns, rows);

    figure(4)
    subplot(2,2, j)
    imagesc(mpb, [15 25]);
    title(['Zrekonstruowany fantom' titles(j, :)]);
    colormap(gray(256));
    colorbar;

    figure(5)
    subplot(2,2, j)
    plot(mpb(256/2,:));
    title(['Zmiany jasności' titles(j, :)]);
end
 
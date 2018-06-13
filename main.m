% main file for speech enhancement
clear all
clc
close all
%% noisy speech production
% model y=s+n
% choose one clean speech
[s, Fs]=audioread('clean_speech.wav');
% [s, Fs]=audioread('clean_speech_2.wav');
% sound(s,Fs);
% choose one noise
% [n, Fn]=audioread('babble_noise.wav');
% [n, Fn]=audioread('aritificial_nonstat_noise.wav');
[n, Fn]=audioread('Speech_shaped_noise.wav');
% add clean speech and noise together
f=1;%factor used to control the power of noise
n=f*n;
length=length(s);
y=s+n(1:length);
%% visualize the noisy speech signal
figure
plot(y, 'b')
hold on
plot(f*n, 'g')
hold off
xlabel('time/s');
ylabel('input signal amplitude');
title('Signal in time domain');
legend('Noisy Speech', 'Noise');
axis([1 100000 -0.6 0.6])
% sound(y,Fs);
%% frame segmentation
T=20;% length of frame in ms.
N=T/1000*Fs;%number of samples within one frame
w=Modhanning(N);%use hannning window, when time shif is 10ms...
...signal power preserved
%wvtool(w);%display the window in both time and frequency domain
L=floor((length-N)/(N/2))+1;%number of frames
yl=segmentation(N, w, y, L);
nl=segmentation(N, w, n, L);
%% FFT
Yl=fft(yl);
Nl=fft(nl);
mag_Yl=abs(Yl);
ang_Yl=angle(Yl);%in radian, most speech enhancement methods...
...only modify the magnitude of the DFT coefficients
mag_Nl=abs(Nl);
%% PSD estimation
P_YYl=mag_Yl.*mag_Yl;%noisy speech PSD
P_NNl_t=mag_Nl.*mag_Nl;%true noise PSD for check later
%% variance reduction
M=9;%average over M frames
P_YYl_B=bartlett(M, L, P_YYl);
%% Minimum Statistics
Q_YYl=ms(M, L, P_YYl_B);
% bias compensation
B=1.1;
P_NNl=Q_YYl*B;%noise PSD
%% speech enhancement
sl=wiener_filter(P_NNl, P_YYl_B, ang_Yl, mag_Yl);
%% overlapping addition
s_est=overlapadd(sl, N, L, length);
sound(s_est,Fs);
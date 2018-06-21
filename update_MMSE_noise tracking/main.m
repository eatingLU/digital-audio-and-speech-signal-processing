% main file for speech enhancement
clear all
clc
close all
dbstop if error
% noisy speech production
% model y=s+n
% choose one clean speech
[s, Fs]=audioread('clean_speech.wav');
% [s, Fs]=audioread('clean_speech_2.wav');
% sound(s,Fs);
% choose one noise
[n, Fn]=audioread('babble_noise.wav');
% [n, Fn]=audioread('aritificial_nonstat_noise.wav');
% [n, Fn]=audioread('Speech_shaped_noise.wav');
% add clean speech and noise together
f=10;%factor used to control the power of noise
n=f*n;
len=length(s);
start=1;
s=s(start:start+len-1);
n=n(start:start+len-1);
y=s+n;
%sound(y, Fs);
%% visualize the noisy speech signal
figure
plot(y, 'b')
hold on
plot(n, 'g')
hold off
xlabel('time/s');
ylabel('input signal amplitude');
title('Signal in time domain');
legend('Noisy Speech', 'Noise');
% axis([1 100000 -0.6 0.6])
%% frame segmentation
T=20;% length of frame in ms.
N=T/1000*Fs;%number of samples within one frame
w=Modhanning(N);%use hannning window, when time shif is 10ms...
% w=bartlett(N);
...signal power preserved
% wvtool(w);%display the window in both time and frequency domain
L=floor((len-N)/(N/2))+1;%number of frames
Yl=segmentation(N, w, y, L);
Sl=segmentation(N, w, s, L);
Nl=segmentation(N, w, n, L);
%% FFT
mag_Yl=abs(Yl);
ang_Yl=angle(Yl);%in radian, most speech enhancement methods...
...only modify the magnitude of the DFT coefficients
mag_Nl=abs(Nl);
mag_Sl=abs(Sl);
%% PSD estimation
P_YYl=mag_Yl.*mag_Yl;
P_NNl_t=mag_Nl.*mag_Nl;
P_SSl_t=mag_Sl.*mag_Sl;
%% variance reduction
M=8;%average over M frames
P_YYl_B=bartlett_smooth(M, L, P_YYl);
% P_YYl_B=Bartlett_P(P_YYl,M);
alpha=0.85;
P_YYl_E=exponential_smooth(alpha, P_YYl);
P_NNl_t=exponential_smooth(alpha, P_NNl_t);
%% visualization of smooth
figure
k=50;%choose a frequency bin
start=1000;
l=200;%number of time frames to show
plot(start:l+start-1, P_YYl(k, start:l+start-1),'Color',[0,0,0.5], 'LineStyle', ':', 'LineWidth', 1.2);
hold on
plot(start:l+start-1, P_YYl_B(k, start:l+start-1), 'LineWidth', 1.2);
plot(start:l+start-1, P_YYl_E(k, start:l+start-1), 'LineWidth', 1.2);
hold off
xlabel('frame');
ylabel('amplitude');
title('Variance reduction');
legend(['Periodogram |Y|^2(k=' num2str(k) ')'],['smoothed periodogram(k=' num2str(k) ') using Bartlett smoother with M=8'], ['smoothed periodogram(k=' num2str(k) ') using exponential smoother with \alpha=0.85']);
%% noise tracking
% minimum statisticas
M=8;
% P_NNl_MS=ms(M, L, P_YYl_B);%Baetlett smoother
P_NNl_MS=ms(M, L, P_YYl_E);%exponential smoother
% VAD
% assume the prior SNR and posterior SNR is known
% P_NNl_VAD=vad(mag_Sl, mag_Nl, P_YYl_B);
P_NNl_VAD=vad(mag_Sl, mag_Nl, P_YYl_E);
% MMSE based noise power estimation
% P_NNl_MMSE=MMSE_noise(P_YYl_B);
P_NNl_MMSE=MMSE_noise(P_YYl_E);
%% visualization of noise tracking
figure
start=1;
l=250;
k=30;
plot(start:start+l-1,P_NNl_t(k,start:start+l-1),'LineWidth', 1.2);
hold on
plot(start:start+l-1,P_NNl_MS(k,start:start+l-1),'LineWidth', 1.2);
plot(start:start+l-1,P_NNl_MMSE(k,start:start+l-1),'LineWidth', 1.2);
% plot(start:start+l-1,P_NNl_VAD(k,start:start+l-1),'LineWidth', 1.2);
hold off
title('Noise PSD estimate');
legend(['true noise PSD with k=' num2str(k) ],['noise tracking via minimum statistics with k=' num2str(k)],['noise tracking via MMSE with k=' num2str(k)]);%['noise tracking via VAD with k=' num2str(k)]);
xlabel('frame');
ylabel('amplitude');
%% speech enhancement
% sl=wiener_filter(P_NNl_MS, P_YYl_B, Yl);
% sl=wiener_filter(P_NNl_MS, P_YYl_E, Yl);
% sl=wiener_filter(P_NNl_MMSE, P_YYl_B, Yl);
sl=wiener_filter(P_NNl_MMSE, P_YYl_E, Yl);
% sl=subtract(P_NNl, P_YYl_B, ang_Yl);
% sl=nonlinear_MMSE(P_NNl_MS, P_YYl_B, Yl);
% sl=nonlinear_MMSE(P_NNl_MS, P_YYl_E, Yl);
% sl=nonlinear_MMSE(P_NNl_MMSE, P_YYl_B, Yl);
% sl=nonlinear_MMSE(P_NNl_MMSE, P_YYl_E, Yl);
%% overlapping addition
s_est=overlapadd(sl, N, L, len);
% n_est=y(1:length(s_est))-s_est;
% sound(s_est,Fs);
% audiowrite('wiener_result.wav',s_est,Fs);
%% time domain visualization
% figure
% subplot(311)
% plot(s)
% title('clean speech');
% xlabel('time/s');
% ylabel('amplitude');
% subplot(312)
% plot(y)
% title('noisy speech with artificial nonstationary noise');
% xlabel('time/s');
% ylabel('amplitude');
% subplot(313)
% plot(s_est)
% title('estimate speech');
% xlabel('time/s');
% ylabel('amplitude');

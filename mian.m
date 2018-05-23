clear all
clc
close all
% model y=s+n
[s, Fs]=audioread('clean_speech.wav');%sampled data, sampled rate in Hertz
% sound(s,Fs);
%[S, Fs]=audioread('clean_speech_2.wav');
%%
% [n, Fn]=audioread('babble_noise.wav');
% [n, Fn]=audioread('aritificial_nonstat_noise.wav');
[n, Fn]=audioread('Speech_shaped_noise.wav');
y=s+n(1:length(s),:);
sound(y,Fs);
%% speech segmentation
N=2^10;%length of a frame
w=hamming(N);
% wvtool(w);%display the window in both time and frequency domain
L=floor(length(s)/N);
yl=zeros(N,L);
j=1;
for i=1:L
    yl(:,i)=w.*y(j:j+N-1);%add up to 1
    j=j+N/2;%overlapping=0.5
end
%% FFT
Yl=fft(yl);
mag_Yl=abs(Yl);
ang_Yl=angle(Yl);%in radian most speech enhancement methods...
...only modify the magnitude of the DFT coefficients
%% PSD estimation
P_YYl=1/N*mag_Yl.*mag_Yl;
%% Minimum statistics 
%Bartlett estimate to reduce the variance
M=9;
P_YYl_B=P_YYl;
for i=1+(M-1)/2:L-(M-1)/2
    P_YYl_B(:,i)=mean(P_YYl(:,i-2:i+2),2);
end
M=21;
Q_YYl=P_YYl_B;
for i=1+(M-1)/2:L-(M-1)/2
    Q_YYl(:,i)=min(P_YYl(:,i-2:i+2),[],2);
end
B=1.1;
P_NNl=Q_YYl*B;%bias compensation
%% power spectral subtraction
P_SSl=P_YYl_B-P_NNl;
P_SSl=max(P_SSl,0.0002);
mag_Sl=sqrt(N*P_SSl);
Sl=mag_Sl.*exp(1i*ang_Yl);
sl=ifft(Sl);
s_est=zeros(length(s),1);
s_est(1:N)=sl(1:N,1);
for i=2:L
    s_est((i-1)*N/2+1:i*N/2)=s_est((i-1)*N/2+1:i*N/2,1)+sl(1:N/2,i);
    s_est(i*N/2+1:(i+1)*N/2)=sl(N/2+1:N,i);
end
% sound(real(s_est),Fs);
%% Wiener smoother
%find the optimal impulse response such that s=h*y



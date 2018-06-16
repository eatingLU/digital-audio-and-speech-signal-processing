clear all
clc
close all
[s, Fs]=audioread('clean_speech.wav');%sampled data, sampled rate in Hertz
% sound(s,Fs);
% [S, Fs]=audioread('clean_speech_2.wav');
[n, Fn]=audioread('babble_noise.wav');
% [n, Fn]=audioread('aritificial_nonstat_noise.wav');
% [n, Fn]=audioread('Speech_shaped_noise.wav');
% model y=s+n
f=1;
y=s+f*n(1:length(s));
% sound(y,Fs);
%% speech segmentation
N=320;%length of a frame
w=Modhanning(N);
% wvtool(w);%display the window in both time and frequency domain
L=floor((length(s)-N)/(N/2))+1;%number of frames after segmentation
yl=zeros(N,L);
nl=zeros(N,L);
j=1;
for i=1:L
    yl(:,i)=w.*y(j:j+N-1);%add up to 1
    nl(:,i)=f*w.*n(j:j+N-1);%scaled noise, nonstationary noise has too small power
    j=j+N/2;%overlapping=0.5, each frame shift N/2
end
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
%% Reduce the variance
%Bartlett estimate to reduce the variance
M=9;
P_YYl_B=P_YYl;
for i=1+(M-1)/2:L-(M-1)/2
    P_YYl_B(:,i)=mean(P_YYl(:,(i-(M-1)/2):(i+(M-1)/2)),2);
end
%exponential smoother
% alpha=0.90;
% P_YYl_E=P_YYl;
% for i=2:L-1
%     P_YYl_E(:,i)=alpha*P_YYl_E(:,i-1)+(1-alpha)*P_YYl_E(:,i);
% end
%% Minimum statistics 
M=9;
Q_YYl=P_YYl_B;
for i=1:L-M
    Q_YYl(:,i)=min(P_YYl_B(:,i:i+M-1),[],2);
end
%% bias compensation
B=1.1;
P_NNl=Q_YYl*B;
%% power spectral subtraction
P_SSl=P_YYl_B-P_NNl;
% P_SSl=P_YYl-P_NNl_t;%check with true noise PSD
P_SSl=max(P_SSl,0);
mag_Sl=sqrt(P_SSl);
Sl=mag_Sl.*exp(1i*ang_Yl);
sl=ifft(Sl);
s_est=zeros(length(s),1);
s_est(1:N)=sl(1:N,1);
for i=2:L
    s_est((i-1)*N/2+1:i*N/2)=s_est((i-1)*N/2+1:i*N/2,1)+sl(1:N/2,i);
    s_est(i*N/2+1:(i+1)*N/2)=sl(N/2+1:N,i);
end
s_est=real(s_est);
sound(s_est,Fs);
n_est=y-s_est;
% sound(n,Fs);
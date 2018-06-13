function [s]=wiener_filter(PSD_n, PSD_y, angle_y, mag_y)
% Wiener smoother
% find the optimal impulse response such that s=h*y
Hl=1-PSD_n./PSD_y;%gain function
% Hl=1-P_NNl_t./P_YYl_B;
S=Hl.*mag_y.*exp(1i*angle_y);
s=ifft(S);
end
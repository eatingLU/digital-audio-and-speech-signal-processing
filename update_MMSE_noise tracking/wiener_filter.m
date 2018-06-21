function [sl]=wiener_filter(PSD_n, PSD_y, Yl)
% Wiener smoother
% find the optimal impulse response such that s=h*y
Hl=1-PSD_n./PSD_y;%gain function
% Hl=1-P_NNl_t./P_YYl_B;
Sl=Hl.*Yl;
sl=ifft(Sl);
end
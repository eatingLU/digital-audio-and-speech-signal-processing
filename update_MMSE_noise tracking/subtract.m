function sl=subtract(P_NNl, P_YYl_B, ang_Yl)
% power spectral subtraction
P_SSl=P_YYl_B-P_NNl;
% P_SSl=P_YYl-P_NNl_t;%check with true noise PSD
P_SSl=max(P_SSl,0);
mag_Sl=sqrt(P_SSl);
Sl=mag_Sl.*exp(1i*ang_Yl);
sl=ifft(Sl);
end
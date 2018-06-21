function [P_NNl]=ms(M, L, s)
% Minimum statistics 
s_ms=s;
for i=1:L-M+1
    s_ms(:,i)=min(s(:,i:i+M-1),[],2);
end
% bias compensation
B=1;
P_NNl=s_ms*B;%noise PSD
end
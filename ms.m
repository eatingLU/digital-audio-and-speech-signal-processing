function [s_ms]=ms(M, L, s)
% Minimum statistics 
s_ms=s;
for i=1:L-M
    s_ms(:,i)=min(s(:,i:i+M-1),[],2);
end
end
function [s_B]=bartlett_smooth(M, L, s)
%Bartlett estimate to reduce the variance
s_B=s;
for i=M:L
    s_B(:,i)=mean(s(:,i-M+1:i),2);
end
%exponential smoother
% alpha=0.90;
% P_YYl_E=P_YYl;
% for i=2:L-1
%     P_YYl_E(:,i)=alpha*P_YYl_E(:,i-1)+(1-alpha)*P_YYl_E(:,i);
% end
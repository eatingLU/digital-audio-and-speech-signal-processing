function [s_B]=bartlett(M, L, s)
%Bartlett estimate to reduce the variance
s_B=s;
for i=1+(M-1)/2:L-(M-1)/2
    s_B(:,i)=mean(s(:,(i-(M-1)/2):(i+(M-1)/2)),2);
end
%exponential smoother
% alpha=0.90;
% P_YYl_E=P_YYl;
% for i=2:L-1
%     P_YYl_E(:,i)=alpha*P_YYl_E(:,i-1)+(1-alpha)*P_YYl_E(:,i);
% end
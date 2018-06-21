function P_NNl=MMSE_noise(P_YYl_B)
P_NNl=zeros(size(P_YYl_B));
P_NNl(:,1)=P_YYl_B(:,1);%the first frame is noise only
xi=15;%optimal a prior SNR;
xi=10^(xi/10);
Pl=zeros(size(P_YYl_B));
alpha_pow=0.8;
P_H1=zeros(size(P_YYl_B));
E_NNl=zeros(size(P_YYl_B));
for j=2:size(P_YYl_B,2)
     % a posterior SPP
     P_H1(:,j)=1./(1+(1+xi)*exp(-P_YYl_B(:,j)*xi./(P_NNl(:,j-1)*(1+xi))));
     % recursively smooth P_H1 over time
     Pl(:,j)=0.9*Pl(:,j-1)+0.1*P_H1(:,j);
     % force the current a posterior SPP to be lower than 0.99
     P_H1(Pl(:,j)>0.99)=0.99;
% if (Pl(:,j)>0.99)
%     P_H1(:,j)= min(P_H1(:,j),0.99);%noise must be smaller than noisy speech
% end
     % MMSE estimator under speech presense uncertainty
     E_NNl(:,j)=(1-P_H1(:,j)).*P_YYl_B(:,j)+P_H1(:,j).*P_NNl(:,j-1);
     % recursive smoothing
     P_NNl(:,j)=alpha_pow*P_NNl(:,j-1)+(1-alpha_pow)*E_NNl(:,j);
end
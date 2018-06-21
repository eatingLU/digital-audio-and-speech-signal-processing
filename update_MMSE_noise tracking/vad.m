function P_NNl=vad(mag_Sl, mag_Nl, P_YYl)
vs=var(mag_Sl,0,2);
vn=var(mag_Nl,0,2);
P_NNl=zeros(size(P_YYl));
P_NNl(:,1)=P_YYl(:,1);
alpha=0.95;
for j=2:size(P_YYl,2)
    for i=1:size(P_YYl,1)
        H1=normpdf(sqrt(P_YYl(i,j)),0,sqrt(vn(i)));
        H0=normpdf(sqrt(P_YYl(i,j)),0,sqrt(vn(i)+vs(i)));
        if H1>H0
            P_NNl(i,j)=alpha*P_NNl(i,j-1)+(1-alpha)*P_NNl(i,j);
        else
            P_NNl(i,j)=P_NNl(i,j-1);
        end
    end
end
%combine the likelihood ratios for all frequencies into one decision
% for j=2:size(P_YYl_B,2)
%     H1=mean(log10(normpdf(P_YYl_B(:,j),0,sqrt(vn))));%noise presence
%     H0=mean(log10(normpdf(P_YYl_B(:,j),0,sqrt(vs+vn))));%noise abscence
%     if H1>H0
%         P_NNl(:,j)=alpha*P_NNl(:,j-1)+(1-alpha)*P_NNl(:,j);
%     else
%         P_NNl(:,j)=P_NNl(:,j-1);
%     end
% end
end
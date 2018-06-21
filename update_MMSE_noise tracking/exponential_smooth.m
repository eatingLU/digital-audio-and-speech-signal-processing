function P_YYl_E=exponential_smooth(alpha, P_YYl)
P_YYl_E=zeros(size(P_YYl));
P_YYl_E(:,1)=P_YYl(:,1);
for j=2:size(P_YYl,2)
    P_YYl_E(:,j)=alpha*P_YYl_E(:,j-1)+(1-alpha)*P_YYl(:,j);
end
end
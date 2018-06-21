function s=nonlinear_MMSE(P_NNl, P_YYl_B, Yl)
nu=0.15;
xi_db=15;
xi=10^(xi_db/10);
P_NNl=max(P_NNl,0.001);
zeta=P_YYl_B./P_NNl;
Sl=zeros(size(P_NNl));
for j=1:size(P_NNl,2)
    for i=1:size(P_NNl,1)
            gs=nu*xi/(nu+xi)*kummerU(nu+1,2,xi*zeta(i,j)/(nu+zeta(i,j)))/kummerU(nu,1,xi*zeta(i,j)/(nu+zeta(i,j)));
            Sl(i,j)=gs*Yl(i,j);
    end
end
s=ifft(Sl);
end

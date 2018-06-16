function s=nonlinear_MMSE(P_NNl, P_YYl_B, Yl)
nu=0.15;
v_S=max(P_YYl_B-P_NNl,0);
v_N=P_NNl;
xi=v_S./v_N;
zeta=P_YYl_B./P_NNl;
Sl=zeros(size(P_NNl));
for j=1:size(P_NNl,2)
    for i=1:size(P_NNl,1)
        if v_S(i,j)==0
            Sl(i,j)=0;
        else
            gs=nu*xi(i,j)/(nu+xi(i,j))*kummerU(nu+1,2,xi(i,j)*zeta(i,j)/(nu+zeta(i,j)))/kummerU(nu,1,xi(i,j)*zeta(i,j)/(nu+zeta(i,j)));
            Sl(i,j)=gs*Yl(i,j);
        end
    end
end
s=ifft(Sl);
end

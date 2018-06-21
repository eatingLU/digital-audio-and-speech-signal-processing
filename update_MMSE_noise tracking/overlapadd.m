function [s_est]=overlapadd(s, N, L, length)
% overlapping add
s_est=zeros(length,1);
s_est(1:N)=s(:,1);
for i=2:L
    s_est((i-1)*N/2+1:i*N/2)=s_est((i-1)*N/2+1:i*N/2,1)+s(1:N/2,i);
    s_est(i*N/2+1:(i+1)*N/2)=s(N/2+1:N,i);
end
s_est=real(s_est);
end
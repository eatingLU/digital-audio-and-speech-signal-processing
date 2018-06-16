function [s_seg]=segmentation(N, w, s, L)
s_seg=zeros(N,L);
j=1;
for i=1:L
    s_seg(:,i)=w.*s(j:j+N-1);
    j=j+N/2;%overlapping=0.5, each frame shift N/2
end
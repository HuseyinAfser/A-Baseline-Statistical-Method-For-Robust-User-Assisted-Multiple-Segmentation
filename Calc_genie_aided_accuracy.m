function [accuracy] = Calc_genie_aided_accuracy(G_new,dec,S,K,K_hat)
% Author: Huseyin Afşer
% This function calculates the accuracy (IoU) for the decisions, dec, of the DGL
% test. The first index of accuracy is the initial segmentation accuracy
% while the remaining ones are the accuracies if a genie aided user
% optimally relabels the (partially) mislabeled superpixels.
% The accuracy is increasing with a monotonilyy decreasing rate. 
% This results from the fact that the genie aided user first
% corrects the superpixels that will increase the accuracy most.

z=find(G_new == dec(:,:,1) & G_new~=0);
z_l=length(z);
z_non_zero_l=length(find(G_new ~=0));
M=size(dec,3);

for i=1:M
    E(:,:,i)= G_new~=dec(:,:,i);
end

for j=1:K_hat
    [r1,c1]=size(find(S==j & E(:,:,1)~=0 & G_new~=0));
    e_1(j)=r1;
    [t1,t2]=size(find(S==j & G_new~=0));
    cor=t1-r1;
    r2=zeros(M,1);
    for i=2:M
        [r2(i),c2(i)]=size(find(S==j & E(:,:,i)==0 & G_new~=0));
    end
    e_1(j)=max(max(r2)-cor,0);
end

[e_sorted,indexes]=sort(e_1,'descend');
l_e=length(nonzeros(e_sorted));
accuracy(1)=z_l;

accuracy(2:1+l_e)=z_l+cumsum(e_sorted(1:l_e));

if l_e<K
    accuracy(2+l_e:K+1)=max(accuracy(:));
end

accuracy=accuracy/z_non_zero_l;

end
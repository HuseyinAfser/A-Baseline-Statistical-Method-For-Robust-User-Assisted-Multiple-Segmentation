function [I,Gt,M] = read_BSDS_image(im_name)
% Author: Huseyin Afşer
% This function reads a BSDS500 image,I, and returns the ground truth
% masks, Gt, from multiple annotations until %90 of the image is covered it. 
% This is needed due to oversegmentation in images. 
% The function also returns the number of segments, M, for each image.

cd data/images/;

l_name=length(im_name);
im_num=im_name(1:l_name-4);

f_name =strcat(im_num,'.jpg');
I=imread(f_name);
cd ../; cd groundTruth/;
load(strcat( im_num,'.mat'));
cd ../; cd ../; 

[h,v]=size(I(:,:,1));
g=groundTruth;
[v,b]=size(g); Gt=zeros(b,h,v); M=zeros(b,1);

for a=1:b
    G=g{1,a}.Segmentation;
    M_real=double(max(max(G)));
    g_edges=0.5:1:(M_real+0.5);

    [hist_G,hist_g_indexes]=sort(histcounts(G,g_edges),'descend');
    
    hist_G= hist_G/sum(hist_G);
    cum_hist_G=cumsum(hist_G);
    
    t=1;
    while cum_hist_G(t)<=0.90   % consider at least %90 percent of labaled images
       t=t+1;
    end
    M(a)=t;

    for i=1:M(a)
        m=hist_g_indexes(i);
        [row,col]=find(G==m);
        l=length(row);
        for j=1:l
            Gt(a,row(j),col(j))=i;
        end
    end

end
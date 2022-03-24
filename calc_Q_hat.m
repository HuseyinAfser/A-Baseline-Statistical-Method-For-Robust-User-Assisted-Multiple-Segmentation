function [Q_hat] = calc_Q_hat(I,G,size_of_X,M,hist_edges,UI_type,UI_amount)
% Author: Huseyin Afşer
% This function calculates the nominal distributions, Q_hat,in eq(5) 
% from the user inputs with specified amount.
% UI type 1 : a fraction of labeled pixels from ground truth masks
% UI type 2 : a number of seed points within ground truth masks
% UI type 3 : a fraction of labeled pixels from bounding boxes
% UI type 4 : pixels from randomly perturbedbounding boxes
% UI amout : {1,0.75,0.5,0.25} for UI type 1, 3
% UI amout : {10,15,20} for UI type 2
% UI amout : {5,10,15} for UI type 4

[h,v]=size(I(:,:,1));
Q_hat=zeros(size_of_X,size_of_X,M);

square_length=50; % Use squares width side length 50 whose center is the seed point

if UI_type ==1 | UI_type==2

    for i=1:M
        [row,col]=find(G==i);
        l=length(row);
        for j=1:l
            G_new(row(j),col(j))=i;
        end
        p=randperm(l);
        row=row(p);
        col=col(p);
       if UI_type==1
            l=round(l*UI_amount);
            q_g=zeros(l,2);
            for j=1:l
                q_g(j,1)=I(row(j),col(j),1);
                q_g(j,2)=I(row(j),col(j),2);
            end
            hist_G=histcounts2(q_g(:,1),q_g(:,2),hist_edges,hist_edges);
            hist_G=hist_G/sum(sum(hist_G));
       else
           mask=zeros(h,v);
           z_a=[];z_b=[];
           for k=1:UI_amount
               in=randi([1 l]);
               p(i,1)=row(in);
               p(i,2)=col(in);
               r_1=max(p(i,1)-square_length/2,1);
               r_2=min(p(i,1)+square_length/2,h);
               c_1=max(p(i,2)-square_length/2,1);
               c_2=min(p(i,2)+square_length/2,v);
               mask(r_1:r_2,c_1:c_2,1)=1;
           end
           [r,c]=find(mask==1);
            m_l=length(r);
            for t=1:m_l
                z_1(t,1)=I(r(t),c(t),1);
                z_2(t,1)=I(r(t),c(t),2);
            end
            hist_G=histcounts2(z_1,z_2,hist_edges,hist_edges);
            hist_G=hist_G/sum(sum(hist_G));
       end
       Q_hat(:,:,i)=hist_G;
    end

elseif UI_type ==3 || UI_type==4
    for i=1:M
        [row,col]=find(G==i);
        l=length(row);
        G_1=zeros(h,v);
        G_L=zeros(h,v);
        for j=1:l
            G_1(row(j),col(j),i)=i;
        end
        G_L(:,:,i)=bwlabel(G_1(:,:,i),4);
        stats = regionprops(G_L(:,:,i),'BoundingBox');
        z=stats(1).BoundingBox;
        c1=round(z(1));
        r1=round(z(2));
        c2=z(3);
        r2=z(4);
        if c2*r2==1
            z=stats(2).BoundingBox;
            c1=round(z(1));
            r1=round(z(2));
            c2=z(3);
            r2=z(4);
        end
        if UI_type==3
            z_1=reshape(I(r1:r1+r2-1,c1:c1+c2-1,1),[],1);
            z_2=reshape(I(r1:r1+r2-1,c1:c1+c2-1,2),[],1);
            l1=r2*c2;
            p=randperm(l1);
            z_1=z_1(p);
            z_2=z_2(p);
            z_a=z_1(1:round(l1*UI_amount),1);
            z_b=z_2(1:round(l1*UI_amount),1);
            hist_G=histcounts2(z_a,z_b,hist_edges,hist_edges);
            hist_G=hist_G/sum(sum(hist_G));
        else
            tr=UI_amount/2;
            r_1=randi([max(round(r1-r2*(tr/100)),1), min(round(r1+r2*(tr/100)),h)]);
            c_1=randi([max(round(c1-c2*(tr/100)),1), min(round(c1+c2*(tr/100)),v)]);
            r_2=randi([min(round(r1+r2*(100-tr)/100),h), min(round(r1+r2*(100+tr)/100),h)]);
            c_2=randi([min(round(c1+c2*(100-tr)/100),v), min(round(c1+c2*(100+tr)/100),v)]);
            z_1=reshape(I(r_1:r_2,c_1:c_2,1),[],1);
            z_2=reshape(I(r_1:r_2,c_1:c_2,2),[],1);
            hist_G=histcounts2(z_1,z_2,hist_edges,hist_edges);
            hist_G=hist_G/sum(sum(hist_G));
        end
        Q_hat(:,:,i)=hist_G;
    end
end
function [accuracy,I_seg,G_t,I] = DGL_Based_Robust_Segmentation(f_name,K,size_of_X,UI_type,UI_amount)
% Author: Huseyin Afşer
% This function calculates the accuracy of a BSDS image by averaging it multiple user 
% annotations. 

[I,Gt,M_red] = read_BSDS_image(f_name);  % Reads BSDS image and ground truth

[b,h,v]=size(Gt);
I_hsv=rgb2hsv(I);

[S,K_hat] = superpixels(I,K); % Use SLIC superpixels in Matlab
BW = boundarymask(S);

hist_edges=0:1/size_of_X:1;
for a=1:b        % loop over muliple annotations
    G_new=squeeze(Gt(a,:,:));
    M = M_red(a);
    [Q_hat] = calc_Q_hat(I_hsv,G_new,size_of_X,M,hist_edges,UI_type,UI_amount); %  Calculate Q_hat the nominal
    % distributions to be used in DGL test

[A] = Calc_A_HS_domain(Q_hat,M,size_of_X);
[fa] = Prob_A_HS_domain(Q_hat,A,M,size_of_X);
disp(strcat('Segmenting ',' user annotation ',num2str(a),' of ',num2str(b),' of ',f_name,...
    'for UI type: ',num2str(UI_type), ' and UI amount: ', num2str(UI_amount)));
tic
dec_int=zeros(M,K_hat);
    for j=1:K_hat  % loop over superpixels
        [row,col]=find(S==j); %% Gather pixels from superpixels to be used in DGL test
        l=length(row);
        x=zeros(l,2);
        for i=1:l
            x(i,1)=I_hsv(row(i),col(i),1);
            x(i,2)=I_hsv(row(i),col(i),2);
        end
        dec_int(:,j) = DGLSegment_HS_domain(x,A,fa,M,size_of_X);
        for i=1:l
            for k=1:M
                dec(row(i),col(i),k)=dec_int(k,j);
            end
        end
    end

dec=dec.*[dec & G_new];

%figure;
I_seg = labeloverlay(I,dec(:,:,1),'Transparency',0.60); 
I_seg= imoverlay(I_seg,BW,'black'); % segmented image superposed one superpixels
%imshow(I_seg);

G_t = labeloverlay(I,G_new,'Transparency',0.60);
G_t=  imoverlay(G_t,BW,'black');   % ground truth mask superposed one superpixels

accuracy(:,a)=Calc_genie_aided_accuracy(G_new,dec,S,K,K_hat); % Calculate genie-aided accuracy, accuracy(1,a) is the initial
disp(strcat('accuracy is ',num2str(accuracy(1,a)))); % segmentation accuracy for user annotation a
toc
end

accuracy=mean(accuracy')'; % average accuracy over multiple annotations.




function aver_accuracy = testbench_UI_type_amount(UI_type,UI_amount)
% Author: Huseyin Afşer
% This function calculates the average accuracy (averaged over multiple images and multiple annotations)
% for a chosen UI type and UI amount in the HS domain

K=500;          % number of superpixels
size_of_X=392;  % the alphabet size for linear complexity in the number of pixels sqrt(321x481)
                % increasing it will improve the average accuracy around %3 to %5
                % but simulation time will also increase

cd DATA/images/; % locations of the BSDS 500 test images 
Files=dir('*.jpg');
cd ../; cd ../; 
L=length(Files);
accuracy=zeros(K+1,L);
for i=1:L
   tic
   im_name=Files(i).name;
   [accuracy(:,i),~,~,~] = DGL_Based_Robust_Segmentation(im_name,K,size_of_X,UI_type,UI_amount);
end
aver_accuracy=mean(accuracy,2);




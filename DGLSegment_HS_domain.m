function [dec] = DGLSegment_HS_domain(x,A,fa,M,size_of_X)
% Author: Huseyin Afşer
% This function implements the DGL test, eq (6) and (7) in the paper, for the vector of pixels
% in a given superpixel.
d=zeros(M,M-1,M-1);
if M>1   % When considering 90% of labeled pixels some images have only 1 regions. This line avoids an error. 
   for i=1:M-1
       for j=i+1:M
        mu_n= Calc_mu_HS_domain(x,A(:,:,i,j),size_of_X);
            for k=1:M
                d(k,i,j)=abs(fa(k,i,j)-mu_n);
                s(k)=max(max(d(k,:,:)));
            end
       end
    end
[aa,indices]=sort(s,'ascend');
 dec=indices;
else
    dec=1;
end

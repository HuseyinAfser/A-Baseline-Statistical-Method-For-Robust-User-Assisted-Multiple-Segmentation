function [A] = Calc_A_HS_domain(Q,M,X)
% Author: Huseyin Afser
% This function calculates the borel sets in eq (6) in the 2D HS domain
% with equally spaces histogram bins.
A= uint8(zeros(X,X,M,M)); 
for i=1:M-1
    for j=i+1:M
        [row,col]=find(Q(:,:,i)>Q(:,:,j));
        l=length(row);
        for t=1:l
            A(row(t),col(t),i,j)=1;
        end
    end
end


function [fa] = Prob_A_HS_domain(Q,A,M,X)
% Author: Huseyin Afser
% This function calculates the probability, \int_{A}Q_hat(A), of the borel
% sets in eq (7).
fa=zeros(M,M,M);
for k=1:M
    for i=1:M-1
        for j=i+1:M
            d=double(A(:,:,i,j)).*Q(:,:,k);
            z(:,1)=trapz(d);
            fa(k,i,j)=sum(sum(z));
        end
    end
end


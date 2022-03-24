function [mu_n] = Calc_mu_HS_domain(x,A,size_of_X)
% Author: Huseyin Afser
% This function calculates the statistics mu_n(A) in eq(7)

n=length(x);
edges=0:1/size_of_X:1-1/size_of_X;
I=0;
for i=1:n
       L_h=find(edges<=x(i,1));
       L_v=find(edges<=x(i,2));
       i_h=max(L_h);
       i_v=max(L_v);      
        if A(i_h,i_v)==1
             I=I+1;
        end
end
mu_n=I/n;
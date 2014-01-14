function [A_hat, COV_hat, errors] = OLSestimation(data, T0, L, const)

% settings
T = size(data, 1);
K = size(data, 2);

% estimateCoeff
Y = data(L+1:T, :);
X = zeros(T-L,K*L+const);

for iii = 1:T-L,
    for zzz = 1:const,
        X(iii,zzz) = (iii+T0)^(zzz-1);
    end;
    for jjj = 1:L,
        X(iii,const+(jjj-1)*K+1:const+jjj*K) = data(iii-jjj+L,:);
    end;
end;
A_hat = (X'*X)^-1*X'*Y;
errors = Y - X*A_hat;
COV_hat = errors'*errors;
function [A_hat, COV_hat, errors] = arOLSestimation(data, T0, L, const)

% settings
T = size(data, 1);
K = size(data, 2);
arA_hat = NaN(L+const,1,K);
A_hat = zeros(L*K+const,K);
COV_hat = zeros(K,K);

for kkk = 1:K,
    % estimateCoeff
    Y = data(L+1:T, kkk);
    X = zeros(T-L,L+const);

    for iii = 1:T-L,
        for zzz = 1:const,
            X(iii,zzz) = (iii+T0)^(zzz-1);
        end;
        for jjj = 1:L,
            X(iii,const+(jjj-1)+1:const+jjj) = data(iii-jjj+L,kkk);
        end;
    end;
    arA_hat(:,:,kkk) = (X'*X)^-1*X'*Y;
    errors = Y - X*arA_hat(:,:,kkk);
    COV_hat(kkk,kkk) = errors'*errors/(T-1-const);
    
    % re-order A_hat
    if const > 0, 
        A_hat(1,kkk) = arA_hat(1,1,kkk);
    end;
    for lll = 1:L
        A_hat(const+kkk+(lll-1)*K,kkk) = arA_hat(const+lll,1,kkk);
    end;
end;
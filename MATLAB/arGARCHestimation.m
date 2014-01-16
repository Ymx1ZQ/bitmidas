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
    
    spec=garchset('variancemodel','GARCH','r', L, 'C', const, 'display', 'off');        
    [coeff,errors,llf,innovation,sigma,summary]=garchfit(spec, data(:,kkk));
    
    COV_hat(kkk,kkk) = innovation'*innovation/(T-L-const);    
    
    % re-order A_hat
    if const > 0, 
        A_hat(1,kkk) = coeff.C;
    end;
    for lll = 1:L
        A_hat(const+kkk+(lll-1)*K,kkk) = coeff.AR(lll);
    end;
end;

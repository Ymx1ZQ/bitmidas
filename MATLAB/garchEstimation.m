function [A_hat, COV_hat, errors] = garchEstimation(data, T0, L, const)

% settings
T = size(data, 1);
K = size(data, 2);

spec=garchset('variancemodel','constant','r',L);
[coeff,errors,llf,innovation,sigma,summary] = garchfit(spec, data);

%garchdisp(coeff,errors);
A_hat = coeff;
COV_hat = errors'*errors;
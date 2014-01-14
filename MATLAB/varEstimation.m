function [A_hat] = varEstimation(data, L, const)

% settings
T = size(data, 1);
K = size(data, 2);

modelSpec = vgxset('n', K, 'nAR', L, 'Constant', const);
[estSpec, estStdErr]=vgxvarx(modelSpec, data);
estBeta = vgxget(estSpec, 'AR');
if const == true,
    estAlpha = vgxget(estSpec, 'a');
else
    estAlpha = [];
end;

A_hat = estAlpha';
for iii=1:L,
    A_hat = [A_hat; estBeta{iii}'];
end;
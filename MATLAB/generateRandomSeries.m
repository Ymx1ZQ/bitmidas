function [series] = generateRandomSeries(A_hat, startingPoint, innovations, const)

T0 = size(startingPoint,1);
K = size(A_hat, 2);
L = (size(A_hat, 1) - const)/K;
H = size(innovations,1);
series = zeros(T0+H,K);

series(1:T0,:)=startingPoint;
for iii = T0+1:T0+H,
    dataX = zeros(1,K*L+const);
    if const > 0,
        dataX(1,zzz) = 1;
    end;
    for jjj = 1:L,
        dataX(1,const+(jjj-1)*K+1:const+jjj*K) = series(iii-jjj,:, kkk);
    end;
    series(iii,:) = dataX*A_hat + innovations(iii,:);
end;
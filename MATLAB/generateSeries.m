function [series] = generateSeries(A_hat, startingPoint, innovations, const)

T0 = size(startingPoint,1);
K = size(A_hat, 2);
L = (size(A_hat, 1) - const)/K;
H = size(innovations,1);
series = zeros(T0+H,K);

series(1:T0,:)=startingPoint;
for iii = T0+1:T0+H,
    dataX = zeros(1,K*L+const);
    if const > 0,
        dataX(1,1) = 1;
    end;
    for jjj = 1:L,
        dataX(1,const+(jjj-1)*K+1:const+jjj*K) = series(iii-jjj,:);
    end;
    series(iii,:) = dataX*A_hat + innovations(iii-T0,:);
    
    % controls
    series(iii,1) = max(0.1, series(iii,1));
    series(iii,2) = max([0.1, series(iii,1)+0.1, series(iii,2)]);
    series(iii,3) = max(0, series(iii,3));
end;
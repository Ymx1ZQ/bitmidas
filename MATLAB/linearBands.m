function [bandsBid, bandsAsk] = linearBands(A_hat, relevantData, errors, T0, H, simulations, percentiles, const)

T = size(relevantData,1);
K = size(relevantData,2);
L = (size(A_hat, 1) - const)/K;
data = [zeros(T+H,K,simulations)];

for kkk=1:simulations,
    data(1:T,:,kkk)=relevantData;
    for iii = T+1:T+H,
        dataX = zeros(1,K*L+const);
        for zzz = 1:const,
            dataX(1,zzz) = (iii+T0)^(zzz-1);
        end;
        for jjj = 1:L,
            dataX(1,const+(jjj-1)*K+1:const+jjj*K) = data(iii-jjj,:, kkk);
        end;
        data(iii,:,kkk) = dataX*A_hat + errors(fix(rand()*(T-L))+1,:);
    end;
end;
percentileIndexes = fix(percentiles.*simulations)+1;

pricesBid = sort(data(T:end,1,:),3);
pricesAsk = sort(data(T:end,2,:),3);
bandsBid = pricesBid(:,:,percentileIndexes);
bandsAsk = pricesAsk(:,:,percentileIndexes);

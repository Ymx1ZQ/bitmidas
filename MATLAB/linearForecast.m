function [forecast] = linearForecast(A_hat, relevantData, H, const)

T = size(relevantData,1);
K = size(relevantData,2);
L = (size(A_hat, 1) - const)/K;
data = zeros(T+H,K);

data(1:T,:)=relevantData;
for iii = T+1:T+H,
    dataX = zeros(1,K*L+const);
    if const>0,
        dataX(1,1) = 1;
    end;
    for jjj = 1:L,
        dataX(1,const+(jjj-1)*K+1:const+jjj*K) = data(iii-jjj,:);
    end;
    data(iii,:) = dataX*A_hat;
end;
forecast = data(T+1:end,:);
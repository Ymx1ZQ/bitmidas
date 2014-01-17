function [bands] = bollingerBands(data, MAlags, sensitivity)
    [T, K] = size(data);
    MA = NaN(T,K);
    stDev = NaN(T,K);
    bands = NaN(T,K,2);
    
    for iii = MAlags:T
        stDev(iii,:) = var(data(iii-MAlags+1:iii,:)).^0.5;
        MA(iii,:) = mean(data(iii-MAlags+1:iii,:));
        bands(iii,:,1) = MA(iii,:)-sensitivity*stDev(iii,:);
        bands(iii,:,1) = MA(iii,:)+sensitivity*stDev(iii,:);
    end;
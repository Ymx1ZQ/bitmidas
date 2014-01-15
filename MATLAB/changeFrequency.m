function [data, withinVolatility] = changeFrequency(oldData, frequency) % in minutes... it's actually 1/frequency

% preparing bins
T = size(oldData,1);
length = fix(T/frequency);
data = NaN(length, 3);
withinVolatility = NaN(length, 3);

% filling bins (from the most recent data)
for iii = 1:length,
    data(length+1-iii,:) = mean(oldData(T-iii*frequency+1:T-(iii-1)*frequency,:),1);
    withinVolatility(length+1-iii,:) = var(oldData(T-iii*frequency+1:T-(iii-1)*frequency,:),1).^0.5;
end;

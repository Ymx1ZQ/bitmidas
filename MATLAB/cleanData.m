% clean Data
clc;
clear;
display('We''re cleaning your data for you');

% settings
binWidth = 60; % seconds

% loading data
rawData = csvread('raw_data.csv',1);
rawData(:,3) = rawData(:,3)*10^-2; %BTC-USD *10^-2; LTC-EUR *2*10^-4;

% preparing bins
T = size(rawData,1);
length = fix((rawData(end,4)-rawData(1,4))/binWidth);
data = NaN(length, 3);

% filling bins (from the most recent data)
jjj = T;
for iii = 1:length,
    toAverage = [];
    while rawData(jjj,4) > rawData(end,4)-(iii)*binWidth,
        toAverage = [toAverage; rawData(jjj,1:3)];
        jjj = jjj-1;
    end;
    if isempty(toAverage) == false,
        data(length-iii+1,:) = mean(toAverage,1);
    else
        data(length-iii+1,:) = NaN(1,3);
    end
    jjj = jjj-1;
end;

% filling missing data for long gaps
iii = 1;
while iii < size(data,1), 
    if isnan(data(iii,1)),
        jjj = 1;    
        gapLenght = 1;
        while (iii+jjj <= size(data,1)) && (isnan(data(iii+jjj))),            
            gapLenght = gapLenght + 1;
            jjj = jjj+1;
        end;
        if gapLenght > 120,
            data(iii+120:iii+gapLenght,:) = [];
        end;
    end;
    iii = iii+1;
end;

% filling missing data for all gaps
for iii = 1:size(data,1),
    if isnan(data(iii,1)),
        fakeDev = var(data(max(1,iii-5):max(1,iii-1),:)).^0.5;
        data(iii,:) = nanmean(data(max(1,iii-60):min(iii+60,end),:),1)+randn()*fakeDev;
    end;
end;

% duplicating data (as a mirrorw)
% data = [data(end:-1:1,:); data];


% saving data
plot(data);
csvwrite('data.csv',data);
% performing all forecasts!!
clc;
clear;
close all;
display('we''re forecasting for you...');
warning('off');

% loading data
data = (csvread('data.csv',1));
%data = generateData(1000);

frequency = 60; % in minutes... it's actually 1/frequency
[data, withinVolatility] = changeFrequency(data, frequency);

% settings
H = 20; % estimated values taken into account
sampleForEstimation = 320;
sampleForBands = 180;
L = 2;
fees = [0.002, 0.002];
const = 0;

T = size(data, 1);
K = size(data, 2);

start1 = sampleForEstimation-1; % the game starts at start1 + 1
start2 = start1+sampleForBands+H; % the bands starts at start2 + 1

forecast = NaN(T+H, K, H);
stdev = NaN(T+H, K, H);

A_hat = NaN(const+L*K,K,T);
%modelSpec = vgxset('n', K, 'nAR', L, 'Constant', const);

% estimation
for iii = start1+1:T,
    relevantData = data(iii-sampleForEstimation+1:iii,:);
    %[A_hat(:,:,iii)] = OLSestimation(relevantData, 0, L, const);    
    %[A_hat(:,:,iii)] = arGARCHestimation(relevantData, 0, L, const);    
    [A_hat(:,:,iii)] = arOLSestimation(relevantData, 0, L, const);
    waitB=waitbar(iii/T/3);
end;

% prediction
for iii = start1+1:T,
    relevantData = data(iii-sampleForEstimation+1:iii,:);
    todayForecast = linearForecast(A_hat(:,:,iii), relevantData, H, const);
    forecast(iii,:,:) = permute(todayForecast,[3,2,1]);
    waitB=waitbar(1/3+iii/T/3);
end;

% computing stdev
for jjj = 1:H,
    for iii = start2+1:T,
        errors = data(iii-sampleForBands:iii-1,:) - forecast(iii-sampleForBands-jjj:iii-jjj-1,:,jjj);
        stdev(iii,:,jjj) = var(errors).^0.5;
        %plot(errors(:,1));
        %pause;
    end;
    waitB=waitbar(2/3+iii/T/3);
end;

close(waitB);

% save all computations
save('computations.mat');

display('we computed for you and saved everything in "computations.mat"');
display(' ');
display('BYE BYE!!');



% plot forecasts
showH = 1;
startPicture = showH+1;
endPicture = T;
bandsSigmas = 1;

% forecast bid
plot(forecast(startPicture-showH:endPicture-showH,1,showH)+bandsSigmas*stdev(startPicture-showH:endPicture-showH,showH), 'b-.');
hold on;    
plot(forecast(startPicture-showH:endPicture-showH,1,showH)-bandsSigmas*stdev(startPicture-showH:endPicture-showH,showH), 'b-.');
hold on;        
% forecast ask
plot(forecast(startPicture-showH:endPicture-showH,2,showH)+bandsSigmas*stdev(startPicture-showH:endPicture-showH,showH), 'r-.');
hold on;    
plot(forecast(startPicture-showH:endPicture-showH,2,showH)-bandsSigmas*stdev(startPicture-showH:endPicture-showH,showH), 'r-.');
hold on;        

% data
plot(data(startPicture:endPicture,1), 'k-')
plot(data(startPicture:endPicture,2), 'k-')    
hold on; 

nanmean(stdev)
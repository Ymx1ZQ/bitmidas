% performin all forecasts!!
clc;
clear;
close all;
display('we''re computing for you...');

% loading data
data = (csvread('data.csv',1));
%data = generateData(1000);

frequency = 30; % in minutes... it's actually 1/frequency
data = changeFrequency(data, frequency);

% settings
H = 10; % estimated values taken into account
sampleForEstimation = 360;
sampleForBands = 360;
L = 4;
fees = [0.002, 0.002];
const = 1;

T = size(data, 1);
K = size(data, 2);

start1 = sampleForEstimation-1; % the game starts at start1 + 1
start2 = start1+sampleForBands+H; % the bands starts at start2 + 1

forecast = NaN(T+H, 2, H);
stdev = NaN(T+H, 2, H);

A_hat = NaN(const+L*K,K,T);
%modelSpec = vgxset('n', K, 'nAR', L, 'Constant', const);

% estimation
for iii = start1+1:T,
    relevantData = data(iii-sampleForEstimation+1:iii,:);
    [A_hat(:,:,iii)] = OLSestimation(relevantData, 0, L, const);    
    waitB=waitbar(iii/T/3);
end;

% prediction
for iii = start1+1:T,
    relevantData = data(iii-sampleForEstimation+1:iii,:);
    [pricesBid, pricesAsk] = linearForecast(A_hat(:,:,iii), relevantData, H, const);
    forecast(iii,:,:) = [permute(pricesBid,[3,2,1]), permute(pricesAsk,[3,2,1])];
    waitB=waitbar(1/3+iii/T/3);
end;

% computing stdev
for jjj = 1:H,
    for iii = start2+1:T,
        errors = data(iii-sampleForBands:iii-1,1:2) - forecast(iii-sampleForBands-H:iii-H-1,1:2,H);
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

%{
% show predictions
startPicture = start2;
endPicture = T;
figure(1);
subplot(2,1,1);
plot([forecast(startPicture-H:endPicture-H,1,H)+stdev(startPicture-H:endPicture-H,H),forecast(startPicture-H:endPicture-H,1,H)-stdev(startPicture-H:endPicture-H,H), data(startPicture:endPicture,1)])
subplot(2,1,2);
plot([forecast(startPicture-H:endPicture-H,2,H)+stdev(startPicture-H:endPicture-H,H),forecast(startPicture-H:endPicture-H,2,H)-stdev(startPicture-H:endPicture-H,H), data(startPicture:endPicture,2)])
%}

% TEST
clc;
clear;

% loading data
data = csvread('data.csv',1);
data = data(40001:41000,:);
T = size(data, 1);
K = size(data, 2);

% settings
H = 5; % estimated values taken into account

% estimation settings
sampleForEstimation = 360;
sampleForBands = 360;
L = 5;
const = 1;

start1 = sampleForEstimation-1; % the game starts at start1 + 1
start2 = start1+sampleForBands+H; % the bands starts at start2 + 1

forecast = NaN(T+H, 2);
bands = NaN(T+H, 2, 2);

A_hat = NaN(const+L*K,K,T);
COV = NaN(K,K,T);

% start the game with montecarlo
for iii = start1+1:T,
    relevantData = data(iii-sampleForEstimation+1:iii,:);
    [A_hat(:,:,iii), COV(:,:,iii), ~] = OLSestimation(relevantData, iii, L, const);
    [pricesBid, pricesAsk] = linearForecast(A_hat(:,:,iii), relevantData, iii, H, const);
    forecast(iii+H,:) = [pricesBid(end,:), pricesAsk(end,:)];
    waitbar(iii/T);
end;

% compute bands
errors = data(start1+H+1:start2, 1:2) - forecast(start1+H+1:start2,:);
% for iii = start2+1:T,
%     [A_hat, COV, errors] = OLSestimation(data, iii, L, const);
%     [pricesBid, pricesAsk] = montecarlo(A_hat, data, errors, iii, H, simulations, percentiles, const);
%     bandsforecastBid(iii-start,:) = pricesBid(end,:);
%     forecastAsk(iii-start,:) = pricesAsk(end,:);    
% end;

% compute bands
% subplot(2,1,1)
% plot(data(181:550,1))
% subplot(2,1,2)
% plot(forecast(181:550,1))

plot([data(start2+1:start2+50,1),forecast(start2+1:start2+50,1)])

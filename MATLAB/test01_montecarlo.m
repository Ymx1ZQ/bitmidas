% TEST
clc;
clear;

% loading data
data = csvread('data.csv',1);
T = size(data, 1);

% settings
H = 15; % estimated values taken into account
start = 179; % the game starts at start + 1

% estimation settings
sampleForEstimation = 180;
L = 6;
const = 1;
percentiles = [0.16, 0.5, 0.84];
simulations = 1000;

forecast = zeros(T-start, size(percentiles,2));

% start the game with montecarlo
for iii = start+1:T,
    relevantData = data(iii-sampleForEstimation+1:iii,:);
    [A_hat, COV, errors] = OLSestimation(data, iii, L, const);
    [bandsBid, bandsAsk] = montecarlo(A_hat, data, errors, iii, H, simulations, percentiles, const);
    forecastBid(iii-start,:) = bandsBid(end,:);
    forecastAsk(iii-start,:) = bandsAsk(end,:);
    bar = waitbar((iii-start)/(T-start));
end;
close(bar);

% TEST
clc;
clear;

% loading data
data = (csvread('data.csv',1));
data = data(2001:3000,:);
data = generateData(1000);
T = size(data, 1);
K = size(data, 2);

% settings
H = 10; % estimated values taken into account
sampleForEstimation = 300;
sampleForBands = 300;
L = 2;
fees = [0.002, 0.002];
const = 1;

start1 = sampleForEstimation-1; % the game starts at start1 + 1
start2 = start1+sampleForBands+H; % the bands starts at start2 + 1

forecast = NaN(T+H, 2, H);
stdev = NaN(T+H, 2, H);

A_hat = NaN(const+L*K,K,T);
portfolio = NaN(T+H,2);
choices = NaN(T+H,1);
%modelSpec = vgxset('n', K, 'nAR', L, 'Constant', const);

% estimation
for iii = start1+1:T,
    relevantData = data(iii-sampleForEstimation+1:iii,:);
    [A_hat(:,:,iii)] = OLSestimation(relevantData, 0, L, const);    
    ciao=waitbar(iii/T);
end;

% prediction
for iii = start1+1:T,
    relevantData = data(iii-sampleForEstimation+1:iii,:);
    [pricesBid, pricesAsk] = linearForecast(A_hat(:,:,iii), relevantData, H, const);
    forecast(iii,:,:) = [permute(pricesBid,[3,2,1]), permute(pricesBid,[3,2,1])];
    ciao=waitbar(iii/T);
end;

% computing stdev
for jjj = 1:H,
    for iii = start2+1:T,
        errors = data(iii-sampleForBands:iii-1,1:2) - forecast(iii-sampleForBands-H:iii-H-1,1:2,H);
        stdev(iii,:,jjj) = var(errors).^0.5;
    end;
    ciao=waitbar(jjj/H);
end;


% making choices
portfolio(start2,:) = [1, 0]; 
for iii = start2+1:T,
    % chose what to do in iii, given the information set at iii-1
    choices(iii,:) = chooseLuca01(portfolio(iii,:),forecast(iii,:,:), stdev(iii,:,:)); % -1: sell, 0: wait, 1 buy
end;


plot([data(start2:start2+50,1) forecast(start2-H:start2-H+50,1,H)]);

%{
% computing returns
for iii = start2+1:T,
    if choice(iii) = -1, % sell
        portfolio(1) = portfolio(2) * data(2, iii) * (1-fees(2));
        portfolio(2) = 0;
    end;
    if choice(iii) = 1, % buy
        portfolio(2) = portfolio(1) / data(1, iii) * (1-fees(1));
        portfolio(1) = 0;
    end;
end;
%}
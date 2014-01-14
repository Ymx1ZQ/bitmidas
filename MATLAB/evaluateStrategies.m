% evaluationg strategies
clc;
clear;
close all;
display('we''re evaluating for you...');

% loading data
load('computations.mat');

% settings
nStrategies = 4;
startPlaying = start2+H; % all strategies start from start2+1+H
%startPlaying = 3500;

portfolio = NaN(T,2, nStrategies);
choices = NaN(T+H, nStrategies);
returns = NaN(nStrategies,1);
historicalReturns = NaN(nStrategies,1);


for iii = 1:nStrategies,
    portfolio(startPlaying,:,iii) = [1, 0]; 
end;

% making choices and making actions
for jjj = 1:nStrategies,
    historicalAsk = data(start2+1, 2);
    if jjj == 1,
        lastAskPriceUsed = 0;
    end;
    for iii = startPlaying+1:T,
        % chose what to do in iii, given the information set at iii 
        % % -1: sell, 0: wait, 1 buy
        
        switch jjj
            case 1,
                [choices(iii, jjj), lastAskPriceUsed] = choose001_luca(portfolio(1:iii-1,:,jjj), data(1:iii-1,:,:), fees, forecast(1:iii-1,:,:), stdev(1:iii-1,:,:), lastAskPriceUsed);
            case 2,
                choices(iii, jjj) = choose002_maBase(portfolio(1:iii-1,:,jjj), data(1:iii-1,:,:), fees, forecast(1:iii-1,:,:), stdev(1:iii-1,:,:));
            case 3,
                 choices(iii, jjj) = choose003_maPaolo(portfolio(1:iii-1,:,jjj), data(1:iii-1,:,:), fees, forecast(1:iii-1,:,:), stdev(1:iii-1,:,:));
            otherwise % buy at time0 and then wait until the end
                if iii == startPlaying+1, 
                    choices(iii, jjj) = 1;
                else
                    choices(iii, jjj) = 0;
                end;
        end;
        
        
        % making actions
        switch choices(iii, jjj)
            case -1, % sell
                portfolio(iii, 1, jjj) = portfolio(iii-1, 2, jjj) * data(iii, 1) * (1-fees(2));
                portfolio(iii, 2, jjj) = 0;
            case 1, % buy
                portfolio(iii, 2, jjj) = portfolio(iii-1, 1, jjj) / data(iii, 2) * (1-fees(1));
                portfolio(iii, 1, jjj) = 0;
                historicalAsk = data(iii, 2);
            case -2, % stop loss
                portfolio(iii, 2, jjj) = NaN;
                portfolio(iii, 1, jjj) = NaN;
                historicalAsk = data(iii, 2);
            otherwise
                portfolio(iii, :, jjj) = portfolio(iii-1, :, jjj);
        end;
        waitB = waitbar((jjj-1+(iii-start2)/(T-start2))/nStrategies);
    end;
    returns(jjj) = portfolio(iii, 1, jjj) + portfolio(iii, 2, jjj) * mean(data(iii, 1:2));
    historicalReturns(jjj) = portfolio(iii, 1, jjj) + portfolio(iii, 2, jjj) * historicalAsk;
end;
close(waitB);
display(' ');
returns
historicalReturns
display(' ');
display('we evaluated for you');
display(' ');
display('BYE BYE!!');


% plot strategies
startPicture = H+1;
endPicture = T;
H = 3;
bandsSigmas = 1/3;
% startPicture = 3000;
% endPicture = 3200;


for jjj = 1:nStrategies,
    actions = NaN(T,3);
    for iii= 1:T,
        switch choices(iii, jjj)
            case -1, % sell
                actions(iii,1) = data(iii, 1);
            case 1, % buy
                actions(iii,2) = data(iii, 2);
            case -2, % stop loss
                actions(iii,3) = mean(data(iii, 1:2));
            otherwise
                actions(iii,:) = NaN(1,3);
        end;        
    end;

    figure(jjj);

    % forecast bid
    plot(forecast(startPicture-H:endPicture-H,1,H)+bandsSigmas*stdev(startPicture-H:endPicture-H,H), 'b-.');
    hold on;    
    plot(forecast(startPicture-H:endPicture-H,1,H)-bandsSigmas*stdev(startPicture-H:endPicture-H,H), 'b-.');
    hold on;        
    % forecast ask
    plot(forecast(startPicture-H:endPicture-H,2,H)+bandsSigmas*stdev(startPicture-H:endPicture-H,H), 'r-.');
    hold on;    
    plot(forecast(startPicture-H:endPicture-H,2,H)-bandsSigmas*stdev(startPicture-H:endPicture-H,H), 'r-.');
    hold on;        
    
    % data
    plot(data(startPicture:endPicture,1), 'k-')
    plot(data(startPicture:endPicture,2), 'k-')    
    hold on; 
    
    % actions    
    scatter(1:(endPicture-startPicture+1), actions(startPicture:endPicture,1), 'b', 'fill');
    hold on;
    scatter(1:(endPicture-startPicture+1), actions(startPicture:endPicture,2), 'r', 'fill');    
    
end;
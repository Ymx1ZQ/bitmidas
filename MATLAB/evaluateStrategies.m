% evaluating strategies
clc;
clear;
close all;
display('we''re evaluating for you...');
warning('off');

% loading data
load('computations.mat');

% settings
nStrategies = 6;
startPlaying = start2+H; % all strategies start from start2+1+H
%startPlaying = 201;

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
    timeWait = 6*60/frequency; % after a stop_loss, wait for at least 6 hours before starting again
    if jjj == 1, % extra settings for choice001_Luca
        lastAskPriceUsed = 0;
    end;
    for iii = startPlaying+1:T,
        % chose what to do in iii, given the information set at iii-1
        % -1: sell, 0: wait, 1 buy
        if choices(iii-1, jjj) == -2,
            waitFor = waitFor -1;
            if waitFor < 0,
                choices(iii, jjj) = 0;
            else
                choices(iii, jjj) = -2;
            end;
        else
            switch jjj
                case 1,
                    [choices(iii, jjj), lastAskPriceUsed] = choose001_luca(portfolio(1:iii-1,:,jjj), data(1:iii-1,:,:), fees, forecast(1:iii-1,:,:), stdev(1:iii-1,:,:), withinVolatility(1:iii-1,:,:), frequency, lastAskPriceUsed);
                case 2,
                    choices(iii, jjj) = choose002_maBase(portfolio(1:iii-1,:,jjj), data(1:iii-1,:,:), fees, forecast(1:iii-1,:,:), stdev(1:iii-1,:,:), withinVolatility(1:iii-1,:,:), frequency);
                case 3,
                    choices(iii, jjj) = choose003_maPaolo(portfolio(1:iii-1,:,jjj), data(1:iii-1,:,:), fees, forecast(1:iii-1,:,:), stdev(1:iii-1,:,:), withinVolatility(1:iii-1,:,:), frequency);
                case 4,
                    choices(iii, jjj) = choose004_basicRule(portfolio(1:iii-1,:,jjj), data(1:iii-1,:,:), fees, forecast(1:iii-1,:,:), stdev(1:iii-1,:,:), withinVolatility(1:iii-1,:,:), frequency);
                case 5,
                    choices(iii, jjj) = choose005_maWithStoploss(portfolio(1:iii-1,:,jjj), data(1:iii-1,:,:), fees, forecast(1:iii-1,:,:), stdev(1:iii-1,:,:), withinVolatility(1:iii-1,:,:), frequency);
                otherwise % buy at time0 and then wait until the end
                    if iii == startPlaying+1, 
                        choices(iii, jjj) = 1;
                    else
                        choices(iii, jjj) = 0;
                    end;
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
                if portfolio(iii-1, 2, jjj) > 0,
                    %disp(['stoploss at time ', num2str(iii), ' ... SELL!']);
                    portfolio(iii, 1, jjj) = portfolio(iii-1, 2, jjj) * data(iii, 1) * (1-fees(2));
                    portfolio(iii, 2, jjj) = 0;
                    waitFor = timeWait;
                else
                    %disp(['stoploss time... waiting for human action!']);
                    portfolio(iii, :, jjj) = portfolio(iii-1, :, jjj);
                end;
                historicalAsk = data(iii, 2);
            otherwise
                portfolio(iii, :, jjj) = portfolio(iii-1, :, jjj);
        end;
        waitB = waitbar((jjj-1+(iii-start2)/(T-start2))/nStrategies);
    end;
    % compute whole-period returns
    returns(jjj) = portfolio(iii, 1, jjj) + portfolio(iii, 2, jjj) * mean(data(iii, 1:2));
    historicalReturns(jjj) = portfolio(iii, 1, jjj) + portfolio(iii, 2, jjj) * historicalAsk;
end;

% compute sharpe ratios
sharpeBinWeight = 60*24;
returnBinWeight = sharpeBinWeight/frequency; % sharpeBinWeight minutes / oneDividedByFrequency ... returnBins of 1 day lenght
nReturnBins = fix((T-startPlaying)/returnBinWeight);
returnBins = NaN(nReturnBins,nStrategies);
for iii = 1:nReturnBins,    
    for jjj = 1:nStrategies,
        startValue = portfolio(T-iii*returnBinWeight+1, 1, jjj) + portfolio(T-iii*returnBinWeight+1, 2, jjj) * mean(data(T-iii*returnBinWeight+1, 1:2));        
        endValue = portfolio(T-(iii-1)*returnBinWeight, 1, jjj) + portfolio(T-(iii-1)*returnBinWeight, 2, jjj) * mean(data(T-(iii-1)*returnBinWeight, 1:2));
        returnBins(iii,jjj) = endValue/startValue - 1;
    end;
end;
sharpeRatios = (mean(returnBins)./(var(returnBins).^0.5))'; % in annualized terms!!

% annualize
annualSharpeRatios = sqrt(returnBinWeight*frequency) * sharpeRatios;
tradingTime = (T-startPlaying)*frequency;
minutesPerYear = 365*24*60;
annualReturns = (returns).^(minutesPerYear/tradingTime)-1; % annualized
annualHistoricalReturns = (historicalReturns).^(minutesPerYear/tradingTime)-1; % annualized
annualSharpeReturns = ((1+mean(returnBins)).^(minutesPerYear/sharpeBinWeight)-1)'; % annualized

% display results
close(waitB);
display(' ');
annualSharpeRatios
annualReturns
annualHistoricalReturns
annualSharpeReturns 
save('strategies.mat');
display(' ');
display('we evaluated for you, and saved the result in strategies.mat');
display(' ');
display('BYE BYE!!');


% plot strategies
startPicture = H+1;
endPicture = T;
H = 3;
bandsSigmas = 1/3;

for jjj = 1:nStrategies,
    actions = NaN(T,3);
    for iii= 1:T,
        switch choices(iii, jjj)
            case -1, % sell
                actions(iii,1) = data(iii, 1);
            case 1, % buy
                actions(iii,2) = data(iii, 2);
            case -2, % stop loss
                actions(iii,3) = data(iii, 2);
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
    hold on;
    scatter(1:(endPicture-startPicture+1), actions(startPicture:endPicture,3), 'g', 'fill');
    hold on;
end;
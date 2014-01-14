function [choice, newLastAskPriceUsed] = choose001_luca(portfolio, data, fees, forecast, stdev, lastAskPriceUsed)
    % -1: sell; 0: wait; 1: buy; -2: stop loss
    choice = 0;
    newLastAskPriceUsed = lastAskPriceUsed;
    %H = size(forecast, 10);
    H = 1;
    sensitiveness = 3;
    T = size(data,1);
    if portfolio(T,1) > portfolio(T,2), 
%             disp('****');
%             (1-fees(2))*data(T,1)
%             forecast(T-H,2,H)+stdev(T-H,2,H)/6
%             pause    
        % I buy if 
        % 1) bid price of today is bigger than ask price estimated H
        %    times ago for today, by at least stdev/3
        if data(T,2) < forecast(T-H,2,H)-stdev(T-H,2,H)/sensitiveness,
            choice = 1;
            newLastAskPriceUsed = data(T,2);
        end;
    elseif portfolio(T,1) < portfolio(T,2), 
        % I sell if
        % 1) ask price of today is lower than bid price estimated H
        %    times ago for today, by at least stdev/3
        % AND 
        % 2) price todayI don't lose money!
                
        if (data(T,2) > forecast(T-H,2,H) + stdev(T-H,2,H)/sensitiveness) && ((1-fees(2))*data(T,1)>lastAskPriceUsed),
            choice = -1;            
        end;
    end;
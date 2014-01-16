function [choice, newLastAskPriceUsed] = choose001_luca(portfolio, data, fees, forecast, stdev, withinVolatility, frequency, lastAskPriceUsed)
    % -1: sell; 0: wait; 1: buy; -2: stop loss
    choice = 0;
    newLastAskPriceUsed = lastAskPriceUsed;
    %H = size(forecast, 10);
    H = 1;
    ruleSensitivity = 1/6;
    T = size(data,1);
    if portfolio(T,1) > portfolio(T,2), 
%             disp('****');
%             (1-fees(2))*data(T,1)
%             forecast(T-H,2,H)+sensitiveness*stdev(T-H,2,H)
%             pause    
        % I buy if 
        % 1) bid price of today is bigger than ask price estimated H
        %    times ago for today, by at least stdev/3
        if data(T,2) < forecast(T-H,2,H)-ruleSensitivity*stdev(T-H,2,H),
            choice = 1;
            newLastAskPriceUsed = data(T,2);
        end;
    elseif portfolio(T,1) < portfolio(T,2), 
        % I sell if
        % 1) ask price of today is lower than bid price estimated H
        %    times ago for today, by at least stdev/3
        % AND 
        % 2) price todayI don't lose money!
        
        if (data(T,2) > forecast(T-H,2,H) + ruleSensitivity*stdev(T-H,2,H)) && ((1-fees(2))*data(T,1)>lastAskPriceUsed),
            choice = -1;            
        end;
        
        % stop loss rule... check volume w.r.t. average of last hour
%         periods = fix(60/frequency);
%         sensibility = 3; % how many stdev are we looking at?
%         volumeIncr = (data(2:end,3)-data(1:end-1,3))./data(1:end-1,3);    
%         processStDev = var(volumeIncr).^0.5;        
%         
%         if abs(volumeIncr(end)) > mean(volumeIncr(end-periods:end-1)) + sensibility * processStDev;
%             choice = -2;
%         end;        

        % stop loss rule... check withinVolatility of prices w.r.t. average of last hour
         periods = fix(60/frequency);
         stoplossSensitivity = 3;
         stdevWithin = mean(var(withinVolatility).^0.5);
        if mean(withinVolatility(T,1:2)) > mean(mean(withinVolatility(T-periods:T-1,1:2))) + stoplossSensitivity *stdevWithin;
            choice = -2;
        end;        
        
        
    end;

function [choice] = choose004_basicRule(portfolio, data, fees, forecast, stdev, withinVolatility, frequency)
    % -1: sell; 0: wait; 1: buy; -2: stop loss
    choice = 0;
    
    %H = size(forecast,3);
    H = 5;
    T = size(data,1);
    sensitiveness = 1/3;
        
    if portfolio(T,1) > portfolio(T,2), 
        % I buy if price is increasing
        if mean(forecast(T,1:2,H)) > mean(data(T,1:2)) + sensitiveness*mean(stdev(T,1:2,H))
            choice = 1;
        end;
    else
        % I sell if price is decreasing
        if mean(forecast(T,1:2,H)) < mean(data(T,1:2)) - sensitiveness*mean(stdev(T,1:2,H))
            choice = -1;
        end;
    end;

function [choice] = choose002_maBase(portfolio, data, fees, forecast, stdev)
    % -1: sell; 0: wait; 1: buy; -2: stop loss
    choice = 0;
    T = size(data,1);
    MAlags = [20, 50];
    MAs = movingAverages(data, T, MAlags);
       
    if portfolio(T,1) > portfolio(T,2), 
        % I buy if price is increasing
        if MAs(1) > MAs(2) ,
            choice = 1;
        end;
    elseif portfolio(T,1) < portfolio(T,2), 
        % I sell if price is decreasing
        if MAs(1) < MAs(2) ,
            choice = -1;
        end;
    end;
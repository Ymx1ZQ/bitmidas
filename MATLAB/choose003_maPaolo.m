function [choice] = choose003_maPaolo(portfolio, data, fees, forecast, stdev)
    % -1: sell; 0: wait; 1: buy; -2: stop loss
    choice = 0;
    
    H = size(forecast,3);
    T = size(data,1);
    MAlags = [20, 50];

    data = [data(:,1:2); NaN(H,2)];
    
    for iii = 1:H,
        data(T+iii,:) = forecast(T,:,H);
    end;
    
    MAs = movingAverages(data, T, MAlags);
        
    if portfolio(T,1) > portfolio(T,2), 
        % I buy if price is increasing
        if MAs(1) > MAs(2) ,
            choice = 1;
        end;
    else
        % I sell if price is decreasing
        if MAs(1) < MAs(2) ,
            choice = -1;
        end;
    end;
function [choice] = choose005_maWithStoploss(portfolio, data, fees, forecast, stdev, withinVolatility, frequency)
    % -1: sell; 0: wait; 1: buy; -2: stop loss
    choice = 0;
    
    %H = size(forecast,3);
    H = 2;
    T = size(data,1);
    MAlags = [600/frequency, 1500/frequency]; % [20, 50] for data in 30mins
    
    % put some future in the choices
    data = [data(:,:); NaN(H,3)];
    for iii = 1:H,
        data(T+iii,:) = forecast(T,:,iii);
    end;
    MAs = movingAverages(data, T+H, MAlags);

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
        % stop loss rule... check withinVolatility of prices w.r.t. average of last hour
        periods = fix(60/frequency);
        stoplossSensitivity = 3;
        stdevWithin = mean(var(withinVolatility).^0.5);
        if mean(withinVolatility(T,1:2)) > mean(mean(withinVolatility(T-periods:T-1,1:2))) + stoplossSensitivity *stdevWithin;
            choice = -2;
        end;        
    end;
function [choice] = choose003_maPaolo(portfolio, data, fees, forecast, stdev)
    % -1: sell; 0: wait; 1: buy; -2: stop loss
    choice = 0;
    
    %H = size(forecast,3);
    H = 2;
    T = size(data,1);
    MAlags = [120, 300]; % [20, 50] for data in 30mins
    
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
    end;
    
    % improvements
    sensitiveness = 3;
    
    % change your mind if falling!!
    if mean(forecast(T,1:2,1)) < mean(data(T,1:2))-sensitiveness*mean(stdev(T,1:2,1)),
        choice = max(-1, choice-1);
    end; 
    
    % change your mind if growing!!
%     if mean(forecast(T,1:2,1)) > mean(data(T,1:2))+sensitiveness*mean(stdev(T,1:2,1)),
%         choice = min(1, choice+1);
%     end;
%     
    
    % checks
    if portfolio(T,1) > portfolio(T,2), 
        choice = max(0, choice);
    end;
    
    if portfolio(T,1) < portfolio(T,2), 
        choice = min(0, choice);
    end;
    
    
    % stop loss
    stoplossSensitiveness = 6;
    if mean(data(T,1:2)) < mean(forecast(T-1,1:2,1))-stoplossSensitiveness*mean(stdev(T-1,1:2,1)),
        choice = -2;
    end;
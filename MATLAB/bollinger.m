function [MAs] = movingAverages(data, iii, MAlags)
    MAs = zeros(2,1);
    MAs(1) = mean(mean(data(iii-MAlags(1):iii-1,1:2)));
    MAs(2) = mean(mean(data(iii-MAlags(2):iii-1,1:2)));
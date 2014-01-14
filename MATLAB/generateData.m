function [generatedData] = generateData(T)

A1 = [0.9 0.1; -0.1 0.9];
A2 = [-0.1 -0.1; 0.3 -0.1];
D = 0.1*[1 0.2; 0.1 1];
a = [10, 15];
starting = [190, 160; 192, 162];

generatedData = NaN(T,2);
generatedData(1:2,:) = starting;

for iii = 3:T;
    generatedData(iii,:) = a+ generatedData(iii-1,:)*A1 + generatedData(iii-2,:)*A2+ randn(1,2)*D;
end;
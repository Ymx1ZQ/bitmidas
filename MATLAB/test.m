% test

% loading data
load('computations.mat');
sampleForStDev = 200;
data = (data(2:end,:)-data(1:end-1,:))./data(1:end-1,:);
processStDev = NaN(size(data));
T = size(data,1);

for iii = sampleForStDev:T,
    processStDev(iii,:) = var(data(iii-sampleForStDev+1:iii)).^0.5;
end;

sensibility = 3;

plot(data(1:T-1,3)+sensibility*processStDev(1:T-1,3), 'r-.');
hold on;
plot(data(1:T-1,3)-sensibility*processStDev(1:T-1,3), 'r-.');
hold on;
plot(data(2:T,3), 'k-');
hold on;

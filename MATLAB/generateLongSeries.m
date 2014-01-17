% performing all forecasts!!
clc;
clear;
close all;
display('we''re generating a series for you...');
warning('off');

% loading data
oldData = (csvread('data.csv',1));
oldT = size(oldData, 1);
K = size(oldData, 2);

% settings
L1 = 4;
L2 = 2;
const = 0;
TBurn = 1*30*24*60;
Treal = 6*30*24*60; % generating 6 months
T = TBurn+Treal;

% estimating
[A_hat, COV, errors] = OLSestimation(oldData, 0, L1, const);
[B_hat, COVerrors, innovations] = OLSestimation(errors, 0, L2, 1);


% start
randomInnovations = innovations(fix(rand(T,1)*(size(innovations,1))+1),:);
generatedErrors = generateSeries(B_hat, zeros(L2,K), randomInnovations, 1);
allGeneratedData = generateSeries(A_hat, [1000*ones(L1,1),1002*ones(L1,1), 100*ones(L1,1)], generatedErrors, const);
data = allGeneratedData(end-Treal+1:end,:);
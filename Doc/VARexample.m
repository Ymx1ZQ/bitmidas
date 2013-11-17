% pulisco le variabili e lo  schermo
clear;
clc;

% settings
L = 4; % numero di lag considerati
T = 30;
K = 3; % numero di variabili (bid, ask, volume)

% qui creo dati finti per T = 30 osservazioni :)
% immaginiamoci siano prezzo bid, prezzo ask e volume
% li genero dal modello che poi vogliamo stimare

data = [randn(K,L)*3+1,zeros(K,T-L)];
A = randn(K,K*L+2)*0.1;
B = randn(K,K)*0.01;
epsilon = randn(K,T-L);

for iii = L+1:T,
    dataX = zeros(K*L+2,1);
    dataX(1,1) = 1;
    dataX(2,1) = iii;
    for jjj = 1:L,        
        dataX(2+(jjj-1)*K+1:2+jjj*K,1) = data(:,iii-jjj);
    end;
    data(:,iii) = A * dataX + B * epsilon(:,iii-L);
end;


% qui dai dati provo a stimare il modello che li ha generati
% in particolare, mi interessa A_hat (stima di A)

Y = data(:, L+1:T);

X = zeros(K*L+2, T-L);
for iii = L+1:T,
    X(1,iii-L) = 1;
    X(2,iii-L) = iii;
    for jjj = 1:L,        
        X(2+(jjj-1)*K+1:2+jjj*K,iii-L) = data(:,iii-jjj);
    end;
end;

A_hat = Y*X'*(X*X')^-1;
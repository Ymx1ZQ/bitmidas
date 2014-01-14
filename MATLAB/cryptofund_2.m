bitcoindata = zeros(size(data(:,1),3));

for i=1:size(data(:,1));
    bitcoindata(i,1)=data(i,1);
    bitcoindata(i,2)=data(i,2);
    bitcoindata(i,3)=data(i,3);
end
    
%% 2. Some Model Fitting: bid   ====================================================

full = size(bitcoindata(:,1),1);

logbitcoindata = bitcoindata;

lag_lenght = 5;

spec=garchset('variancemodel','constant','r',lag_lenght);
[coeff,errors,llf,innovation,sigma,summary]=garchfit(spec, logbitcoindata(1:size(logbitcoindata(:,1)),1));
 garchdisp(coeff,errors);
 
 bitcoinmatrix = [ logbitcoindata(1+lag_lenght:end,1) logbitcoindata(lag_lenght:end-1,1) logbitcoindata(lag_lenght-1:end-2,1) logbitcoindata(lag_lenght-2:end-3,1) logbitcoindata(lag_lenght-3:end-4,1) ];
 
 F_mat = [eye(lag_lenght-1) zeros(lag_lenght-1,1)];
 F_matrix = [ coeff.AR ; F_mat];
 
 fit1=nan(size(logbitcoindata(:,1))-lag_lenght,1);
    fit1=(F_matrix*bitcoinmatrix')'+coeff.C;
    
    fit2 =nan(size(logbitcoindata(:,1))-lag_lenght,1);
        fit2 = (F_matrix*fit1')' +coeff.C;
    
 fit3 =nan(size(logbitcoindata(:,1))-lag_lenght,1);
        fit3 = (F_matrix*fit2')' +coeff.C;
        
         fit4 =nan(size(logbitcoindata(:,1))-lag_lenght,1);
        fit4 = (F_matrix*fit3')' +coeff.C;
        
                 fit5 =nan(size(logbitcoindata(:,1))-lag_lenght,1);
        fit5 = (F_matrix*fit4')' +coeff.C;


hor = 5;

%err_pred_5 =  nan(size(logbitcoindata(:,1))-lag_lenght-hor,1);
err_pred_5 = fit5(1:end-hor,1) - bitcoinmatrix(1+hor:end,1);


variance = sqrt(sum(err_pred_5.^2)/(size(logbitcoindata(:,1),1)-lag_lenght-4));

% t=1:length(bitcoindata);
%     h1=plot(t',logbitcoindata(:,2),t',fit1(:,1),'r');    
%     errors = zeros(length(bitcoindata),1);
%    errors(:,1)= -logbitcoindata(:,2)+fit1(:,1);
%    plot(errors);
  
%% 3. Some Model Fitting: ask   ====================================================


spec=garchset('variancemodel','constant','r',lag_lenght);
[coeff,errors,llf,innovation,sigma,summary]=garchfit(spec, logbitcoindata(1:size(logbitcoindata(:,1)),2));
 garchdisp(coeff,errors);
 
 bitcoinmatrix_2 = [ logbitcoindata(1+lag_lenght:end,2) logbitcoindata(lag_lenght:end-1,2) logbitcoindata(lag_lenght-1:end-2,2) logbitcoindata(lag_lenght-2:end-3,2) logbitcoindata(lag_lenght-3:end-4,2) ]
 
 F_mat_2 = [eye(lag_lenght-1) zeros(lag_lenght-1,1)]
 F_matrix_2 = [ coeff.AR ; F_mat_2]
 
 fit1_2=nan(size(logbitcoindata(:,1))-lag_lenght,1);
    fit1_2=(F_matrix_2*bitcoinmatrix_2')'+coeff.C;
    
    fit2_2 =nan(size(logbitcoindata(:,1))-lag_lenght,1);
        fit2_2 = (F_matrix_2*fit1_2')' +coeff.C;
    
 fit3_2 =nan(size(logbitcoindata(:,1))-lag_lenght,1);
        fit3_2 = (F_matrix_2*fit2_2')' +coeff.C;
        
         fit4_2 =nan(size(logbitcoindata(:,1))-lag_lenght,1);
        fit4_2 = (F_matrix_2*fit3_2')' +coeff.C;
        
                 fit5_2 =nan(size(logbitcoindata(:,1))-lag_lenght,1);
        fit5_2 = (F_matrix_2*fit4_2')' +coeff.C;


hor = 5;
err_pred_5_2 =  nan(size(logbitcoindata(:,1))-lag_lenght-hor,1);
err_pred_5_2 = fit5_2(1:end-hor,1) - bitcoinmatrix_2(1+hor:end,2);


variance_2 = sqrt(sum(err_pred_5_2.^2)/(size(logbitcoindata(:,1),1)-lag_lenght-4));


%% confidence intervals

predic_1 = [ fit5(:,1)-variance/3  fit5(:,1)  fit5(:,1)+variance/3];

predic_2 = [ fit5_2(:,1)-variance_2/3  fit5_2(:,1)  fit5_2(:,1)+variance_2/3];

decision_1 = [bitcoinmatrix(1+hor:end,1) predic_2(1:end-hor,:)];
decision_2 = [bitcoinmatrix_2(1+hor:end,1) predic_1(1:end-hor,:)];



%% 4. A Simple Investing Rule =================================================================

% Y = [upper_band; logbitcoindata(:,2)'; lower_band];
% subplot(2,1,1), plot(Y(:,70:full)');
% subplot(2,1,2), plot(Y(:,1:70)');


start = 25000;

for i=start:full-hor-lag_lenght;
    order(i,1) = {''};
    command(i,1) = 0;
end

numero=0;
stock_value=0;
max_punloss = 4;

for i=start:full-hor-lag_lenght	;
    
    if  numero>-1;
    if predic_1(i,1)>bitcoinmatrix_2(i,1)';  
            
        numero=-1;
        order(i,1)= {'buy'};
        command(i,1)=-1;
        stock_value = bitcoindata(i,2)*0.998;
        disp(i);
        disp(order(i,1));
        disp(stock_value);
    end
    

    
    elseif numero<0;
            if stock_value-bitcoinmatrix_2(i,1)*0.998 < 0 && predic_2(i,3)<bitcoinmatrix(i,1)' ;
                order(i,1)={'sell'};
                command(i,1)=1;
                numero=1;
                stock_value=0;
                disp(i);
                disp(order(i,1));
                disp(bitcoinmatrix(i+hor,2)*0.998);
            end;                           
        
         
    end;
         
        
    
       
end;


    


    

for i=start:full-hor-lag_lenght;
   earnings(i,1)= command(i,1)*bitcoindata(i,2);
   earnings(i,2)=i;
end;

% if numero < 0
%      earnings(end,1)=bitcoinmatrix(end,1)*0.998;
%  end

earn = sum(earnings(start:full-hor-lag_lenght,1));
earn_correct = earn + stock_value;


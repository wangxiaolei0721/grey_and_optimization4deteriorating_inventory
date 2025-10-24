function fitresult = demand_estimation(price_train,sale_train)


cell_length=length(price_train);
Price=[];
Sale=[];


for i = 1:cell_length
    price=price_train{i};
    % estimate parameter
    Price=[Price;price];
    sale=sale_train{i};
    Sale=[Sale;sale];
end


% Fit model to data
fitresult= polyfit(Price,Sale,1);



end
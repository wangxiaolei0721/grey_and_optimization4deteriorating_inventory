function fitresult = demand_estimation(price_train,demand_train)
% demand regression

price_vector = vertcat(price_train{:});
demand_vector = vertcat(demand_train{:});
% Fit model to data
fitresult= polyfit(price_vector,demand_vector,1);


end
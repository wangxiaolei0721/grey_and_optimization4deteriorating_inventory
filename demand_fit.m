function [demand_pre,MAPE] = demand_fit(demand_pars,Price,Demand)
% demand fit

price_vector = vertcat(Price{:});
demand_vector = vertcat(Demand{:});
demand_pre_vector = polyval(demand_pars,price_vector);

cell_length=length(Price);
demand_pre = cell(1,cell_length);
for i = 1:cell_length
    price=Price{i};
    % estimate parameter
    demand_pre{1,i}=polyval(demand_pars,price);
end

APE = 100*abs(demand_pre_vector - demand_vector)./demand_vector;
MAPE = mean(APE);


end
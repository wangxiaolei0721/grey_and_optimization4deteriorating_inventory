function [Demand_pre,RMSE] = demand_fit(demand_pars,Price,Demand)


cell_length=length(Price);
Demand_pre={};
demand_vector=[];
demand_pre_vector=[];

for i = 1:cell_length
    price=Price{i};
    demand_vector=[demand_vector;Demand{i}];
    % estimate parameter
    demand_pre=polyval(demand_pars,price);
    Demand_pre{i}=demand_pre;
    demand_pre_vector=[demand_pre_vector;demand_pre];
end

SSE = sum((demand_pre_vector - demand_vector).^2);

% 计算均方误差 (MSE)
MSE = SSE/length(demand_vector);

% 计算均方根误差 (RMSE)
RMSE = sqrt(MSE);

end
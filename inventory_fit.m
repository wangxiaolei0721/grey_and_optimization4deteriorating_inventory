function [It_Q_pre,RMSE] = inventory_fit(theta,alpha,beta,Price,Q,Date_index,It_Q)
% generate inventory levels and inventory changes 
% input parameter:
% alpha: basic demand
% beta: price sensitivity coefficient
% p: price
% theta: deteriorating rate
% time0: the time of order arrival
% delta_t: the time resolution
% Q: the order quantity
% output parameter
% time: sampling time
% demand: demand quantity
% level: inventory level
% level_diff: inventory changes


cell_length=length(Q);
It_Q_pre={};
It_Q_vector=[];
It_Q_pre_vector=[];

for i = 1:cell_length
    time=Date_index{i};
    price=mean(Price{i});
    q=Q{i};
    It_Q_vector=[It_Q_vector;It_Q{i}];
    d=alpha-beta*price;
    c=q+d/theta;
    It_Q_pre0=c*exp(-theta*time)-d/theta;
    It_Q_pre{i}=It_Q_pre0;
    It_Q_pre_vector=[It_Q_pre_vector;It_Q_pre0];
end

SSE = sum((It_Q_pre_vector - It_Q_vector).^2);

% 计算均方误差 (MSE)
MSE = SSE/length(It_Q_vector);

% 计算均方根误差 (RMSE)
RMSE = sqrt(MSE);

end


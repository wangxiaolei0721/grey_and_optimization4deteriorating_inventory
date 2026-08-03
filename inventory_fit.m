function [It_Q_pre,MAPE,It_Q_vector,It_Q_pre_vector] = inventory_fit(lambda,alpha,beta,Price,Q,Date_index,It_Q)
% generate inventory levels and inventory changes 
% input parameter:
% alpha: basic demand
% beta: price sensitivity coefficient
% p: price
% lambda: deteriorating rate
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

% 
for i = 1:cell_length
    time=Date_index{i};
    price=mean(Price{i});
    It_Q_vector=[It_Q_vector;It_Q{i}];
    % 拟合库存水平
    q=Q{i};
    d=alpha-beta*price;
    c=q+d/lambda;
    It_Q_pre0=c*exp(-lambda*time)-d/lambda;
    % 把超过t_T的 小于0的赋值为0
    T = log(q*lambda/d+1)/lambda;
    t_T = time(1) + T;
    It_Q_pre0(time > t_T) = 0;
    % 保存数据
    It_Q_pre{i}=It_Q_pre0;
    It_Q_pre_vector=[It_Q_pre_vector;It_Q_pre0];
end

APE = 100*abs(It_Q_pre_vector - It_Q_vector)./It_Q_vector;
MAPE = mean(APE(isfinite(APE)));

end


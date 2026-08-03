function lambda = inventory_estimation(Demand_train,Q_train,It_train)
% parameter estimation
% input parameter:
% time_train: the sample time
% level_diff_train: inventory level changes
% level_train: inventory level
% output parameter:
% pars: [lambda,alpha,beta]


cell_length=length(Q_train);
B=[];
Y=[];
for i = 1:cell_length
    Q = Q_train{i};
    It = It_train{i};
    It_Q=[Q;It];
    I1_cumsum=cumsum(It_Q(1:end-1,1));
    I2_cumsum=cumsum(It_Q(2:end,1));
    It_cum=1/2*I1_cumsum+1/2*I2_cumsum;  % accumulative series
    % estimate parameter
    b=-It_cum;
    B=[B;b];
    demand=Demand_train{i};
    g_integral=cumsum(demand);
    y=It-Q+g_integral;
    Y=[Y;y];
end

lambda=(B'*B)\B'*Y;

end


%% clear data and figure
clc;
clear;
close all;
load .\data\inventory_data.mat
load .\data\economic_parameters.mat
%%
traincycle=30;
testcycle=10;
iter=length(Date_index_t0)-traincycle-testcycle;
alpha_vector=zeros(iter,1);
beta_vector=zeros(iter,1);
lambda_vector=zeros(iter,1);
Demand_fit_MAPE_vector=zeros(iter,1);
Demand_pre_MAPE_vector=zeros(iter,1);
Inventory_fit_MAPE_vector=zeros(iter,1);
Inventory_pre_MAPE_vector=zeros(iter,1);
%
Date_t0_vector=NaT(iter,1);
% economic parameters
cost_vector=zeros(iter,1);
price_true_vector=zeros(iter,1);
T_true_vector=zeros(iter,1);
Q_true_vector=zeros(iter,1);
%% data prepare
for begincycle= 1:iter
    middlecycle=begincycle+traincycle-1;
    endcycle=begincycle+traincycle+testcycle-1;
    %
    Date_t0_vector(begincycle)=Date_t0{endcycle+1};
    % economic parameters
    cost=mean(Cost{endcycle+1});
    cost_vector(begincycle)=cost;
    price=mean(Price{endcycle+1});
    price_true_vector(begincycle)=price;
    T_true_vector(begincycle)=T_true{endcycle+1};
    Q_true_vector(begincycle) = Levelatt0{endcycle+1};
    % fit data
    Date_train=Date_time(begincycle:middlecycle);
    Date_t0_train=Date_time_t0(begincycle:middlecycle);
    Date_index_train=Date_index_t0(begincycle:middlecycle);
    Price_train=Price(begincycle:middlecycle);
    Demand_train = Sale(begincycle:middlecycle);
    Q_train=Levelatt0(begincycle:middlecycle);
    It_train=Level(begincycle:middlecycle);
    It_Q_train=Level_t0(begincycle:middlecycle);
    % test data
    Date_test=Date_time(middlecycle+1:endcycle);
    Date_t0_test=Date_time_t0(middlecycle+1:endcycle);
    Date_index_test=Date_index_t0(middlecycle+1:endcycle);
    Price_test=Price(middlecycle+1:endcycle);
    Demand_test = Sale(middlecycle+1:endcycle);
    Q_test=Levelatt0(middlecycle+1:endcycle);
    It_test=Level(middlecycle+1:endcycle);
    It_Q_test=Level_t0(middlecycle+1:endcycle);
    % fit and test data
    Date_t0_train_test=[Date_t0_train,Date_t0_test];
    Date_index_train_test=[Date_index_train,Date_index_test];
    Price_train_test=[Price_train,Price_test];
    Demand_train_test=[Demand_train,Demand_test];
    Q_train_test=[Q_train,Q_test];
    It_train_test=[It_train,It_test];
    It_Q_train_test=[It_Q_train,It_Q_test];
    % train and test
    %% demand estimation
    demand_pars = demand_estimation(Price_train,Demand_train);
    alpha=demand_pars(2);
    beta=-demand_pars(1);
    % fit demand
    [Demand_fit,Demand_fit_MAPE]=demand_fit(demand_pars,Price_train,Demand_train);
    [Demand_pre,Demand_pre_MAPE]=demand_fit(demand_pars,Price_test,Demand_test);
    Demand_fit_MAPE_vector(begincycle,1)=Demand_fit_MAPE;
    Demand_pre_MAPE_vector(begincycle,1)=Demand_pre_MAPE;
    %% inventory estimation
    lambda = inventory_estimation(Demand_train,Q_train,It_train);
    [It_Q_fit,Inventory_fit_MAPE] = inventory_fit(lambda,alpha,beta,Price_train,Q_train,Date_index_train,It_Q_train);
    [It_Q_pre,Inventory_pre_MAPE] = inventory_fit(lambda,alpha,beta,Price_test,Q_test,Date_index_test,It_Q_test);
    Inventory_fit_MAPE_vector(begincycle,1)=Inventory_fit_MAPE;
    Inventory_pre_MAPE_vector(begincycle,1)=Inventory_pre_MAPE;
    %% estimation
    % demand estimation
    demand_pars = demand_estimation(Price_train_test,Demand_train_test);
    alpha=demand_pars(2);
    beta=-demand_pars(1);
    alpha_vector(begincycle)=alpha;
    beta_vector(begincycle)=beta;
    % inventory estimation
    lambda = inventory_estimation(Demand_train_test,Q_train_test,It_train_test);
    lambda_vector(begincycle)=lambda;
end
% error plot
% boxplot(Demand_MAPE_vector);
% figure;
% boxplot(Inventory_MAPE_vector);
% figure;
% boxplot(alpha_vector);
% figure;
% boxplot(beta_vector);
% figure;
% boxplot(lambda_vector);
% 
i=[41:245]';
pars_table = table(i,lambda_vector,Inventory_fit_MAPE_vector,Inventory_pre_MAPE_vector,alpha_vector,beta_vector, ...
    Demand_fit_MAPE_vector,Demand_pre_MAPE_vector, ...
    'VariableNames',{'滚动窗口i','lambda','库存拟合误差(MAPE, %)','库存预测误差(MAPE, %)','alpha','beta', ...
    '需求拟合误差(MAPE, %)','需求预测误差(MAPE, %)'}); 
writetable(pars_table,'.\data\pars.xlsx');
% save
save(".\data\estimated_parameters.mat","alpha_vector","beta_vector","lambda_vector","cost_vector","price_true_vector","T_true_vector","Q_true_vector","Date_t0_vector")




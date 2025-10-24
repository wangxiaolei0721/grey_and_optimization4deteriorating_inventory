%% clear data and figure
clc;
clear;
close all;
load .\data\inventory_data.mat
load .\data\economic_parameters.mat
%% data prepare
begincycle=1;
traincycle=30;
testcycle=10;
middlecycle=begincycle+traincycle-1;
endcycle=begincycle+traincycle+testcycle-1;
% economic parameters
cost=mean(Cost{endcycle+1});
T_true_value=T_true{endcycle+1};
price_true=mean(Price{endcycle+1});
% fit data
% Date_train=Date_time(begincycle:middlecycle-1);
Date_t0_train=Date_time_t0(begincycle:middlecycle);
Date_index_train=Date_index_t0(begincycle:middlecycle);
Price_train=Price(begincycle:middlecycle);
Demand_train = Sale(begincycle:middlecycle);
Q_train=Levelatt0(begincycle:middlecycle);
It_train=Level(begincycle:middlecycle);
It_Q_train=Level_t0(begincycle:middlecycle);
% test data
% Date_test=Date_time(middlecycle:endcycle);
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
%% test
% demand estimation
demand_pars = demand_estimation(Price_train,Demand_train);
alpha=demand_pars(2);
beta=-demand_pars(1);
% fit demand
[Demand_fit,Demand_RMSE_fit]=demand_fit(demand_pars,Price_train,Demand_train);
[Demand_pre,Demand_RMSE_pre]=demand_fit(demand_pars,Price_test,Demand_test);
% plot
% 使用 vertcat 将 cell 中的向量首尾相接
Price_train_vector = vertcat(Price_train{:});
Demand_train_vector = vertcat(Demand_train{:});
Demand_fit_vector = vertcat(Demand_fit{:});
Price_test_vector = vertcat(Price_test{:});
Demand_test_vector = vertcat(Demand_test{:});
Demand_pre_vector = vertcat(Demand_pre{:});
fdemand=figure('unit','centimeters','position',[0,5,40,20],'PaperPosition',[0,5,40,20],'PaperSize',[40,20]);
plot(Price_train_vector,Demand_train_vector,'MarkerEdgeColor',[0 0 0],'MarkerSize',12,'Marker','x',...
    'LineStyle','none','LineWidth',2)
hold on;
plot(Price_test_vector,Demand_test_vector,'MarkerEdgeColor',[0.850980401039124 0.325490206480026 0.0980392172932625],'MarkerSize',12,'Marker','^',...
    'LineStyle','none','LineWidth',2);
plot(Price_train_vector,Demand_fit_vector,'LineWidth',2,'Color',[0 0.447058826684952 0.74117648601532])
plot(Price_test_vector,Demand_pre_vector,'LineWidth',2,'Color',[0 0.447058826684952 0.74117648601532]);
xlabel({'销售价格'},'FontSize',14);
ylabel(['需求量'],'FontSize',14);
legend(["真实水平","拟合水平"],'location','northeast','FontSize',14,'NumColumns',1);
set(gca,'FontName','Microsoft YaHei','FontSize',16);
legend(["训练集上的真实需求","测试集上的真实需求","需求曲线"],'location','northeast','FontSize',14,'NumColumns',1);
%
% inventory estimation
theta = inventory_estimation(Demand_train,Q_train,It_train);
[It_Q_fit,Inventory_RMSE_fit] = inventory_fit(theta,alpha,beta,Price_train,Q_train,Date_index_train,It_Q_train);
[It_Q_pre,Inventory_RMSE_test] = inventory_fit(theta,alpha,beta,Price_test,Q_test,Date_index_test,It_Q_test);
% plot
finvertory=figure('unit','centimeters','position',[0,5,40,20],'PaperPosition',[0,5,40,20],'PaperSize',[40,20]);
hold on
for i=1:length(Q_train)
    plot(Date_t0_train{i},It_Q_train{i},'LineStyle','none','Marker','o','MarkerSize',8,'LineWidth',1.5,'Color',[0 0.4470 0.7410])
    plot(Date_t0_train{i},It_Q_fit{i},'LineStyle','--','LineWidth',1.5,'Marker','^','MarkerSize',8,'Color',[0.8500 0.3250 0.0980])
    stem(Date_t0_train{i}(1),It_Q_train{i}(1),'LineStyle','--','LineWidth',0.5,'Color','black')
end
for i=1:length(Q_test)
    plot(Date_t0_test{i},It_Q_test{i},'LineStyle','none','Marker','o','MarkerSize',8,'LineWidth',1.5,'Color',[0 0.4470 0.7410])
    plot(Date_t0_test{i},It_Q_pre{i},'LineStyle','--','LineWidth',1.5,'Marker','^','Color',[0.8500 0.3250 0.0980])
    stem(Date_t0_test{i}(1),It_Q_test{i}(1),'LineStyle','--','LineWidth',0.5,'Color','black')
end
box on;
xlabel({'时间/日'},'FontSize',14);
ylabel(['库存水平'],'FontSize',14)
xlim([Date_t0_train{1}(1) Date_t0_test{i}(end)]);
% 添加图例
legend(["真实库存水平","预测库存水平"],'Location','north');
set(gca,'FontName','Microsoft YaHei','FontSize',16);
% legend(["真实水平","拟合水平"],'location','northeast','FontSize',12,'NumColumns',1);
% Create doublearrow
annotation(finvertory,'doublearrow',[0.15 0.66],...
    [0.88 0.88]);
% Create doublearrow
annotation(finvertory,'doublearrow',[0.68 0.891661458333333],...
    [0.88 0.88]);
% Create line
annotation(finvertory,'line',[0.67 0.67],...
    [0.921104166666667 0.850666666666667]);
% Create textbox
annotation(finvertory,'textbox',...
    [0.74 0.825 0.0856510416666666 0.0457068452380953],...
    'String','测试集',...
    'LineStyle','none',...
    'HorizontalAlignment','center',...
    'FontSize',14,...
    'FontName','Microsoft YaHei',...
    'FitBoxToText','off');
% Create textbox
annotation(finvertory,'textbox',...
    [0.350034086575134 0.825 0.0856510416666666 0.0457068452380953],...
    'String','训练集',...
    'LineStyle','none',...
    'HorizontalAlignment','center',...
    'FontSize',14,...
    'FontName','Microsoft YaHei',...
    'FitBoxToText','off');
%%
% % save figure
savefig(fdemand,'.\figure\case_demand_fit.fig')
exportgraphics(fdemand,'.\figure\case_demand_fit.pdf')
savefig(finvertory,'.\figure\case_inventory_fit.fig')
exportgraphics(finvertory,'.\figure\case_inventory_fit.pdf')
% demand estimation
demand_pars = demand_estimation(Price_train_test,Demand_train_test);
alpha=demand_pars(2);
beta=-demand_pars(1);
% inventory estimation
theta = inventory_estimation(Demand_train_test,Q_train_test,It_train_test);
%
save(".\data\estimated_parameters1.mat","alpha","beta","theta","cost","T_true_value","price_true")



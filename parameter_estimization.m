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
%
date_t0=Date_t0{endcycle+1};
% economic parameters
cost=mean(Cost{endcycle+1});
price_true=mean(Price{endcycle+1});
T_true=T_true{endcycle+1};
Q_true = Levelatt0(endcycle+1);
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
% price_vector = vertcat(Price_train{:});
% demand_vector = vertcat(Demand_train{:});
demand_pars = demand_estimation(Price_train,Demand_train);
alpha=demand_pars(2);
beta=-demand_pars(1);
% fit demand
[Demand_fit,Demand_MAPE_fit]=demand_fit(demand_pars,Price_train,Demand_train);
[Demand_pre,Demand_MAPE_pre]=demand_fit(demand_pars,Price_test,Demand_test);
% plot
fdemand=figure('unit','centimeters','position',[0,5,40,20],'PaperPosition',[0,5,40,20],'PaperSize',[40,20]);
hold on;
for i=1:length(Q_train)
    h1 = plot(Date_train{i},Demand_train{i},'LineStyle','none','Marker','o','MarkerSize',8,'LineWidth',1.5,'Color',[0 0.45 0.74]);
    h2 = plot(Date_train{i},Demand_fit{i},'LineStyle','none','LineWidth',1.5,'Marker','^','MarkerSize',8,'Color',[0.47 0.67 0.19]);
    xline(Date_train{i}(1),'LineStyle','--','LineWidth',0.5,'Color','black');
end
for i=1:length(Q_test)
    h3 = plot(Date_test{i},Demand_test{i},'LineStyle','none','Marker','o','MarkerSize',8,'LineWidth',1.5,'Color',[0 0.45 0.74]);
    h4 = plot(Date_test{i},Demand_pre{i},'LineStyle','none','LineWidth',1.5,'Marker','s','MarkerSize',8,'Color',[0.85 0.33 0.1]);
    xline(Date_test{i}(1),'LineStyle','--','LineWidth',0.5,'Color','black');
end
box on;
xlabel({'时间/日'},'FontSize',14);
ylabel(['库存水平'],'FontSize',14);
xline(Date_test{1}(1),'LineStyle','-','LineWidth',1,'Color','black');
% 添加图例
legend([h1,h2,h4],["真实需求","拟合需求","预测需求"],'Location','north');
set(gca,'FontName','Microsoft YaHei','FontSize',16);
% Create doublearrow
annotation(fdemand,'doublearrow',[0.145 0.655],...
    [0.88 0.88]);
% Create doublearrow
annotation(fdemand,'doublearrow',[0.69 0.89],...
    [0.88 0.88]);
% Create textbox
annotation(fdemand,'textbox',...
    [0.35 0.825 0.085 0.045],...
    'String','训练集',...
    'LineStyle','none',...
    'HorizontalAlignment','center',...
    'FontSize',14,...
    'FontName','Microsoft YaHei',...
    'FitBoxToText','off');
% Create textbox
annotation(fdemand,'textbox',...
    [0.74 0.825 0.085 0.045],...
    'String','测试集',...
    'LineStyle','none',...
    'HorizontalAlignment','center',...
    'FontSize',14,...
    'FontName','Microsoft YaHei',...
    'FitBoxToText','off');
%% inventory estimation
lambda = inventory_estimation(Demand_train,Q_train,It_train);
[It_Q_fit,Inventory_MAPE_fit,It_Q_vector,It_Q_pre_vector] = inventory_fit(lambda,alpha,beta,Price_train,Q_train,Date_index_train,It_Q_train);
MAPE = mean(abs(It_Q_pre_vector - It_Q_vector)./It_Q_vector);
[It_Q_pre,Inventory_MAPE_test] = inventory_fit(lambda,alpha,beta,Price_test,Q_test,Date_index_test,It_Q_test);
% plot
finvertory=figure('unit','centimeters','position',[0,5,40,20],'PaperPosition',[0,5,40,20],'PaperSize',[40,20]);
hold on;
for i=1:length(Q_train)
    h1 = plot(Date_t0_train{i},It_Q_train{i},'LineStyle','none','Marker','o','MarkerSize',8,'LineWidth',1.5,'Color',[0 0.45 0.74]);
    h2 = plot(Date_t0_train{i},It_Q_fit{i},'LineStyle','--','LineWidth',1.5,'Marker','^','MarkerSize',8,'Color',[0.47 0.67 0.19]);
    xline(Date_t0_train{i}(1),'LineStyle','--','LineWidth',0.5,'Color','black');
end
for i=1:length(Q_test)
    h3 = plot(Date_t0_test{i},It_Q_test{i},'LineStyle','none','Marker','o','MarkerSize',8,'LineWidth',1.5,'Color',[0 0.45 0.74]);
    h4 = plot(Date_t0_test{i},It_Q_pre{i},'LineStyle','--','LineWidth',1.5,'Marker','^','Color',[0.85 0.33 0.1]);
    xline(Date_t0_test{i}(1),'LineStyle','--','LineWidth',0.5,'Color','black');
end
box on;
xlabel({'时间/日'},'FontSize',14);
ylabel(['库存水平'],'FontSize',14);
xline(Date_test{1}(1),'LineStyle','-','LineWidth',1,'Color','black');
% 添加图例
legend([h1,h2,h4],["真实库存水平","拟合库存水平","预测库存水平"],'Location','north');
set(gca,'FontName','Microsoft YaHei','FontSize',16);
% Create doublearrow
annotation(finvertory,'doublearrow',[0.145 0.67],...
    [0.88 0.88]);
% Create doublearrow
annotation(finvertory,'doublearrow',[0.70 0.89],...
    [0.88 0.88]);
% Create textbox
annotation(finvertory,'textbox',...
    [0.35 0.825 0.085 0.045],...
    'String','训练集',...
    'LineStyle','none',...
    'HorizontalAlignment','center',...
    'FontSize',14,...
    'FontName','Microsoft YaHei',...
    'FitBoxToText','off');
% Create textbox
annotation(finvertory,'textbox',...
    [0.74 0.825 0.085 0.045],...
    'String','测试集',...
    'LineStyle','none',...
    'HorizontalAlignment','center',...
    'FontSize',14,...
    'FontName','Microsoft YaHei',...
    'FitBoxToText','off');
%% save figure
savefig(fdemand,'.\figure\case_demand_fit.fig')
exportgraphics(fdemand,'.\figure\case_demand_fit.pdf')
savefig(finvertory,'.\figure\case_inventory_fit.fig')
exportgraphics(finvertory,'.\figure\case_inventory_fit.pdf')
%% estimation
% demand estimation
demand_pars = demand_estimation(Price_train_test,Demand_train_test);
alpha=demand_pars(2);
beta=-demand_pars(1);
% inventory estimation
lambda = inventory_estimation(Demand_train_test,Q_train_test,It_train_test);
%
save(".\data\estimated_parameters1.mat","alpha","beta","lambda","cost","price_true","T_true","Q_true","date_t0")



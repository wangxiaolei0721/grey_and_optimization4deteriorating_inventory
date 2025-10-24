%% clear data and figure
clc;
clear;
close all;
load tomato.mat
load AvgCost.mat
% writetable(tomato,'tomato.xlsx');
%% initialization of data storage
Date=tomato.Date;
BeginStockQty=tomato.BeginStockQty;
GrnQty=tomato.GrnQty;
SaleQty=tomato.SaleQty;
EndStockQty=tomato.EndStockQty;
SalePrice=tomato.SalePrice;
OrderCost=SalePrice-AvgMargin;
Holiday=tomato.Holiday;
% sum(Holiday)
% % 大概计算变质率
% a=(BeginStockQty+GrnQty-EndStockQty-SaleQty)./EndStockQty;
% boxplot(a')
%
demand_fig=figure('unit','centimeters','position',[5,5,40,20],'PaperPosition',[5,5,40,20],'PaperSize',[40,20]);
% Fit model to data
fitresult= polyfit(SalePrice,SaleQty,1);
Sale_pre=polyval(fitresult,SalePrice);
plot(SalePrice,SaleQty,'MarkerEdgeColor',[0 0 0],'MarkerSize',12,'Marker','x',...
    'LineStyle','none','LineWidth',2)
hold on
plot(SalePrice,Sale_pre,'LineWidth',2,'Color',[0 0.447058826684952 0.74117648601532])
xlabel({'销售价格'},'FontSize',14);
ylabel(['销售数量'],'FontSize',14);
set(gca,'FontName','Microsoft YaHei','FontSize',16);
% Create textbox
annotation(demand_fig,'textbox',...
    [0.650710968620224 0.358620535714284 0.183766529472838 0.0635000000000002],...
    'String','$d(p)=40.71-3.8789\times p$',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'HorizontalAlignment','center',...
    'FontSize',26,...
    'FontName','Times New Roman',...
    'FitBoxToText','off');
%% 
Date_time = {};
Date_t0={};
Date_time_t0 = {};
Date_index_t0 = {};
T_true = {};
Price={};
Cost={};
Sale={};
Levelatt0= {};
Level = {};
Level_t0 = {};
%
Not0Positions=GrnQty~=0;% 返回一个逻辑矩阵，NaN 位置为 true
[Not0row, ~] = find(Not0Positions); % 找出 NaN 的行和列索引
Date_row=Date(Not0row);
for i = 1:(length(Not0row)-1)
    irow=Not0row(i);
    inextrow=Not0row(i+1);
    Date_time{i} =Date(irow:(inextrow-1));
    Date_t0{i} =Date(irow-1);
    Date_time_t0{i} =Date(irow-1:(inextrow-1));
    Date_index_t0{i} =[0;(1:inextrow-irow)'];
    T_true{i}=inextrow-irow;
    Price{i}=SalePrice(irow:(inextrow-1));
    Cost{i}=OrderCost(irow:(inextrow-1));
    Sale{i}=SaleQty(irow:(inextrow-1));
    levelatt0=BeginStockQty(irow)+GrnQty(irow);
    Levelatt0{i}=levelatt0;
    Level{i}=EndStockQty(irow:(inextrow-1));
    Level_t0{i}=[levelatt0;EndStockQty(irow:(inextrow-1))];
end
%
inventory_fig=figure('unit','centimeters','position',[5,5,40,20],'PaperPosition',[5,5,40,20],'PaperSize',[40,20]);
for i = 1:20
    plot(Date_time_t0{i},Level_t0{i},'Marker','o','LineWidth',1.5,'MarkerSize',8)
    hold on
    stem(Date_t0{i},Levelatt0{i},'LineStyle','--','LineWidth',0.5,'Color','black')
end
xlabel({'时间/日'},'FontSize',14);
ylabel(['库存水平'],'FontSize',14);
xlim([Date_t0{1} Date_t0{i+1}]);
set(gca,'FontName','Microsoft YaHei','FontSize',16);
% Create textbox
annotation(inventory_fig,'textbox',...
    [0.77725400457666 0.818571428571428 0.1 0.0617857142857147],...
    'String',{'订货点'},...
    'HorizontalAlignment','center',...
    'FontSize',16,...
    'FontName','Microsoft YaHei',...
    'FitBoxToText','off');
% Create textarrow
annotation(inventory_fig,'textarrow',[0.877192982456141 0.83905415713196],...
    [0.573214285714286 0.81]);
% Create textarrow
annotation(inventory_fig,'textarrow',[0.811594202898551 0.81998474446987],...
    [0.394642857142857 0.81]);
% Create textarrow
annotation(inventory_fig,'textarrow',[0.768878718535469 0.8093058733791],...
    [0.695 0.81]);
% Create textarrow
annotation(inventory_fig,'textarrow',[0.833714721586575 0.829900839054157],...
    [0.510714285714286 0.81]);

% save figure
savefig(demand_fig,'..\figure\case_demand.fig');
exportgraphics(demand_fig,'..\figure\case_demand.pdf')
savefig(inventory_fig,'..\figure\case_inventory.fig');
exportgraphics(inventory_fig,'..\figure\case_inventory.pdf')
%
save("inventory_data.mat","Date_time","Date_time_t0","Date_index_t0","Price","Sale","Levelatt0","Level","Level_t0")
save("economic_parameters.mat","Cost","T_true","Date_t0")



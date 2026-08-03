% clear data and figure
clc;
clear;
close all;
% load estimated parameters
load(".\data\estimated_parameters1.mat");
%% economic order quantity
%
% price_true=price_true;
% T_true=T_true;
% Q_true=Q_true;
c=cost; % 6.5
h=0.4;
K=5;
% price interval based on estimates
p_interval=[c alpha/beta];
% cycle interval
T_interval=[1 7];
%% plot profit for simulated and estimated pars
% fit profit
fprofit_opt=figure('unit','centimeters','position',[5,5,30,15],'PaperPosition',[5,5,30,15],'PaperSize',[30,15]);
tiledlayout(1,2,'Padding','Compact');
nexttile
% plot
profit_fd = @(p,T) profit(alpha,beta,p,lambda,c,h,K,T);
fsurf(profit_fd,[p_interval,T_interval]);
hold on;
% solve
% simulated profit
syms p T;
profit_syms = profit(alpha,beta,p,lambda,c,h,K,T);
profit_der_p=diff(profit_syms,p);
profit_der_T=diff(profit_syms,T);
eq1 = profit_der_p == 0;
eq2 = profit_der_T == 0;
sol = vpasolve([eq1, eq2], [p, T],[p_interval;T_interval]);
p_opt  = double(sol.p);
T_opt  = double(sol.T);
% Q 
Q_opt=lambda\(alpha-beta*p_opt)* (exp(lambda*T_opt) - 1) ;
% The profit corresponding to the optimal point
profit_opt = profit(alpha,beta,p_opt,lambda,c,h,K,T_opt);
profit_true = profit(alpha,beta,price_true,lambda,c,h,K,T_true);
plot3(p_opt,T_opt,profit_opt,'LineStyle','none','Marker','hexagram','MarkerFaceColor','none','MarkerEdgeColor','r','LineWidth',2,'MarkerSize',15)
plot3(price_true,T_true,profit_true,'LineStyle','none','Marker','hexagram','MarkerFaceColor','none','MarkerEdgeColor','m','LineWidth',2,'MarkerSize',15)
xlabel({'销售价格'},'FontSize',12)
ylabel(['订货周期'],'FontSize',12)
zlabel(['利润'],'FontSize',12)
% zlim([-100,120])
title("(a) 番茄的库存利润", 'FontSize',14);
set(gca,'FontName','Microsoft YaHei','FontSize',14);
%% plot approximated profit for simulated and estimated pars
nexttile
profit_appro_fd = @(p,T) profit_appro(alpha,beta,p,lambda,c,h,K,T);
fsurf(profit_appro_fd,[p_interval,T_interval]);
hold on;
profit_appro_syms = profit_appro(alpha,beta,p,lambda,c,h,K,T);
profit_appro_der_p=diff(profit_appro_syms,p);
profit_appro_der_T=diff(profit_appro_syms,T);
eq1 = profit_appro_der_p == 0;
eq2 = profit_appro_der_T == 0;
sol = vpasolve([eq1, eq2], [p, T],[p_interval;T_interval]);
p_appro_opt  = double(sol.p);
T_appro_opt  = double(sol.T);
% Q 
Q_appro_opt=lambda\(alpha-beta*p_appro_opt)* (exp(lambda*T_appro_opt) - 1) ;
% The profit corresponding to the optimal point
profit_appro_opt = profit_appro(alpha,beta,p_appro_opt,lambda,c,h,K,T_appro_opt);
profit_appro_true = profit_appro(alpha,beta,price_true,lambda,c,h,K,T_true);
plot3(p_appro_opt,T_appro_opt,profit_appro_opt,'LineStyle','none','Marker','hexagram','MarkerSize',15,'MarkerFaceColor','none','MarkerEdgeColor','r','LineWidth',2)
plot3(price_true,T_true,profit_appro_true,'LineStyle','none','Marker','hexagram','MarkerSize',15,'MarkerFaceColor','none','MarkerEdgeColor','m','LineWidth',2)
xlabel({'销售价格'},'FontSize',12)
ylabel(['订货周期'],'FontSize',12)
zlabel(['利润'],'FontSize',16)
% zlim([-100,120])
title("(b) 番茄的近似库存利润", 'FontSize',14);
set(gca,'FontName','Microsoft YaHei','FontSize',14);
% %% save figure
savefig(fprofit_opt,'.\figure\case_profit_opt1.fig')
exportgraphics(fprofit_opt,'.\figure\case_profit_opt1.pdf')





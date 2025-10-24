% clear data and figure
clc;
clear;
close all;
% load estimated parameters
load(".\data\estimated_parameters1.mat")
%% economic order quantity
%
c=cost; % 6.5
% price_true=price_true;
T_true=T_true_value;
h=0.2;
K=5;
% price interval based on estimates
p_fit_interval=[c alpha/beta];
% cycle interval
T_interval=[1 7];
%% plot profit for estimated pars
% fit profit
fprofit_opt=figure('unit','centimeters','position',[5,5,30,15],'PaperPosition',[5,5,30,15],'PaperSize',[30,15]);
tiledlayout(1,2,'Padding','Compact');
nexttile
profit_fit_fd = @(p,T) profit(alpha,beta,p,theta,c,h,K,T);
fsurf(profit_fit_fd,[p_fit_interval,T_interval])
hold on
% solve
% simulated profit
syms p T;
profit_fit_syms = profit(alpha,beta,p,theta,c,h,K,T);
profit_fit_der_p=diff(profit_fit_syms,p);
profit_fit_der_T=diff(profit_fit_syms,T);
eq1 = profit_fit_der_p == 0;
eq2 = profit_fit_der_T == 0;
sol = vpasolve([eq1, eq2], [p, T],[p_fit_interval;T_interval]);
p_fit_opt  = double(sol.p);
T_fit_opt  = double(sol.T);
% Q
Q_fit_opt=(alpha-beta*p_fit_opt)*T_fit_opt;
% The profit corresponding to the optimal point
profit_fit_opt = profit(alpha,beta,p_fit_opt,theta,c,h,K,T_fit_opt);
profit_true = profit(alpha,beta,price_true,theta,c,h,K,T_true);
plot3(p_fit_opt,T_fit_opt,profit_fit_opt,'LineStyle','none','Marker','hexagram','MarkerFaceColor','none','MarkerEdgeColor','r','LineWidth',2,'MarkerSize',15)
plot3(price_true,T_true,profit_true,'LineStyle','none','Marker','hexagram','MarkerFaceColor','none','MarkerEdgeColor','m','LineWidth',2,'MarkerSize',15)
xlabel({'销售价格'},'FontSize',12)
ylabel(['订货周期'],'FontSize',12)
zlabel(['利润'],'FontSize',12)
% zlim([-100,120])
% title(["(b) Profit surface of estimated parameters"],'FontSize',14)
set(gca,'FontName','Microsoft YaHei','FontSize',16)
%% plot approximated profit for simulated and estimated pars
nexttile
profit_appro_fit_fd = @(p,T) profit_appro(alpha,beta,p,theta,c,h,K,T);
fsurf(profit_appro_fit_fd,[p_fit_interval,T_interval])
hold on
profit_appro_fit_syms = profit_appro(alpha,beta,p,theta,c,h,K,T);
profit_appro_fit_der_p=diff(profit_appro_fit_syms,p);
profit_appro_fit_der_T=diff(profit_appro_fit_syms,T);
eq1 = profit_appro_fit_der_p == 0;
eq2 = profit_appro_fit_der_T == 0;
sol = vpasolve([eq1, eq2], [p, T],[p_fit_interval;T_interval]);
p_appro_fit_opt  = double(sol.p);
T_appro_fit_opt  = double(sol.T);
% Q
Q_appro_fit_opt=(alpha-beta*p_appro_fit_opt)*T_appro_fit_opt;
% The profit corresponding to the optimal point
profit_appro_fit_opt = profit_appro(alpha,beta,p_appro_fit_opt,theta,c,h,K,T_appro_fit_opt);
profit_appro_true = profit_appro(alpha,beta,price_true,theta,c,h,K,T_true);
plot3(p_appro_fit_opt,T_appro_fit_opt,profit_appro_fit_opt,'LineStyle','none','Marker','hexagram','MarkerSize',15,'MarkerFaceColor','none','MarkerEdgeColor','r','LineWidth',2)
plot3(price_true,T_true,profit_appro_true,'LineStyle','none','Marker','hexagram','MarkerSize',15,'MarkerFaceColor','none','MarkerEdgeColor','m','LineWidth',2)
xlabel({'销售价格'},'FontSize',12)
ylabel(['订货周期'],'FontSize',12)
zlabel(['利润'],'FontSize',16)
% zlim([-100,120])
% title(["(b) Approximated profit of estimated parameters"],'FontSize',14)
set(gca,'FontName','Microsoft YaHei','FontSize',12)
% %% save figure
savefig(fprofit_opt,'.\figure\case_profit_opt1.fig')
exportgraphics(fprofit_opt,'.\figure\case_profit_opt1.pdf')





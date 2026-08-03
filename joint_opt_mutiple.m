% clear data and figure
clc;
clear;
close all;
% load estimated parameters
load(".\data\estimated_parameters.mat");
%% economic order quantity
iter=length(lambda_vector);
profit_opt_vector=zeros(iter,1);
profit_true_vector=zeros(iter,1);
profit_appro_opt_vector=zeros(iter,1);
profit_appro_true_vector=zeros(iter,1);
% cycle T要四舍五入
T_opt_vector=zeros(iter,1);
T_appro_opt_vector=zeros(iter,1);
price_opt_vector=zeros(iter,1);
price_appro_opt_vector=zeros(iter,1);
Q_opt_vector=zeros(iter,1);
Q_appro_opt_vector=zeros(iter,1);
%
Q_T_true_vector = zeros(iter,1);
for i = 1:iter
    lambda=lambda_vector(i);
    alpha=alpha_vector(i);
    beta=beta_vector(i);
    c=cost_vector(i);
    price_true=price_true_vector(i);
    T_true=T_true_vector(i);
    h=0.4;
    K=5;
    % price interval based on estimates
    p_interval=[c alpha/beta];
    % cycle interval
    T_interval=[1 7];
    % solve
    syms p T;
    profit_syms = profit(alpha,beta,p,lambda,c,h,K,T);
    profit_der_p=diff(profit_syms,p);
    profit_der_T=diff(profit_syms,T);
    eq1 = profit_der_p == 0;
    eq2 = profit_der_T == 0;
    sol = vpasolve([eq1, eq2], [p, T],[p_interval;T_interval]);
    p_opt  = double(sol.p);
    T_opt  = round(double(sol.T)); % 四舍五入
    if ~isempty(p_opt)
        %
        p_opt=p_opt(1);
        price_opt_vector(i,1)=p_opt;
        T_opt=T_opt(1);
        T_opt_vector(i,1)=T_opt;
        Q_opt=lambda\(alpha-beta*p_opt)* (exp(lambda*T_opt) - 1);
        Q_opt_vector(i,1)=Q_opt;
        Q_T_true = lambda\(alpha-beta*price_true)* (exp(lambda*T_true) - 1);
        Q_T_true_vector(i,1) = Q_T_true;
        % The profit corresponding to the optimal point
        profit_opt = profit(alpha,beta,p_opt,lambda,c,h,K,T_opt);
        profit_opt_vector(i,1)=profit_opt;
    else
        %
        p_opt=price_opt_vector(i-1,1);
        price_opt_vector(i,1)=p_opt;
        T_opt= T_opt_vector(i-1,1);
        T_opt_vector(i,1)=T_opt;
        Q_opt=lambda\(alpha-beta*p_opt)* (exp(lambda*T_opt) - 1);
        Q_opt_vector(i,1)=Q_opt;
        Q_T_true = lambda\(alpha-beta*price_true)* (exp(lambda*T_true) - 1);
        Q_T_true_vector(i,1) = Q_T_true;
        % The profit corresponding to the optimal point
        profit_opt = profit(alpha,beta,p_opt,lambda,c,h,K,T_opt);
        profit_opt_vector(i,1)=profit_opt;
    end
    profit_true_opt = profit(alpha,beta,price_true,lambda,c,h,K,T_true);
    profit_true_vector(i,1)=profit_true_opt;
    %% plot approximated profit for simulated and estimated pars
    profit_appro_syms = profit_appro(alpha,beta,p,lambda,c,h,K,T);
    profit_appro_der_p=diff(profit_appro_syms,p);
    profit_appro_der_T=diff(profit_appro_syms,T);
    eq1 = profit_appro_der_p == 0;
    eq2 = profit_appro_der_T == 0;
    sol = vpasolve([eq1, eq2], [p, T],[p_interval;T_interval]);
    p_appro_opt  = double(sol.p);
    T_appro_opt  = round(double(sol.T)); % 四舍五入
    if ~isempty(p_appro_opt)
        %
        p_appro_opt=p_appro_opt(1);
        price_appro_opt_vector(i,1)=p_appro_opt;
        T_appro_opt=T_appro_opt(1);
        T_appro_opt_vector(i,1)=T_appro_opt;
        Q_appro_opt=lambda\(alpha-beta*p_appro_opt)* (exp(lambda*T_appro_opt) - 1);
        Q_appro_opt_vector(i,1)=Q_appro_opt;
        % The profit corresponding to the optimal point
        profit_appro_opt = profit_appro(alpha,beta,p_appro_opt,lambda,c,h,K,T_appro_opt);
        profit_appro_opt_vector(i,1)=profit_appro_opt;
    else
        %
        p_appro_opt=price_appro_opt_vector(i-1,1);
        price_appro_opt_vector(i,1)=p_appro_opt;
        T_appro_opt= T_appro_opt_vector(i-1,1);
        T_appro_opt_vector(i,1)=T_appro_opt;
        Q_appro_opt=lambda\(alpha-beta*p_appro_opt)* (exp(lambda*T_appro_opt) - 1);
        Q_appro_opt_vector(i,1)=Q_appro_opt;
        % The profit corresponding to the optimal point
        profit_appro_opt = profit_appro(alpha,beta,p_appro_opt,lambda,c,h,K,T_appro_opt);
        profit_appro_opt_vector(i,1)=profit_appro_opt;
    end
    profit_appro_true = profit_appro(alpha,beta,price_true,lambda,c,h,K,T_true);
    profit_appro_true_vector(i,1)=profit_appro_true;
end
% plot
categories= categorical(Date_t0_vector);
profit_opt=figure('unit','centimeters','position',[5,5,40,20],'PaperPosition',[5,5,40,20],'PaperSize',[40,20]);
Profit=[profit_true_vector,profit_opt_vector];
bar(Profit)
% 添加标题和标签
% set(gca, 'XTickLabel', categories); % 设置X轴标签为类别名称
legend('实际利润', '优化利润'); % 添加图例
ylabel(['利润'],'FontSize',14);
xlabel('日期','FontSize',14);
set(gca,'FontName','Microsoft YaHei','FontSize',16)
xtick=[1:20:length(profit_true_vector)];
xticks(xtick);
xticklabels(categories(xtick)); % 自定义刻度标签
% appro plot
profit_appro_opt=figure('unit','centimeters','position',[5,5,40,20],'PaperPosition',[5,5,40,20],'PaperSize',[40,20]);
Profit_appro=[profit_appro_true_vector,profit_appro_opt_vector];
bar(Profit_appro)
% 添加标题和标签
% set(gca, 'XTickLabel', categories); % 设置X轴标签为类别名称
legend('实际利润', '优化利润'); % 添加图例
ylabel(['利润'],'FontSize',14);
xlabel('日期','FontSize',14);
set(gca,'FontName','Microsoft YaHei','FontSize',16);
xtick=[1:20:length(profit_true_vector)];
xticks(xtick);
xticklabels(categories(xtick)); % 自定义刻度标签
% save figure
savefig(profit_opt,'.\figure\case_profit_opt.fig')
exportgraphics(profit_opt,'.\figure\case_profit_opt.pdf')
savefig(profit_appro_opt,'.\figure\case_profit_appro_opt.fig')
exportgraphics(profit_appro_opt,'.\figure\case_profit_appro_opt.pdf')
%%
i=[41:245]';
opts_table = table(i,price_true_vector,T_true_vector,Q_true_vector,Q_T_true_vector,profit_true_vector,...
    price_opt_vector,T_opt_vector, Q_opt_vector,profit_opt_vector,...
    price_appro_opt_vector,T_appro_opt_vector,Q_appro_opt_vector,profit_appro_opt_vector, ...
    'VariableNames',{'滚动窗口i','实际售价','实际周期','实际订货批量','理论订货批量','实际利润',...
    '优化售价1','优化周期1','优化订货批量1','优化利润1',...
    '优化售价2','优化周期2','优化订货批量2','优化利润2'});
writetable(opts_table,'.\data\opts.xlsx');
% plot
profit_compare = [profit_true_vector,profit_opt_vector,profit_appro_opt_vector];
price_compare = [price_true_vector,price_opt_vector,price_appro_opt_vector];
T_compare = [T_true_vector,T_opt_vector,T_appro_opt_vector];
Q_compare = [Q_true_vector,Q_T_true_vector,Q_opt_vector,Q_appro_opt_vector];
%
labels1 = ["实际利润", "优化利润1","优化利润2"];
labels2 = ["实际售价", "优化售价1","优化售价2"];
labels3 = ["实际订货周期", "优化订货周期1","优化订货周期2"];
labels4 = ["实际订货批量", "理论订货批量","优化订货批量1","优化订货批量2"];
profit_opt = figure('unit','centimeters','position',[10,0,30,20],'PaperPosition',[0, 0, 30,20],'PaperSize',[30,20]);
ax = subplot(2,2,1);
bp = boxplot(profit_compare,'Labels',labels1);
grid minor;
set(findobj(gca,'Type','Line'),'LineWidth',1.5);
set(gca,'FontName','宋体','FontSize',12);
title(ax, "(a) 库存利润", 'FontSize',14);
ax = subplot(2,2,2);
bp = boxplot(price_compare,'Labels',labels2);
grid minor;
set(findobj(gca,'Type','Line'),'LineWidth',1.5);
set(gca,'FontName','宋体','FontSize',12);
title(ax, "(b) 销售价格", 'FontSize',14);
ax = subplot(2,2,3);
bp = boxplot(T_compare,'Labels',labels3);
grid minor;
set(findobj(gca,'Type','Line'),'LineWidth',1.5);
set(gca,'FontName','宋体','FontSize',12);
title(ax, "(c) 订货周期", 'FontSize',14);
ax = subplot(2,2,4);
bp = boxplot(Q_compare,'Labels',labels4);
grid minor;
set(findobj(gca,'Type','Line'),'LineWidth',1.5);
set(gca,'FontName','宋体','FontSize',12);
title(ax, "(a) 订货批量", 'FontSize',14);
% save figure
savefig(profit_opt,'.\figure\profit_opt.fig')
exportgraphics(profit_opt,'.\figure\profit_opt.pdf')



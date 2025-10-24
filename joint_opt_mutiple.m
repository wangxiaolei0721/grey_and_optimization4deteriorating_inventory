% clear data and figure
clc;
clear;
close all;
% load estimated parameters
load(".\data\estimated_parameters.mat")
%% economic order quantity
iter=length(cost_vector);
profit_fit_opt_vector=zeros(iter,1);
profit_true_opt_vector=zeros(iter,1);
profit_appro_fit_opt_vector=zeros(iter,1);
profit_appro_true_opt_vector=zeros(iter,1);
% cycle
T_fit_opt_vector=zeros(iter,1);
T_appro_fit_opt_vector=zeros(iter,1);
price_fit_opt_vector=zeros(iter,1);
price_appro_fit_opt_vector=zeros(iter,1);
% economic parameter
for i = 1:iter
    alpha=alpha_vector(i);
    beta=beta_vector(i);
    theta=theta_vector(i);
    c=cost_vector(i); % 6.5
    price=price_vector(i);
    T_true=T_vector(i);
    h=0.2;
    K=5;
    % price interval based on estimates
    p_fit_interval=[c alpha/beta];
    % cycle interval
    T_interval=[1 7];
    %% plot profit for estimated pars
    % fit profit
    % fprofit_opt=figure('unit','centimeters','position',[5,5,30,15],'PaperPosition',[5,5,30,15],'PaperSize',[30,15]);
    % tiledlayout(1,2,'Padding','Compact');
    % nexttile
    % profit_fit_fd = @(p,T) profit(alpha,beta,p,theta,c,h,K,T);
    % fsurf(profit_fit_fd,[p_fit_interval,T_interval])
    % hold on
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
    if ~isempty(p_fit_opt)
        % Q
        p_fit_opt=p_fit_opt(1);
        T_fit_opt=T_fit_opt(1);
        Q_fit_opt=(alpha-beta*p_fit_opt)*T_fit_opt;
        % The profit corresponding to the optimal point
        profit_fit_opt = profit(alpha,beta,p_fit_opt,theta,c,h,K,T_fit_opt);
        profit_fit_opt_vector(i,1)=profit_fit_opt;
        price_fit_opt_vector(i,1)=p_fit_opt;
        T_fit_opt_vector(i,1)=T_fit_opt;
    else
        % Q
        p_fit_opt=price_fit_opt_vector(i-1,1);
        T_fit_opt= T_fit_opt_vector(i-1,1);
        Q_fit_opt=(alpha-beta*p_fit_opt)*T_fit_opt;
        % The profit corresponding to the optimal point
        profit_fit_opt = profit(alpha,beta,p_fit_opt,theta,c,h,K,T_fit_opt);
        profit_fit_opt_vector(i,1)=profit_fit_opt;
        price_fit_opt_vector(i,1)=p_fit_opt;
        T_fit_opt_vector(i,1)=T_fit_opt;
    end
    profit_true_opt = profit(alpha,beta,price,theta,c,h,K,T_true);
    profit_true_opt_vector(i,1)=profit_true_opt;
    % plot3(p_fit_opt,T_fit_opt,profit_fit_opt,'LineStyle','none','Marker','hexagram','MarkerFaceColor',[0 1 0],'MarkerSize',15)
    % xlabel({'销售价格'},'FontSize',12)
    % ylabel(['订货周期'],'FontSize',12)
    % zlabel(['利润'],'FontSize',12)
    % % zlim([-100,120])
    % % title(["(b) Profit surface of estimated parameters"],'FontSize',14)
    % set(gca,'FontName','Microsoft YaHei','FontSize',12)
    %% plot approximated profit for simulated and estimated pars
    % nexttile
    % profit_appro_fit_fd = @(p,T) profit_appro(alpha,beta,p,theta,c,h,K,T);
    % fsurf(profit_appro_fit_fd,[p_fit_interval,T_interval])
    % hold on
    profit_appro_fit_syms = profit_appro(alpha,beta,p,theta,c,h,K,T);
    profit_appro_fit_der_p=diff(profit_appro_fit_syms,p);
    profit_appro_fit_der_T=diff(profit_appro_fit_syms,T);
    eq1 = profit_appro_fit_der_p == 0;
    eq2 = profit_appro_fit_der_T == 0;
    sol = vpasolve([eq1, eq2], [p, T],[p_fit_interval;T_interval]);
    p_appro_fit_opt  = double(sol.p);
    T_appro_fit_opt  = double(sol.T);
    if ~isempty(p_appro_fit_opt)
        % Q
        p_appro_fit_opt=p_appro_fit_opt(1);
        T_appro_fit_opt=T_appro_fit_opt(1);
        Q_appro_fit_opt=(alpha-beta*p_appro_fit_opt)*T_appro_fit_opt;
        price_appro_fit_opt_vector(i,1)=p_appro_fit_opt;
        T_appro_fit_opt_vector(i,1)=T_appro_fit_opt;
        % The profit corresponding to the optimal point
        profit_appro_fit_opt = profit_appro(alpha,beta,p_appro_fit_opt,theta,c,h,K,T_appro_fit_opt);
        profit_appro_fit_opt_vector(i,1)=profit_appro_fit_opt;
        else
        % Q
        p_appro_fit_opt=price_appro_fit_opt_vector(i-1,1);
        T_appro_fit_opt= T_appro_fit_opt_vector(i-1,1);
        Q_appro_fit_opt=(alpha-beta*p_appro_fit_opt)*T_appro_fit_opt;
        % The profit corresponding to the optimal point
        profit_appro_fit_opt = profit_appro(alpha,beta,p_appro_fit_opt,theta,c,h,K,T_appro_fit_opt);
        profit_appro_fit_opt_vector(i,1)=profit_appro_fit_opt;
        price_appro_fit_opt_vector(i,1)=p_appro_fit_opt;
        T_appro_fit_opt_vector(i,1)=T_appro_fit_opt;
    end
    profit_appro_true_opt = profit_appro(alpha,beta,price,theta,c,h,K,T_true);
    profit_appro_true_opt_vector(i,1)=profit_appro_true_opt;
    % plot3(p_appro_fit_opt,T_appro_fit_opt,profit_appro_fit_opt,'LineStyle','none','Marker','hexagram','MarkerFaceColor',[1 0.200000002980232 0.200000002980232],'MarkerSize',15)
    % xlabel({'销售价格'},'FontSize',12)
    % ylabel(['订货周期'],'FontSize',12)
    % zlabel(['利润'],'FontSize',12)
    % % zlim([-100,120])
    % % title(["(b) Approximated profit of estimated parameters"],'FontSize',14)
    % set(gca,'FontName','Microsoft YaHei','FontSize',12)
end


% plot
categories= categorical(Date_t0_vector');
profit_opt=figure('unit','centimeters','position',[5,5,40,20],'PaperPosition',[5,5,40,20],'PaperSize',[40,20]);
Profit=[profit_true_opt_vector,profit_fit_opt_vector];
bar(Profit)
% 添加标题和标签
% set(gca, 'XTickLabel', categories); % 设置X轴标签为类别名称
legend('实际利润', '优化利润'); % 添加图例
ylabel(['利润'],'FontSize',14)
xlabel('日期','FontSize',14)
set(gca,'FontName','Microsoft YaHei','FontSize',16)
xtick=[1:20:length(profit_true_opt_vector)];
xticks(xtick);
xticklabels(categories(xtick)); % 自定义刻度标签
% appro plot
profit_appro_opt=figure('unit','centimeters','position',[5,5,40,20],'PaperPosition',[5,5,40,20],'PaperSize',[40,20]);
Profit_appro=[profit_appro_true_opt_vector,profit_appro_fit_opt_vector];
bar(Profit_appro)
% 添加标题和标签
% set(gca, 'XTickLabel', categories); % 设置X轴标签为类别名称
legend('实际利润', '优化利润'); % 添加图例
ylabel(['利润'],'FontSize',14)
xlabel('日期','FontSize',14)
set(gca,'FontName','Microsoft YaHei','FontSize',16)
xtick=[1:20:length(profit_true_opt_vector)];
xticks(xtick);
xticklabels(categories(xtick)); % 自定义刻度标签
% %% save figure
savefig(profit_opt,'.\figure\case_profit_opt.fig')
exportgraphics(profit_opt,'.\figure\case_profit_opt.pdf')
savefig(profit_appro_opt,'.\figure\case_profit_appro_opt.fig')
exportgraphics(profit_appro_opt,'.\figure\case_profit_appro_opt.pdf')



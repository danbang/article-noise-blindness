    %% Figure 3A
    yLims = [0.5 1];
    WhSubs = 21:40;
    
    PprWidth= 21*.9;
    figure('name','Confidence','color','w','units','centimeters','position',[1 1 .25*PprWidth PprWidth/4])
    iSP = [4 1 6];
    BarPlotJitter(1:3,(confh(WhSubs,iSP)./100),HumanColorBars); 
    box off
    ylim(yLims)
    set(gca,'ytick',[0.5 1],'yticklabel',[50 100],'xtick',[1:3],'xticklabel',[])
    
    cd('Figures')
    print('Fig_main_3A','-depsc')
    cd ..
    
    % t-tests
    WH  = (confh(WhSubs,iSP))./100;
    [hH, pH1, CI, stats1]   = ttest([ WH(:,1)-WH(:,2) WH(:,1)-WH(:,3) WH(:,3)-WH(:,2) ]);
    ttests_table_fig_3a = [];
    ttests_table_fig_3a.comparison = {'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c'};
    ttests_table_fig_3a.tstat = stats1.tstat';
    ttests_table_fig_3a.df = stats1.df';
    ttests_table_fig_3a.pvalue = pH1';
    ttests_table_fig_3a = struct2table(ttests_table_fig_3a);
    save('Stats/ttests_table_fig_3a.mat','ttests_table_fig_3a')
    
    % Run anova
    SaveAnovaTables_confidence_human(confh)
    %% Figure 3B
    PprWidth= 21*.9;
    figure('name','Regression Human Confidence','color','w','units','centimeters','position',[1 1 .4*PprWidth PprWidth/4])
    WhSubs = 21:40;
    NumReg = size(betasconfunsignedH,2);
    bar(2:NumReg,nanmean(betasconfunsignedH(WhSubs,2:NumReg)),'facecolor',HumanColorBars); hold on,
    errorbar(2:NumReg,nanmean(betasconfunsignedH(WhSubs,2:NumReg)),nanstd(betasconfunsignedH(WhSubs,2:NumReg))./sqrt(numel(WhSubs)-1),'.','color','k','markerfacecolor','k','markeredgecolor','k');
    box off
    set(gca,'xtick',[2:NumReg],'xticklabel',{},'ytick',[-.06 0 0.06])
    xlim([1 NumReg+1])
    ylim([-.06 0.06])
    
    cd('Figures')
    print('Fig_main_3B','-depsc')
    cd ..
    
    % t-tests
    [hH, pH1, CI, stats1] = ttest(betasconfunsignedH(WhSubs,1:NumReg));
    ttests_table_fig_3b = [];
    ttests_table_fig_3b.predictor = {'Intercept'; 'absolute average orientation'; 'contrast' ;'variability';'choice correctness';'RTs'};
    ttests_table_fig_3b.tstat = stats1.tstat';
    ttests_table_fig_3b.df = stats1.df';
    ttests_table_fig_3b.pvalue = pH1';
    ttests_table_fig_3b = struct2table(ttests_table_fig_3b);
    save('Stats/ttests_table_fig_3b.mat','ttests_table_fig_3b')
    %% Figure 3C
    yLims = [-5 20];
    WhSubs = 21:40;
    
    PprWidth= 21*.9;
    figure('name','Overconfidence humans','color','w','units','centimeters','position',[1 1 .25*PprWidth PprWidth/4])
    iSP = [4 1 6];
    ovrcnfh = (confh)-(acch.*100);
    BarPlotJitter(1:3,ovrcnfh(WhSubs,iSP),HumanColorBars); 
    box off
    ylim(yLims)
    set(gca,'ytick',[-5 0 20],'xtick',[1:3],'xticklabel',[])
    
    cd('Figures')
    print('Fig_main_3C','-depsc')
    cd ..
    
    % t-tests
    WH  = (ovrcnfh(WhSubs,iSP));
    [hH, pH1, CI, stats1]   = ttest([...
        WH(:,1)  WH(:,2) WH(:,3) ...
        WH(:,1)-WH(:,2) WH(:,1)-WH(:,3) WH(:,3)-WH(:,2) ]);
    ttests_table_fig_3c = [];
    ttests_table_fig_3c.comparison = {...
        'baseline'; 'low-c'; 'high-v' ; ...
        'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c' };
    ttests_table_fig_3c.tstat = stats1.tstat';
    ttests_table_fig_3c.df = stats1.df';
    ttests_table_fig_3c.pvalue = pH1';
    ttests_table_fig_3c = struct2table(ttests_table_fig_3c);
    save('Stats/ttests_table_fig_3c.mat','ttests_table_fig_3c')
    
    
    %% Figure 3D
    yLims = [0.5 1];
    
    % we excluded two people that didn't use the opt-out option
    wh_subs_optoh = [find(OptOutVarMatH>0.2)]; 
    
    PprWidth= 21*.9;
    figure('name','Over confidence humans','color','w','units','centimeters','position',[1 1 .25*PprWidth PprWidth/4])
    iSP = 6+[4 1 6];
    BarPlotJitter(1:3,optoh(wh_subs_optoh,iSP),HumanColorBars); 
    box off
    ylim(yLims)
    set(gca,'ytick',[.5 1],'xtick',[1:3],'xticklabel',[])
    
    cd('Figures')
    print('Fig_main_3D','-depsc')
    cd ..
    % t-test accuracy
    WH  = (acch(wh_subs_optoh,[4 1 6]));
    [hH, pH1, CI, stats1]   = ttest([ WH(:,1)-WH(:,2) WH(:,1)-WH(:,3) WH(:,3)-WH(:,2) ]);
    ttests_table_acc_exp3 = [];
    ttests_table_acc_exp3.comparison = {'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c'};
    ttests_table_acc_exp3.tstat = stats1.tstat';
    ttests_table_acc_exp3.df = stats1.df';
    ttests_table_acc_exp3.pvalue = pH1';
    ttests_table_acc_exp3 = struct2table(ttests_table_acc_exp3);
    save('Stats/ttests_table_acc_exp3.mat','ttests_table_acc_exp3')
    
    % t-tests opt-out
    WH  = (optoh(wh_subs_optoh,iSP));
    [hH, pH1, CI, stats1]   = ttest([ WH(:,1)-WH(:,2) WH(:,1)-WH(:,3) WH(:,3)-WH(:,2) ]);
    ttests_table_fig_3d = [];
    ttests_table_fig_3d.comparison = {'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c'};
    ttests_table_fig_3d.tstat = stats1.tstat';
    ttests_table_fig_3d.df = stats1.df';
    ttests_table_fig_3d.pvalue = pH1';
    ttests_table_fig_3d = struct2table(ttests_table_fig_3d);
    save('Stats/ttests_table_fig_3d.mat','ttests_table_fig_3d')
    
    % Run anova
    SaveAnovaTables_optout_human(optoh(wh_subs_optoh,:))
    
    %% t-tests on regression coefficients
    NumReg = size(betasoptoH,2);
    [hH, pH1, CI, stats1] = ttest(betasoptoH(wh_subs_optoh,1:NumReg));
    ttests_table_fig_3d_reg = [];
    ttests_table_fig_3d_reg.predictor = {'Intercept'; 'absolute average orientation'; 'contrast' ;'variability';'RTs'};
    ttests_table_fig_3d_reg.tstat = stats1.tstat';
    ttests_table_fig_3d_reg.df = stats1.df';
    ttests_table_fig_3d_reg.pvalue = pH1';
    ttests_table_fig_3d_reg = struct2table(ttests_table_fig_3d_reg);
    save('Stats/ttests_table_fig_3d_reg.mat','ttests_table_fig_3d_reg')

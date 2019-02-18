%% Figure 6


% Get human summary choice measures for experiments 4 and 5
[acch_exp4, confh_exp4, biash_exp4, discaccs_exp4]    = GetSummaryBehaviourMeasures_Exp4();
[acch_exp5, confh_exp5, biash_exp5]    = GetSummaryBehaviourMeasures_Exp5();

%% Figure 6A

figure('name','Accuracies Exp4','color','w','units','centimeters','position',[1 1 .25*PprWidth PprWidth/4])
WhSubs = 1:23;

iSP = [3 1 4];
BarPlot(1:3,acch_exp4(WhSubs,iSP),HumanColorBars);
LinePlot(1:3,acch_exp4(WhSubs,iSP + 8),HumanColorLinePink);
LinePlot(1:3,acch_exp4(WhSubs,iSP + 16),HumanColorLineYellow);
ylim([0.5 1])
set(gca,'ytick',[0.5 1],'xtick',[1:3],'xticklabel',[])
box off

cd('Figures')
print('Fig_main_6A','-depsc')
cd ..

% Run t-tests
WH1  = acch_exp4(WhSubs,iSP);
WH2  = acch_exp4(WhSubs,iSP+8);
WH3  = acch_exp4(WhSubs,iSP+16);
[hH1, pH1, CI1, stats1]   = ttest([ ...
    WH1(:,1)-WH1(:,2) WH1(:,1)-WH1(:,3) WH1(:,3)-WH1(:,2) ...
    WH2(:,1)-WH2(:,2) WH2(:,1)-WH2(:,3) WH2(:,3)-WH2(:,2) ...
    WH3(:,1)-WH3(:,2) WH3(:,1)-WH3(:,3) WH3(:,3)-WH3(:,2)]);
ttests_table_fig_6a = [];
ttests_table_fig_6a.comparison = { ...
    'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c'; ...
    'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c'; ...
    'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c'};
ttests_table_fig_6a.trialtype = { ...
    'all trials'; 'all trials'; 'all trials'; ...
    'correct contrast discrimination'; 'correct contrast discrimination'; 'correct contrast discrimination'; ...
    'correct variability discrimination'; 'correct variability discrimination'; 'correct variability discrimination'};
ttests_table_fig_6a.tstat = stats1.tstat';
ttests_table_fig_6a.df = stats1.df';
ttests_table_fig_6a.pvalue = pH1';
ttests_table_fig_6a = struct2table(ttests_table_fig_6a);


save('Stats/ttests_table_fig_6a.mat','ttests_table_fig_6a')



%% Figure 6B

figure('name','Accuracies Exp4','color','w','units','centimeters','position',[1 1 .25*PprWidth PprWidth/4])
WhSubs = 1:23;

iSP = 4+[3 1 4];
BarPlot(1:3,biash_exp4(WhSubs,iSP),HumanColorBars);
LinePlot(1:3,biash_exp4(WhSubs,iSP + 8),HumanColorLinePink);
LinePlot(1:3,biash_exp4(WhSubs,iSP + 16),HumanColorLineYellow);
ylim([0 2])
set(gca,'ytick',[0 2],'xtick',[1:3],'xticklabel',[])
box off

cd('Figures')
print('Fig_main_6B','-depsc')
cd ..

% Run t-tests
WH1  = biash_exp4(WhSubs,iSP);
WH2  = biash_exp4(WhSubs,iSP+8);
WH3  = biash_exp4(WhSubs,iSP+16);
WH4  = biash_exp4(WhSubs,iSP+24);
WH5  = biash_exp4(WhSubs,iSP+32);
[hH1, pH1, CI1, stats1]   = ttest([ ...
    WH1(:,1)-WH1(:,2) WH1(:,1)-WH1(:,3) WH1(:,3)-WH1(:,2) ...
    WH2(:,1)-WH2(:,2) WH2(:,1)-WH2(:,3) WH2(:,3)-WH2(:,2) ...
    WH3(:,1)-WH3(:,2) WH3(:,1)-WH3(:,3) WH3(:,3)-WH3(:,2) ...
    WH4(:,1)-WH4(:,2) WH4(:,1)-WH4(:,3) WH4(:,3)-WH4(:,2) ...
    WH5(:,1)-WH5(:,2) WH5(:,1)-WH5(:,3) WH5(:,3)-WH5(:,2) ]);
ttests_table_fig_6b = [];
ttests_table_fig_6b.comparison = { ...
    'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c'; ...
    'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c'; ...
    'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c'; ...
    'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c'; ...
    'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c' };
ttests_table_fig_6b.trialtype = { ...
    'all trials'; 'all trials'; 'all trials'; ...
    'correct contrast discrimination'; 'correct contrast discrimination'; 'correct contrast discrimination'; ...
    'correct variability discrimination'; 'correct variability discrimination'; 'correct variability discrimination'; ...
    'incorrect contrast discrimination'; 'incorrect contrast discrimination'; 'incorrect contrast discrimination'; ...
    'incorrect variability discrimination'; 'incorrect variability discrimination'; 'incorrect variability discrimination'};
ttests_table_fig_6b.tstat = stats1.tstat';
ttests_table_fig_6b.df = stats1.df';
ttests_table_fig_6b.pvalue = pH1';
ttests_table_fig_6b = struct2table(ttests_table_fig_6b);


save('Stats/ttests_table_fig_6b.mat','ttests_table_fig_6b')




%% Figure 6C

figure('name','Accuracies Exp4','color','w','units','centimeters','position',[1 1 .25*PprWidth PprWidth/4])
WhSubs = 1:24;

iSP = [3 1 4];
BarPlot(1:3,acch_exp5(WhSubs,iSP),HumanColorBars);
LinePlot(1:3,acch_exp5(WhSubs,iSP + 8),HumanColorLineGreen);
LinePlot(1:3,acch_exp5(WhSubs,iSP + 16),HumanColorLineOrange);
ylim([0.5 1])
set(gca,'ytick',[0.5 1],'xtick',[1:3],'xticklabel',[])
box off

cd('Figures')
print('Fig_main_6C','-depsc')
cd ..

% Run t-tests
WH1  = acch_exp5(WhSubs,iSP);
WH2  = acch_exp5(WhSubs,iSP+8);
WH3  = acch_exp5(WhSubs,iSP+16);
[hH1, pH1, CI1, stats1]   = ttest([ ...
    WH1(:,1)-WH1(:,2) WH1(:,1)-WH1(:,3) WH1(:,3)-WH1(:,2) ...
    WH2(:,1)-WH2(:,2) WH2(:,1)-WH2(:,3) WH2(:,3)-WH2(:,2) ...
    WH3(:,1)-WH3(:,2) WH3(:,1)-WH3(:,3) WH3(:,3)-WH3(:,2)]);
ttests_table_fig_6c = [];
ttests_table_fig_6c.comparison = { ...
    'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c'; ...
    'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c'; ...
    'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c'};
ttests_table_fig_6c.trialtype = { ...
    'all trials'; 'all trials'; 'all trials'; ...
    'fixed contrast'; 'fixed contrast'; 'fixed contrast'; ...
    'fixed variability'; 'fixed variability'; 'fixed variability'};
ttests_table_fig_6c.tstat = stats1.tstat';
ttests_table_fig_6c.df = stats1.df';
ttests_table_fig_6c.pvalue = pH1';
ttests_table_fig_6c = struct2table(ttests_table_fig_6c);
save('Stats/ttests_table_fig_6c.mat','ttests_table_fig_6c')



%% Figure 6D

figure('name','Accuracies Exp4','color','w','units','centimeters','position',[1 1 .25*PprWidth PprWidth/4])
WhSubs = 1:24;

iSP = 4+[3 1 4];
BarPlot(1:3,biash_exp5(WhSubs,iSP),HumanColorBars);
LinePlot(1:3,biash_exp5(WhSubs,iSP + 8),HumanColorLineGreen);
LinePlot(1:3,biash_exp5(WhSubs,iSP + 16),HumanColorLineOrange);
ylim([0 1])
set(gca,'ytick',[0 1],'xtick',[1:3],'xticklabel',[])
box off

cd('Figures')
print('Fig_main_6D','-depsc')
cd ..

% Run t-tests
WH1  = biash_exp5(WhSubs,iSP);
WH2  = biash_exp5(WhSubs,iSP+8);
WH3  = biash_exp5(WhSubs,iSP+16);
[hH1, pH1, CI1, stats1]   = ttest([ ...
    WH1(:,1)-WH1(:,2) WH1(:,1)-WH1(:,3) WH1(:,3)-WH1(:,2) ...
    WH2(:,1)-WH2(:,2) WH2(:,1)-WH2(:,3) WH2(:,3)-WH2(:,2) ...
    WH3(:,1)-WH3(:,2) WH3(:,1)-WH3(:,3) WH3(:,3)-WH3(:,2)]);
ttests_table_fig_6d = [];
ttests_table_fig_6d.comparison = { ...
    'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c'; ...
    'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c'; ...
    'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c'};
ttests_table_fig_6d.trialtype = { ...
    'all trials'; 'all trials'; 'all trials'; ...
    'fixed contrast'; 'fixed contrast'; 'fixed contrast'; ...
    'fixed variability'; 'fixed variability'; 'fixed variability'};
ttests_table_fig_6d.tstat = stats1.tstat';
ttests_table_fig_6d.df = stats1.df';
ttests_table_fig_6d.pvalue = pH1';
ttests_table_fig_6d = struct2table(ttests_table_fig_6d);
save('Stats/ttests_table_fig_6d.mat','ttests_table_fig_6d')


[~, p_val_fixed_highvlowc, CI1, stats_fixed_highvlowc]   = ttest([WH2(:,2)-WH3(:,3)]);
save('Stats/ttest_fixed_highvlowc_fig_6d.mat','p_val_fixed_highvlowc','stats_fixed_highvlowc')



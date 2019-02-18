%% Figure Supplementray 7

% Get human summary RT measures for experiments 1,2 and 3
[rtsh]    = GetSummaryRTsMeasures_Exp123(data);

yLims1 = [0.2 1];
WhSubs1 = 1:40;
figure('name','RTs Exp 1 and 2','color','w','units','centimeters','position',[1 1 .25*PprWidth PprWidth/4])
iSP = [4 1 6];

BarPlotJitter(1:3,rtsh(WhSubs1,iSP),HumanColorBars);
box off
ylim(yLims1)
set(gca,'ytick',yLims1,'xtick',[1:3],'xticklabel',[])
cd('Figures')
print('Fig_SI_7','-depsc')
cd ..

% Run t-tests
WH1  = rtsh(WhSubs1,iSP);
[hH1, pH1, CI1, stats1]   = ttest([ WH1(:,1)-WH1(:,2) WH1(:,1)-WH1(:,3) WH1(:,3)-WH1(:,2) ]);
ttests_table_fig_si_7 = [];
ttests_table_fig_si_7.comparison = {'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c'};
ttests_table_fig_si_7.tstat = stats1.tstat';
ttests_table_fig_si_7.df = stats1.df';
ttests_table_fig_si_7.pvalue = pH1';
ttests_table_fig_si_7 = struct2table(ttests_table_fig_si_7);
save('Stats/ttests_table_fig_si_7.mat','ttests_table_fig_si_7')

% Run anova
SaveAnovaTables_responsetimes_human(rtsh)
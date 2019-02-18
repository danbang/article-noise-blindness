%% Supplementary Figure 3

% get collapsed RTs
[collRTsMat,collConfMat,collcRTsMat,collcConfMat] = GetCollapsedRTsAndConf(data);

[PsychoMatH,PsychoMataH,PsychoMatrH,PsychoMatcH] = GetPsychometricPoints(data);
[PsychoMat1,PsychoMata1,PsychoMatr1,PsychoMatc1] = GetPsychometricPoints(mdata_opt);
[PsychoMat2,PsychoMata2,PsychoMatr2,PsychoMatc2] = GetPsychometricPoints(mdata_semi);
[PsychoMat3,PsychoMata3,PsychoMatr3,PsychoMatc3] = GetPsychometricPoints(mdata_blate);

yLims = [-0.2 0.3];
WhSubs = 21:40; % 61:81

PprWidth= 21*.9;
figure('name','Overconfidence','color','w','units','centimeters','position',[1 1 PprWidth PprWidth/3])
subplot(1,3,1)
iSP = [4 1 6];
BarPlotJitter(1:3,(confh(WhSubs1,iSP)./100)-(acch(WhSubs1,iSP)),HumanColorBars);
box off
ylim(yLims)
set(gca,'ytick',[-0.2 0 0.3],'xtick',[1:3],'xticklabel',[])

subplot(1,3,2)
BarPlotJitter(1:3,(confmopt2(WhSubs1,iSP)./100)-(accmopt2(WhSubs1,iSP)),HumanColorBars);
box off
ylim(yLims)
set(gca,'ytick',[-0.2 0 0.3],'xtick',[1:3],'xticklabel',[])

subplot(1,3,3)
BarPlotJitter(1:3,(confmopt3(WhSubs1,iSP)./100)-(accmopt3(WhSubs1,iSP)),HumanColorBars);
box off
ylim(yLims)
set(gca,'ytick',[-0.2 0 0.3],'xtick',[1:3],'xticklabel',[])

cd('Figures')
print('Fig_SI_3','-depsc')
cd ..

WH1  = (confh(WhSubs,iSP))./100-acch(WhSubs,iSP);
WM1 = (confmopt1(WhSubs,iSP))./100-accmopt1(WhSubs,iSP);
WM2 = (confmopt2(WhSubs,iSP))./100-accmopt2(WhSubs,iSP);
WM3 = (confmopt3(WhSubs,iSP))./100-accmopt3(WhSubs,iSP);

[hH1, pH1, CI1, stats1]   = ttest([...
    WH1(:,1)-WH1(:,2) WH1(:,1)-WH1(:,3) WH1(:,3)-WH1(:,2) ...
    WM2(:,1)-WM2(:,2) WM2(:,1)-WM2(:,3) WM2(:,3)-WM2(:,2) ...
    WM3(:,1)-WM3(:,2) WM3(:,1)-WM3(:,3) WM3(:,3)-WM3(:,2) ]);
ttests_table_fig_si_3 = [];
ttests_table_fig_si_3.comparison = { ...
    'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c'; ...
    'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c'; ...
    'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c'};
ttests_table_fig_si_3.trialtype = { ...
    'human'; 'human'; 'human'; ...
    'variability mixer'; 'variability mixer'; 'variability mixer'; ...
    'noise blind'; 'noise blind'; 'noise blind'};
ttests_table_fig_si_3.tstat = stats1.tstat';
ttests_table_fig_si_3.df = stats1.df';
ttests_table_fig_si_3.pvalue = pH1';
ttests_table_fig_si_3 = struct2table(ttests_table_fig_si_3);


save('Stats/ttests_table_fig_si_3.mat','ttests_table_fig_si_3')




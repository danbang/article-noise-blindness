%% Figure Supplementray 8
%% Figure 6A
load('data_human_noise_blindness_models.mat')
[AccGainH1,ResCMatH]  = Get_AccuracyGainAndConfRes(data);
[AccGainM1,ResCMatM1] = Get_AccuracyGainAndConfRes(mdata_opt);
[AccGainM2,ResCMatM2] = Get_AccuracyGainAndConfRes(mdata_blate);
[AccGainM3,ResCMatM3] = Get_AccuracyGainAndConfRes(mdata_semi);

WhSubs = 1:40;
iSP1 = [2 1 2];
iSP2 = [1 1 3];
KeyAccH1 = [ (AccGainH1(WhSubs,iSP1(1),iSP2(1))) (AccGainH1(WhSubs,iSP1(2),iSP2(2))) (AccGainH1(WhSubs,iSP1(3),iSP2(3)))];
KeyAccM1 = [ (AccGainM1(WhSubs,iSP1(1),iSP2(1))) (AccGainM1(WhSubs,iSP1(2),iSP2(2))) (AccGainM1(WhSubs,iSP1(3),iSP2(3)))];
KeyAccM2 = [ (AccGainM2(WhSubs,iSP1(1),iSP2(1))) (AccGainM2(WhSubs,iSP1(2),iSP2(2))) (AccGainM2(WhSubs,iSP1(3),iSP2(3)))];
KeyAccM3 = [ (AccGainM3(WhSubs,iSP1(1),iSP2(1))) (AccGainM3(WhSubs,iSP1(2),iSP2(2))) (AccGainM3(WhSubs,iSP1(3),iSP2(3)))];


%PaperSize = [21	29.7];
PprWidth= 21*.9;
figure('name','Accuracy Gains Exps 1 and 2','color','w','units','centimeters','position',[1 1 PprWidth PprWidth/3])

Y_Lims = [-0.05 0.15];
subplot(1,4,1)
BarPlotJitter(1:3,KeyAccH1(WhSubs,:),HumanColorBars);
ylim(Y_Lims)
set(gca,'ytick',Y_Lims,'xtick',[1:3],'xticklabel',[])
box off
subplot(1,4,2)
BarPlotJitter(1:3,KeyAccM1(WhSubs,:),HumanColorBars);
ylim(Y_Lims)
set(gca,'ytick',Y_Lims,'xtick',[1:3],'xticklabel',[])
box off
subplot(1,4,3)
BarPlotJitter(1:3,KeyAccM2(WhSubs,:),HumanColorBars);
ylim(Y_Lims)
set(gca,'ytick',Y_Lims,'xtick',[1:3],'xticklabel',[])
box off
subplot(1,4,4)
BarPlotJitter(1:3,KeyAccM3(WhSubs,:),HumanColorBars);
ylim(Y_Lims)
set(gca,'ytick',Y_Lims,'xtick',[1:3],'xticklabel',[])
box off

cd('Figures')
print('Fig_SI_8','-depsc')
cd ..

% Run t-tests
WH1  = KeyAccH1;
WH2  = KeyAccM1;
WH3  = KeyAccM2;
WH4  = KeyAccM3;
[hH1, pH1, CI1, stats1]   = ttest([ ...
    WH1(:,1)-WH1(:,2) WH1(:,1)-WH1(:,3) WH1(:,3)-WH1(:,2) ...
    WH2(:,1)-WH2(:,2) WH2(:,1)-WH2(:,3) WH2(:,3)-WH2(:,2) ...
    WH3(:,1)-WH3(:,2) WH3(:,1)-WH3(:,3) WH3(:,3)-WH3(:,2) ...
    WH4(:,1)-WH4(:,2) WH4(:,1)-WH4(:,3) WH4(:,3)-WH4(:,2)]);
ttests_table_fig_si_8a = [];
ttests_table_fig_si_8a.comparison = { ...
    'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c'; ...
    'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c'; ...
    'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c'; ...
    'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c'};
ttests_table_fig_si_8a.datatype = { ...
    'humans'; 'humans'; 'humans'; ...
    'Omniscient'; 'Omniscient'; 'Omniscient'; ...
    'Noise Blind'; 'Noise Blind'; 'Noise Blind'; ...
    'Variability Mixer'; 'Variability Mixer'; 'Variability Mixer'};

    ttests_table_fig_si_8a.tstat = stats1.tstat';
ttests_table_fig_si_8a.df = stats1.df';
ttests_table_fig_si_8a.pvalue = pH1';
ttests_table_fig_si_8a = struct2table(ttests_table_fig_si_8a);

save('Stats/ttests_table_fig_si_8a.mat','ttests_table_fig_si_8a')
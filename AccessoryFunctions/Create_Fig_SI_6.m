
%load human data
load('Data/data_human_noise_blindness_Exp_1236.mat')

cd Data
is_file = dir('Simulations_Fig_SI_6*');
if numel(is_file) == 0 % file does not exist yet
    [bestsets,bestvals,fitflags] = FitNoisesSubsamplingNeutralConditionsGeneticAlgorithm(data);
    save('Simulations_Fig_SI_6.mat','bestsets','bestvals','fitflags')
elseif numel(is_file) == 1 % file exists already
    load('Simulations_Fig_SI_6.mat')
end
cd ..


best_ks = histc(bestsets(:,3),.5:1:8.5);
table_best_k_values_subsampling = array2table( [best_ks(1:8)']);
save('Stats/table_best_k_values_subsampling.mat','table_best_k_values_subsampling')



% Get human summary choice measures for experiment 6
[acchss, confhss, biashss] = GetSummaryBehaviourMeasures_Exp6(data);

%%
WhSubs = 61:81;
MrkrSz = 25;
PprWidth= 21*.9;
figure('name','SetSize Accuracy','color','w','units','centimeters','position',[1 1 .2*PprWidth .2*PprWidth])

BarPlot(1:3,acchss(WhSubs,[3 1 4]),HumanColorBars);
LinePlot(1:3,acchss(WhSubs,4+[3 1 4]),[.8 .0 .0]);
ylim([0.5 1])
set(gca,'xtick',1:6,'xticklabel','','ytick',[0.5 1])
xlim([0 4])
box off

cd('Figures')
print('Fig_SI_6A','-depsc')
cd ..

% Run t-tests
    WH1  = acchss(WhSubs,[3 1 4]);
    WH2  = acchss(WhSubs,4+[3 1 4]);
    [hH1, pH1, CI1, stats1]   = ttest([ ...
        WH1(:,1)-WH1(:,2) WH1(:,1)-WH1(:,3) WH1(:,3)-WH1(:,2) ...
        WH2(:,1)-WH2(:,2) WH2(:,1)-WH2(:,3) WH2(:,3)-WH2(:,2) ...
        WH1(:,1)-WH2(:,1) WH1(:,2)-WH2(:,2) WH1(:,3)-WH2(:,3)]);
    ttests_table_fig_si_6a = [];
    ttests_table_fig_si_6a.comparison = {...
        'SZ4 baseline minus low-c'; 'SZ4 baseline minus high-v'; 'SZ4 high-v minus low-c' ;...
        'SZ8 baseline minus low-c'; 'SZ8 baseline minus high-v'; 'SZ8 high-v minus low-c' ;...
        'baseline minus baseline'; 'low-c minus low-c'; 'high-v minus high-v' };
    ttests_table_fig_si_6a.tstat = stats1.tstat';
    ttests_table_fig_si_6a.df = stats1.df';
    ttests_table_fig_si_6a.pvalue = pH1';
    ttests_table_fig_si_6a = struct2table(ttests_table_fig_si_6a);
    save('Stats/ttests_table_fig_si_6a.mat','ttests_table_fig_si_6a')
    

    [ranovatbl,rm,mauch_tbl,epsi_tbl] = RunRAnovaN_SSz(acchss(WhSubs,1:8));

%%  
load('model_noise_fits.mat')
wh_subs = 1:40;

fed_sets(:,1) = bestsets(1:60,1);
fed_sets(:,2) = 0;

fed_sets(:,3) = 1;
subsamp_accs = nan(60,8);
for i_numsamps = 1:8
    fed_sets(:,3) = i_numsamps;
    [subsampler_data] = GetChoices_subsampler_fixednoise(data,fed_sets(:,:));
    [acc_subsamp, ~, ~, ~]    = GetSummaryBehaviourMeasures_Exp123(subsampler_data);
    subsamp_accs(1:60,i_numsamps)   = acc_subsamp(1:60,6);
end



figure('name','Subsampling','color','none','units','centimeters','position',[1 1 .2*PprWidth .2*PprWidth])
plot(0,1,'w.')
box off
ylim([0.5 0.9])
xlim([0.5 8.5])
set(gca,'xtick',1:8,'xticklabel',1:8)
set(gca,'ytick',[0.5 0.9],'yticklabel',[0.5 0.9])
set(gca,'color','none')

cd('Figures')
print('Fig_SI_6B','-dsvg')
cd ..

figure('name','Subsampling','color','w','units','centimeters','position',[1 1 .2*PprWidth .2*PprWidth])
AreaPlot(1:8,repmat(acch(wh_subs,6),[1 8]),HumanColorLineGray);
AreaPlot(1:8,squeeze(subsamp_accs(wh_subs,:)),HumanColorLineRed);
ylim([0.5 0.9])
xlim([0.5 8.5])
set(gca,'xtick',1:8,'xticklabel','')
set(gca,'ytick',[0.5 0.9],'yticklabel','')

cd('Figures')
print('Fig_SI_6B','-dtiffn')
cd ..


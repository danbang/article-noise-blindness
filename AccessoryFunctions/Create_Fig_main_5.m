% load model data (continuous estimates of behaviour)
GetBehaviour_Models
load('data_human_noise_blindness_models_continuous.mat')

% Get MODEL summary choice measures for experiments 1,2 and 3
% omniscient model
[accmopt1, confmopt1, biasmopt1, optomopt1]         = GetSummaryBehaviourMeasures_Exp123(mdata_opt);
% variability-mixer model
[accmopt2, confmopt2, biasmopt2, optomopt2]         = GetSummaryBehaviourMeasures_Exp123(mdata_semi);
% noise blind model
[accmopt3, confmopt3, biasmopt3, optomopt3]         = GetSummaryBehaviourMeasures_Exp123(mdata_blate);


% load model data (discrete estimates of behaviour for regression)
load('data_human_noise_blindness_models.mat')

% Get regression coefficients for models
[betaschoiceM1, betasconfM1, betasconfunsignedM1, ~] = RunRegressionFull(mdata_opt);
[betaschoiceM2, betasconfM2, betasconfunsignedM2, ~] = RunRegressionFull(mdata_semi);
[betaschoiceM3, betasconfM3, betasconfunsignedM3, ~] = RunRegressionFull(mdata_blate);



%% Figure 5A
LnWidth = 2;

% enough variability in confidence
WhSubs1 = [find((ConfVarMatH(1:60)   >   1) ) ];
% enough variability in opt out but not excessive opt-out
WhSubs2 = [find((OptOutVarMatH(1:60) > 0.2) &  (OptOutMuMatH(1:60)<0.5) )];
WhSubsBoth = [WhSubs1; WhSubs2];
iSP =    [4 1 6]; % forced   / neutral
iSP2 = 6+[4 1 6]; % optional / biased
X1h  = [acch(WhSubs1,iSP); acch(WhSubs2,iSP)];
Y1h  = [confh(WhSubs1,iSP)./100; optoh(WhSubs2,iSP2)];
Xlims = [0.5 1];
Ylims = [0.5 1];
BFLineColH  = [0.2 0.4 0.9];
BFLineColM1 = [0.5 0.5 0.5];
BFLineColM2 = [0.4 0.9 0.4];
BFLineColM3 = [0.9 0.4 0.2];
figure('name','Calibrations Collapsing Conf and Opt Out','color','w','units','centimeters','position',[1 1 2.*PprWidth/3 2.*PprWidth/3])

% Start with Human data
subplot(4,3,1)
plot([.5 1],[.5 1],'k-','linewidth',1),hold on,
plot(X1h(:,1),Y1h(:,1),'ok','markerfacecolor',BFLineColH),hold on,
[B1h,STATS1h] = robustfit(X1h(:,1),Y1h(:,1));
[rho,pval] = corr(X1h(:,1),Y1h(:,1));
Bs = [B1h];
Ps = [STATS1h.p(2)]; LineTyp = {':' '-' };
WhLn = 1+(Ps<0.05);
plot([.5 1],Bs(1,1)+([.5 1]).*Bs(2,1),'color',BFLineColH,'linestyle',LineTyp{WhLn(1)},'linewidth',LnWidth)
box off
xlim(Xlims),ylim(Ylims)

subplot(4,3,2)
plot(Xlims,Ylims,'k-','linewidth',1),hold on,
plot(X1h(:,2),Y1h(:,2),'ok','markerfacecolor',BFLineColH),hold on,
[B2h,STATS2h] = robustfit(X1h(:,2),Y1h(:,2));
[rho,pval] = corr(X1h(:,2),Y1h(:,2));
Bs = [B2h];
Ps = [STATS2h.p(2)]; LineTyp = {':' '-' };
WhLn = 1+(Ps<0.05);
plot([.5 1],Bs(1,1)+([.5 1]).*Bs(2,1),'color',BFLineColH,'linestyle',LineTyp{WhLn(1)},'linewidth',LnWidth)
box off
xlim(Xlims),ylim(Ylims)

subplot(4,3,3)
plot(Xlims,Ylims,'k-','linewidth',1),hold on,
plot(X1h(:,3),Y1h(:,3),'ok','markerfacecolor',BFLineColH),hold on,
[B3h,STATS3h] = robustfit(X1h(:,3),Y1h(:,3));
[rho,pval] = corr(X1h(:,3),Y1h(:,3));
Bs = [B3h];
Ps = [STATS3h.p(2)]; LineTyp = {':' '-' };
WhLn = 1+(Ps<0.05);
plot([.5 1],Bs(1,1)+([.5 1]).*Bs(2,1),'color',BFLineColH,'linestyle',LineTyp{WhLn(1)},'linewidth',LnWidth)
box off
xlim(Xlims),ylim(Ylims)

% Now do Omniscient model
X1m1  = [ accmopt1(WhSubsBoth,iSP)];
Y1m1  = [confmopt1(WhSubsBoth,iSP)./100];

subplot(4,3,4)
plot(Xlims,Ylims,'k-','linewidth',1),hold on,
plot(X1m1(:,1),Y1m1(:,1),'ok','markerfacecolor',BFLineColM1),hold on,
[B1m1,STATS1m1] = robustfit(X1m1(:,1),Y1m1(:,1));
Bs = [B1m1];
Ps = [STATS1m1.p(2)]; LineTyp = {':' '-' };
WhLn = 1+(Ps<0.05);
plot([.5 1],Bs(1,1)+([.5 1]).*Bs(2,1),'color',BFLineColM1,'linestyle',LineTyp{WhLn(1)},'linewidth',LnWidth)
box off
xlim(Xlims),ylim(Ylims)

subplot(4,3,5)
plot(Xlims,Ylims,'k-','linewidth',1),hold on,
plot(X1m1(:,2),Y1m1(:,2),'ok','markerfacecolor',BFLineColM1),hold on,
[B2m1,STATS2m1] = robustfit(X1m1(:,2),Y1m1(:,2));
Bs = [B2m1];
Ps = [STATS2m1.p(2)]; LineTyp = {':' '-' };
WhLn = 1+(Ps<0.05);
plot([.5 1],Bs(1,1)+([.5 1]).*Bs(2,1),'color',BFLineColM1,'linestyle',LineTyp{WhLn(1)},'linewidth',LnWidth)
box off
xlim(Xlims),ylim(Ylims)

subplot(4,3,6)
plot(Xlims,Ylims,'k-','linewidth',1),hold on,
plot(X1m1(:,3),Y1m1(:,3),'ok','markerfacecolor',BFLineColM1),hold on,
[B3m1,STATS3m1] = robustfit(X1m1(:,3),Y1m1(:,3));
Bs = [B3m1];
Ps = [STATS3m1.p(2)]; LineTyp = {':' '-' };
WhLn = 1+(Ps<0.05);
plot([.5 1],Bs(1,1)+([.5 1]).*Bs(2,1),'color',BFLineColM1,'linestyle',LineTyp{WhLn(1)},'linewidth',LnWidth)
box off
xlim(Xlims),ylim(Ylims)

% Now do Noise Blind model
X1m3  = [accmopt3(WhSubsBoth,iSP)];
Y1m3  = [confmopt3(WhSubsBoth,iSP)./100;];

subplot(4,3,7)
plot(Xlims,Ylims,'k-','linewidth',1),hold on,
plot(X1m3(:,1),Y1m3(:,1),'ok','markerfacecolor',BFLineColM3),hold on,
[B1m3,STATS1m3] = robustfit(X1m3(:,1),Y1m3(:,1));
Bs = [B1m3];
Ps = [STATS1m3.p(2)]; LineTyp = {':' '-' };
WhLn = 1+(Ps<0.05);
plot([.5 1],Bs(1,1)+([.5 1]).*Bs(2,1),'color',BFLineColM3,'linestyle',LineTyp{WhLn(1)},'linewidth',LnWidth)
box off
xlim(Xlims),ylim(Ylims)

subplot(4,3,8)
plot(Xlims,Ylims,'k-','linewidth',1),hold on,
plot(X1m3(:,2),Y1m3(:,2),'ok','markerfacecolor',BFLineColM3),hold on,
[B2m3,STATS2m3] = robustfit(X1m3(:,2),Y1m3(:,2));
Bs = [B2m3];
Ps = [STATS2m3.p(2)]; LineTyp = {':' '-' };
WhLn = 1+(Ps<0.05);
plot([.5 1],Bs(1,1)+([.5 1]).*Bs(2,1),'color',BFLineColM3,'linestyle',LineTyp{WhLn(1)},'linewidth',LnWidth)
box off
xlim(Xlims),ylim(Ylims)

subplot(4,3,9)
plot(Xlims,Ylims,'k-','linewidth',1),hold on,
plot(X1m3(:,3),Y1m3(:,3),'ok','markerfacecolor',BFLineColM3),hold on,
[B3m3,STATS3m3] = robustfit(X1m3(:,3),Y1m3(:,3));
Bs = [B3m3];
Ps = [STATS3m3.p(2)]; LineTyp = {':' '-' };
WhLn = 1+(Ps<0.05);
plot([.5 1],Bs(1,1)+([.5 1]).*Bs(2,1),'color',BFLineColM3,'linestyle',LineTyp{WhLn(1)},'linewidth',LnWidth)
box off
xlim(Xlims),ylim(Ylims)

% Now do Variability-Mixer model
X1m2  = [accmopt2(WhSubsBoth,iSP)];
Y1m2  = [confmopt2(WhSubsBoth,iSP)./100];

subplot(4,3,10)
plot(Xlims,Ylims,'k-','linewidth',1),hold on,
plot(X1m2(:,1),Y1m2(:,1),'ok','markerfacecolor',BFLineColM2),hold on,
[B1m2,STATS1m2] = robustfit(X1m2(:,1),Y1m2(:,1));
Bs = [B1m2];
Ps = [STATS1m2.p(2)]; LineTyp = {':' '-' };
WhLn = 1+(Ps<0.05);
plot([.5 1],Bs(1,1)+([.5 1]).*Bs(2,1),'color',BFLineColM2,'linestyle',LineTyp{WhLn(1)},'linewidth',LnWidth)
box off
xlim(Xlims),ylim(Ylims)

subplot(4,3,11)
plot(Xlims,Ylims,'k-','linewidth',1),hold on,
plot(X1m2(:,2),Y1m2(:,2),'ok','markerfacecolor',BFLineColM2),hold on,
[B2m2,STATS2m2] = robustfit(X1m2(:,2),Y1m2(:,2));
Bs = [B2m2];
Ps = [STATS2m2.p(2)]; LineTyp = {':' '-' };
WhLn = 1+(Ps<0.05);
plot([.5 1],Bs(1,1)+([.5 1]).*Bs(2,1),'color',BFLineColM2,'linestyle',LineTyp{WhLn(1)},'linewidth',LnWidth)
box off
xlim(Xlims),ylim(Ylims)

subplot(4,3,12)
plot(Xlims,Ylims,'k-','linewidth',1),hold on,
plot(X1m2(:,3),Y1m2(:,3),'ok','markerfacecolor',BFLineColM2),hold on,
[B3m2,STATS3m2] = robustfit(X1m2(:,3),Y1m2(:,3));
Bs = [B3m2];
Ps = [STATS3m2.p(2)]; LineTyp = {':' '-' };
WhLn = 1+(Ps<0.05);
plot([.5 1],Bs(1,1)+([.5 1]).*Bs(2,1),'color',BFLineColM2,'linestyle',LineTyp{WhLn(1)},'linewidth',LnWidth)
box off
xlim(Xlims),ylim(Ylims)

cd('Figures')
print('Fig_main_5A','-depsc')
cd ..

robustfit_table_human_and_models_fig_5a = [];
robustfit_table_human_and_models_fig_5a.datasource = {...
    'Human'; 'Human'; 'Human'; ...
    'Omniscient'; 'Omniscient'; 'Omniscient'; ...
    'Noise Blind'; 'Noise Blind'; 'Noise Blind'; ...
    'Variability-Mixer'; 'Variability-Mixer'; 'Variability-Mixer'};
robustfit_table_human_and_models_fig_5a.condition = {...
    'baseline'; 'low contrast'; 'high variability';...
    'baseline'; 'low contrast'; 'high variability'; ...
    'baseline'; 'low contrast'; 'high variability'; ...
    'baseline'; 'low contrast'; 'high variability';};
robustfit_table_human_and_models_fig_5a.beta_coeffs = [B1h';B2h';B3h'; B1m1';B2m1';B3m1'; B1m3';B2m3';B3m3'; B1m2';B2m2';B3m2'];
robustfit_table_human_and_models_fig_5a.pvalues = [...
    STATS1h.p' ; STATS2h.p' ; STATS3h.p' ;...
    STATS1m1.p'; STATS2m1.p'; STATS3m1.p';...
    STATS1m3.p'; STATS2m3.p'; STATS3m3.p';...
    STATS1m2.p'; STATS2m2.p'; STATS3m2.p'];
robustfit_table_human_and_models_fig_5a = struct2table(robustfit_table_human_and_models_fig_5a);
save('Stats/robustfit_table_human_and_models_fig_5a.mat','robustfit_table_human_and_models_fig_5a')



%% Figure 5B (Created already)

%% Figure 5C

mmubias1Exp12 = nanmean(biasmopt1(WhichSubsExp12,:));
mmubias2Exp12 = nanmean(biasmopt2(WhichSubsExp12,:));
mmubias3Exp12 = nanmean(biasmopt3(WhichSubsExp12,:));

msebias1Exp12 = nanstd(biasmopt1(WhichSubsExp12,:))      ./ (sqrt(sum(~isnan(biasmopt1(WhichSubsExp12,:)))-1));
msebias2Exp12 = nanstd(biasmopt2(WhichSubsExp12,:))      ./ (sqrt(sum(~isnan(biasmopt2(WhichSubsExp12,:)))-1));
msebias3Exp12 = nanstd(biasmopt3(WhichSubsExp12,:))      ./ (sqrt(sum(~isnan(biasmopt3(WhichSubsExp12,:)))-1));

figure('name','Bias Indices Models','color','w','units','centimeters','position',[1 1 PprWidth/3.5 PprWidth/8])
subplot(1,3,1)
yLims = [0.5 2.5];
H1 = plot(1:3,[mmubias1Exp12(1,6+(1:3))],'color',[0.8 0.8 0.8],'linewidth',5,'linestyle','-');hold on,
errorbar(1:3, [mmubias1Exp12(1,6+(1:3))],[msebias1Exp12(1,6+(1:3))],'.','color','k','markerfacecolor','k','markeredgecolor','k');
H2 = plot(1:3,[mmubias1Exp12(1,6+(4:6))],'color',[0.4 0.4 0.4],'linewidth',5,'linestyle','-');hold on,
errorbar(1:3, [mmubias1Exp12(1,6+(4:6))],[msebias1Exp12(1,6+(4:6))],'.','color','k','markerfacecolor','k','markeredgecolor','k');
box off
set(gca,'ytick',[yLims(1) 2.5],'xtick',[1 2 3],'xticklabel',[])
xlim([0.5 3.5])
ylim(yLims)
subplot(1,3,2)
H1 = plot(1:3,[mmubias3Exp12(1,6+(1:3))],'color',[1 .6 .3],'linewidth',5,'linestyle','-');hold on,
errorbar(1:3, [mmubias3Exp12(1,6+(1:3))],[msebias3Exp12(1,6+(1:3))],'.','color','k','markerfacecolor','k','markeredgecolor','k');
H2 = plot(1:3,[mmubias3Exp12(1,6+(4:6))],'color',[.7 .2 0],'linewidth',5,'linestyle','-');hold on,
errorbar(1:3, [mmubias3Exp12(1,6+(4:6))],[msebias3Exp12(1,6+(4:6))],'.','color','k','markerfacecolor','k','markeredgecolor','k');
box off
set(gca,'ytick',[yLims(1) 2.5],'yticklabel','','xtick',[1 2 3],'xticklabel',[])
xlim([0.5 3.5])
ylim(yLims)
subplot(1,3,3)
H1 = plot(1:3,[mmubias2Exp12(1,6+(1:3))],'color',[.6 1 .3],'linewidth',5,'linestyle','-');hold on,
errorbar(1:3, [mmubias2Exp12(1,6+(1:3))],[msebias2Exp12(1,6+(1:3))],'.','color','k','markerfacecolor','k','markeredgecolor','k');
H2 = plot(1:3,[mmubias2Exp12(1,6+(4:6))],'color',[.2 .7 0],'linewidth',5,'linestyle','-');hold on,
errorbar(1:3, [mmubias2Exp12(1,6+(4:6))],[msebias2Exp12(1,6+(4:6))],'.','color','k','markerfacecolor','k','markeredgecolor','k');
box off
set(gca,'ytick',[yLims(1) 2.5],'yticklabel','','xtick',[1 2 3],'xticklabel',[])
xlim([0.5 3.5])
ylim(yLims)

cd('Figures')
print('Fig_main_5C','-depsc')
cd ..

%% Figure 5 D

figure('name','Regression Signed Confidence','color','w','units','centimeters','position',[1 1 PprWidth/3.5 PprWidth/5])
WhSubs = 21:40; % 61:81
NumReg = 7;
LnWdth = 3;
bar(2:NumReg,nanmean(betasconfH(WhSubs,2:NumReg)),'facecolor',[0.2 0.4 0.9]); hold on,
plot((2:NumReg),nanmean(betasconfM1(WhSubs,2:NumReg)),'o','color',[0.3 0.3 0.3],'markerfacecolor',[0.5 0.5 0.5],'markersize',LnWdth,'linewidth',LnWdth); hold on,
plot((2:NumReg),nanmean(betasconfM2(WhSubs,2:NumReg)),'o','color',[0.4 0.9 0.1],'markerfacecolor',[0.4 0.9 0.1],'markersize',LnWdth,'linewidth',LnWdth); hold on,
plot(2:NumReg,nanmean(betasconfM3(WhSubs,2:NumReg)),'o','color',[0.9 0.4 0.1],'markerfacecolor',[0.9 0.1 0.1],'markersize',LnWdth,'linewidth',LnWdth); hold on,
errorbar(2:NumReg,nanmean(betasconfH(WhSubs,2:NumReg)),nanstd(betasconfH(WhSubs,2:NumReg))./sqrt(numel(WhSubs)),'.','color','k','markerfacecolor','k','markeredgecolor','k');
box off
set(gca,'xtick',[2:NumReg],'xticklabel',{''},'ytick',[-0.2 0 0.5]);%,{ 'mu' 'cue' 'mu*rmc' 'mu*sigma' 'cue*rmc' 'cue*sigma'})
xlim([1 NumReg+1])
ylim([-0.2 0.5])

cd('Figures')
print('Fig_main_5D','-depsc')
cd ..


% t-tests
%human
[hH, pH1, CI, stats1] = ttest(betasconfH(WhSubs,1:NumReg));
ttests_table_human_fig_5d = [];
ttests_table_human_fig_5d.predictor = {'Intercept'; 'average orientation'; 'cue' ;'orientation*contrast';'orientation*variability';'cue*contrast';'cue*variability'};
ttests_table_human_fig_5d.tstat = stats1.tstat';
ttests_table_human_fig_5d.df = stats1.df';
ttests_table_human_fig_5d.pvalue = pH1';
ttests_table_human_fig_5d = struct2table(ttests_table_human_fig_5d);
% omniscient
[hH, pH1, CI, stats1] = ttest(betasconfM1(WhSubs,1:NumReg));
ttests_table_omniscient_fig_2e = [];
ttests_table_omniscient_fig_2e.predictor = {'Intercept'; 'average orientation'; 'cue' ;'orientation*contrast';'orientation*variability';'cue*contrast';'cue*variability'};
ttests_table_omniscient_fig_2e.tstat = stats1.tstat';
ttests_table_omniscient_fig_2e.df = stats1.df';
ttests_table_omniscient_fig_2e.pvalue = pH1';
ttests_table_omniscient_fig_2e = struct2table(ttests_table_omniscient_fig_2e);
% variability mixer
[hH, pH1, CI, stats1] = ttest(betasconfM2(WhSubs,1:NumReg));
ttests_table_mixer_fig_5d = [];
ttests_table_mixer_fig_5d.predictor = {'Intercept'; 'average orientation'; 'cue' ;'orientation*contrast';'orientation*variability';'cue*contrast';'cue*variability'};
ttests_table_mixer_fig_5d.tstat = stats1.tstat';
ttests_table_mixer_fig_5d.df = stats1.df';
ttests_table_mixer_fig_5d.pvalue = pH1';
ttests_table_mixer_fig_5d = struct2table(ttests_table_mixer_fig_5d);
% noise blind
[hH, pH1, CI, stats1] = ttest(betasconfM3(WhSubs,1:NumReg));
ttests_table_blind_fig_5d = [];
ttests_table_blind_fig_5d.predictor = {'Intercept'; 'average orientation'; 'cue' ;'orientation*contrast';'orientation*variability';'cue*contrast';'cue*variability'};
ttests_table_blind_fig_5d.tstat = stats1.tstat';
ttests_table_blind_fig_5d.df = stats1.df';
ttests_table_blind_fig_5d.pvalue = pH1';
ttests_table_blind_fig_5d = struct2table(ttests_table_blind_fig_5d);

save('Stats/ttests_table_fig_5d.mat','ttests_table_human_fig_5d','ttests_table_omniscient_fig_2e','ttests_table_mixer_fig_5d','ttests_table_blind_fig_5d')

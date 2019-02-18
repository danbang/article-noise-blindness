
    %% Figure 2A
    yLims1 = [0.5 1];
    WhSubs12 = 1:40; 
    figure('name','Accuracies Collapsed Exp 1 and 2','color','w','units','centimeters','position',[1 1 .25*PprWidth PprWidth/4])
    iSP = [4 1 6];
    
    BarPlotJitter(1:3,acch(WhSubs12,iSP),HumanColorBars);
    box off
    ylim(yLims1)
    set(gca,'ytick',[0.5 1],'xtick',[1:3],'xticklabel',[])
    cd('Figures')
    print('Fig_main_2A','-depsc')
    cd ..
    % Run t-tests
    WhSubs1 = 1:20;
    WhSubs2 = 21:40; 

    WH1   = acch(WhSubs1,iSP);
    WH2   = acch(WhSubs2,iSP);
    WH12  = acch(WhSubs12,iSP);
    [hH1, pH1, CI1, stats1]   = ttest([ ...
        WH1(:,1)-WH1(:,2) WH1(:,1)-WH1(:,3) WH1(:,3)-WH1(:,2) ...
        WH2(:,1)-WH2(:,2) WH2(:,1)-WH2(:,3) WH2(:,3)-WH2(:,2) ]);
    [hH2, pH2, CI2, stats2]   = ttest([ WH12(:,1)-WH12(:,2) WH12(:,1)-WH12(:,3) WH12(:,3)-WH12(:,2) ]);
    ttests_table_fig_2a = [];
    ttests_table_fig_2a.comparison = {...
        'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c' ; ...
        'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c' ; ...
        'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c' };
     ttests_table_fig_2a.experiment = {...
        'Exp 1'; 'Exp 1'; 'Exp 1' ; ...
        'Exp 2'; 'Exp 2'; 'Exp 2' ; ...
        'Exp 12'; 'Exp 12'; 'Exp 12' };
    ttests_table_fig_2a.tstat = [stats1.tstat' ; stats2.tstat'];
    ttests_table_fig_2a.df = [stats1.df' ; stats2.df'];
    ttests_table_fig_2a.pvalue = [pH1' ; pH2'];
    ttests_table_fig_2a = struct2table(ttests_table_fig_2a);
    save('Stats/ttests_table_fig_2a.mat','ttests_table_fig_2a')
    
    % Run anova
    SaveAnovaTables_accuracies_human(acch)

     %% Figure 2B
    WhSubs = 1:40;
    MrkrSz = 25;
    figure('name','Psychometrics','color','w','units','centimeters','position',[1 1 .75*PprWidth PprWidth/4])

    subplot(1,3,1),
    iC = 2; iV = 1;
    Mat1 = squeeze(nanmean(PsychoMatH(WhSubs,:,iC,iV,1)));
    Mat2 = squeeze(nanmean(PsychoMatH(WhSubs,:,iC,iV,2)));
    Mat3 = squeeze(nanmean(PsychoMatH(WhSubs,:,iC,iV,3)));
    
    [Curv1 ,Coeff1 ,~ ,~ ] = Get_Psychometric_Boltzmann(1:numel(Mat1),Mat1,[]);
    [Curv2 ,Coeff2 ,~ ,~ ] = Get_Psychometric_Boltzmann(1:numel(Mat2),Mat2,[]);
    [Curv3 ,Coeff3 ,~ ,~ ] = Get_Psychometric_Boltzmann(1:numel(Mat3),Mat3,[]);
    
    plot([Coeff1(4) Coeff1(4)],[0 Curv1(Coeff1(4))],'b','linewidth',2)
    hold on,
    plot([Coeff2(4) Coeff2(4)],[0 Curv2(Coeff2(4))],'k','linewidth',2)
    plot([Coeff3(4) Coeff3(4)],[0 Curv3(Coeff3(4))],'r','linewidth',2)
    plot(Mat1,'b.','markersize',MrkrSz,'markerfacecolor','b'),
    plot(Mat2,'k.','markersize',MrkrSz,'markerfacecolor','k'),
    plot(Mat3,'r.','markersize',MrkrSz,'markerfacecolor','r'),
    plot(1:0.01:numel(Mat1),Curv1(1:0.01:numel(Mat1)),'b','linewidth',2)
    plot(1:0.01:numel(Mat1),Curv2(1:0.01:numel(Mat1)),'k','linewidth',2)
    plot(1:0.01:numel(Mat1),Curv3(1:0.01:numel(Mat1)),'r','linewidth',2)
    box off
    set(gca,'ytick',[0 1],'xtick',[1 (1+numel(Mat1))./2 numel(Mat1)],'xticklabel',[],'tickdir','out')
    xlim([0.5 numel(Mat1)+.5])
    
    subplot(1,3,2),
    iC = 1; iV = 1;
    Mat1 = squeeze(nanmean(PsychoMatH(WhSubs,:,iC,iV,1)));
    Mat2 = squeeze(nanmean(PsychoMatH(WhSubs,:,iC,iV,2)));
    Mat3 = squeeze(nanmean(PsychoMatH(WhSubs,:,iC,iV,3)));
    
    [Curv1 ,Coeff1 ,~ ,~ ] = Get_Psychometric_Boltzmann(1:numel(Mat1),Mat1,[]);
    [Curv2 ,Coeff2 ,~ ,~ ] = Get_Psychometric_Boltzmann(1:numel(Mat2),Mat2,[]);
    [Curv3 ,Coeff3 ,~ ,~ ] = Get_Psychometric_Boltzmann(1:numel(Mat3),Mat3,[]);
    
    plot([Coeff1(4) Coeff1(4)],[0 Curv1(Coeff1(4))],'b','linewidth',2)
    hold on,
    plot([Coeff2(4) Coeff2(4)],[0 Curv2(Coeff2(4))],'k','linewidth',2)
    plot([Coeff3(4) Coeff3(4)],[0 Curv3(Coeff3(4))],'r','linewidth',2)
    plot(Mat1,'b.','markersize',MrkrSz,'markerfacecolor','b'),
    plot(Mat2,'k.','markersize',MrkrSz,'markerfacecolor','k'),
    plot(Mat3,'r.','markersize',MrkrSz,'markerfacecolor','r'),
    plot(1:0.01:numel(Mat1),Curv1(1:0.01:numel(Mat1)),'b','linewidth',2)
    plot(1:0.01:numel(Mat1),Curv2(1:0.01:numel(Mat1)),'k','linewidth',2)
    plot(1:0.01:numel(Mat1),Curv3(1:0.01:numel(Mat1)),'r','linewidth',2)
    box off
    set(gca,'ytick',[0 1],'xtick',[1 (1+numel(Mat1))./2 numel(Mat1)],'xticklabel',[],'tickdir','out')
    xlim([0.5 numel(Mat1)+.5])
    
    subplot(1,3,3),
    iC = 2; iV = 3;
    Mat1 = squeeze(nanmean(PsychoMatH(WhSubs,:,iC,iV,1)));
    Mat2 = squeeze(nanmean(PsychoMatH(WhSubs,:,iC,iV,2)));
    Mat3 = squeeze(nanmean(PsychoMatH(WhSubs,:,iC,iV,3)));
    
    [Curv1 ,Coeff1 ,~ ,~ ] = Get_Psychometric_Boltzmann(1:numel(Mat1),Mat1,[]);
    [Curv2 ,Coeff2 ,~ ,~ ] = Get_Psychometric_Boltzmann(1:numel(Mat2),Mat2,[]);
    [Curv3 ,Coeff3 ,~ ,~ ] = Get_Psychometric_Boltzmann(1:numel(Mat3),Mat3,[]);
    
    plot([Coeff1(4) Coeff1(4)],[0 Curv1(Coeff1(4))],'b','linewidth',2)
    hold on,
    plot([Coeff2(4) Coeff2(4)],[0 Curv2(Coeff2(4))],'k','linewidth',2)
    plot([Coeff3(4) Coeff3(4)],[0 Curv3(Coeff3(4))],'r','linewidth',2)
    plot(Mat1,'b.','markersize',MrkrSz,'markerfacecolor','b'),
    plot(Mat2,'k.','markersize',MrkrSz,'markerfacecolor','k'),
    plot(Mat3,'r.','markersize',MrkrSz,'markerfacecolor','r'),
    plot(1:0.01:numel(Mat1),Curv1(1:0.01:numel(Mat1)),'b','linewidth',2)
    plot(1:0.01:numel(Mat1),Curv2(1:0.01:numel(Mat1)),'k','linewidth',2)
    plot(1:0.01:numel(Mat1),Curv3(1:0.01:numel(Mat1)),'r','linewidth',2)
    box off
    set(gca,'ytick',[0 1],'xtick',[1 (1+numel(Mat1))./2 numel(Mat1)],'xticklabel',[],'tickdir','out')
    xlim([0.5 numel(Mat1)+.5])
    
    cd('Figures')
    print('Fig_main_2B','-depsc')
    cd ..
    
    %% Fgure 2C
    yLims1 = [0 2.5];
    WhSubs12 = 1:40; 
    figure('name','Bias Indices Collapsed1and2','color','w','units','centimeters','position',[1 1 .25*PprWidth PprWidth/4])
    iSP2 = 6+ [4 1 6];
    BarPlotJitter(1:3,biash(WhSubs12,iSP2),HumanColorBars);
    %bar(1:3,nanmean(-biash(WhSubs1,iSP2)),'facecolor',[0.2 0.4 0.9]); hold on
    %errorbar(1:3,nanmean(-biash(WhSubs1,iSP2)),nanstd(-biash(WhSubs1,iSP2))./sqrt(numel(WhSubs1)),'.','color','k','markerfacecolor','k','markeredgecolor','k');
    box off
    ylim(yLims1)
    set(gca,'ytick',[yLims1],'xtick',[1:3],'xticklabel',[])
    WH1  = biash(WhSubs12,iSP2);
    
    [hH1, pH1, CI1, stats1]   = ttest([ WH1(:,1)-WH1(:,2) WH1(:,1)-WH1(:,3) WH1(:,3)-WH1(:,2) ]);
    
    ttests_table_fig_2c = [];
    ttests_table_fig_2c.comparison = {'baseline minus low-c'; 'baseline minus high-v'; 'high-v minus low-c'};
    ttests_table_fig_2c.tstat = stats1.tstat';
    ttests_table_fig_2c.df = stats1.df';
    ttests_table_fig_2c.pvalue = pH1';
    ttests_table_fig_2c = struct2table(ttests_table_fig_2c);
    save('Stats/ttests_table_fig_2c.mat','ttests_table_fig_2c')
    
    cd('Figures')
    print('Fig_main_2C','-depsc')
    cd ..
    
    % Run anova
    SaveAnovaTables_biasindices_human(biash)
    
        
    %% Figure 2D
    PprWidth= 21*.9;
    figure('name','Bias Indices','color','w','units','centimeters','position',[1 1 .25*PprWidth PprWidth/4])
    yLims = [0.5 2];
   
    LinePlot(1:3,biash(WhSubs12,6+(1:3)),HumanColorLight);
    LinePlot(1:3,biash(WhSubs12,6+(4:6)),HumanColorDark);
    box off
    set(gca,'ytick',[yLims(1) 2],'xtick',[1 2 3],'xticklabel',[])
    xlim([0.5 3.5])
    ylim(yLims)
    
    cd('Figures')
    print('Fig_main_2D','-depsc')
    cd ..

    %% Figure 2E
    PprWidth= 21*.9;
    figure('name','Regression Human Choice','color','w','units','centimeters','position',[1 1 .4*PprWidth PprWidth/4])
    WhSubs = 1:40;
    NumReg = 7;
    bar(2:NumReg,nanmean(betaschoiceH(WhSubs,2:NumReg)),'facecolor',HumanColorBars); hold on,
    errorbar(2:NumReg,nanmean(betaschoiceH(WhSubs,2:NumReg)),nanstd(betaschoiceH(WhSubs,2:NumReg))./sqrt(numel(WhSubs)-1),'.','color','k','markerfacecolor','k','markeredgecolor','k');
    box off
    set(gca,'xtick',[2:NumReg],'xticklabel',{},'ytick',[-.2 0 0.9])
    xlim([1 NumReg+1])
    ylim([-.3 0.9])
    
    cd('Figures')
    print('Fig_main_2E','-depsc')
    cd ..
    
    [h pH1 CI stats1] = ttest(betaschoiceH(WhSubs,1:NumReg));
    ttests_table_fig_2e = [];
    ttests_table_fig_2e.predictor = {'Intercept'; 'average orientation'; 'cue' ;'orientation*contrast';'orientation*variability';'cue*contrast';'cue*variability'};
    ttests_table_fig_2e.tstat = stats1.tstat';
    ttests_table_fig_2e.df = stats1.df';
    ttests_table_fig_2e.pvalue = pH1';
    ttests_table_fig_2e = struct2table(ttests_table_fig_2e);
    save('Stats/ttests_table_fig_2e.mat','ttests_table_fig_2e')
   
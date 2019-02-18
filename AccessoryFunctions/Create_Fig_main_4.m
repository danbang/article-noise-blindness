AddPanelNames = 0;
    condition_noise = 8/45;
    reduced_noise   = 2/45;
    
    genmu           = 3/45;
    genstd          = 8/45;
    xres            = 1000;
    xspace          = linspace(-1,1,xres);
    truelikes       = (normpdf(xspace,genmu,genstd) + normpdf(xspace,-genmu,genstd)).*(xspace>0);
    Xs = -4/45 +[0.2212    0.0178    0.0822   -0.1300    0.0479    0.1622   -0.0371   -0.0921];
    MuX = mean(Xs);
    MuXindxCW  = find(abs(xspace - MuX) == min(abs(xspace - MuX)));
    MuXindxCCW = find(abs(xspace - (-MuX)) == min(abs(xspace - (-MuX))));
    
    PprWidth= 21*.9;
    figure('name','Model Explanation','color','w','units','centimeters','position',[1 1 2/3*PprWidth 1/2*PprWidth])
    
    subplot(3,2,1)
    hrCW   = area(xspace,truelikes ,'facecolor',[0.2 0.2 0.8],'facealpha',0.7);hold on,
    hrCCW  = area(xspace,fliplr(truelikes) ,'facecolor',[0.8 0.2 0.2],'facealpha',0.7);
    hrCCWl  = plot(xspace,truelikes ,'color',[0 0 0]);
    hrCCWl  = plot(xspace,fliplr(truelikes) ,'color',[0 0 0]);

    
    XLims = 1;
    xlim([-XLims XLims])
    set(gca,'xtick',[-XLims 0 XLims],'xticklabel',{'CCW' '0' 'CW'})

    set(gca,'ycolor','none'),
    box off
    if AddPanelNames,SetPanelName('A'),end
    
    subplot(3,2,3)
    Mrk_sz = 3;
    sub_likes       = conv2(truelikes,normpdf(xspace,0,condition_noise),'same');
    hrCW   = area(xspace,sub_likes ,'facecolor',[0.2 0.2 0.8],'facealpha',0.5);hold on,
    hrCCW  = area(xspace,fliplr(sub_likes) ,'facecolor',[0.8 0.2 0.2],'facealpha',0.5);
    hrCCWl  = plot(xspace,sub_likes ,'color',[0 0 0]);
    hrCCWl  = plot(xspace,fliplr(sub_likes) ,'color',[0 0 0]);
    plot(xspace(MuXindxCW),0,'o','color','w','markerfacecolor','w','markersize',Mrk_sz)
    plot(xspace(MuXindxCW),sub_likes(MuXindxCW),'o','color',[0.2 0.2 0.8],'markerfacecolor',[0.2 0.2 0.8],'markersize',Mrk_sz)
    plot(xspace(MuXindxCW),fliplr(sub_likes(MuXindxCCW)),'o','color',[0.8 0.2 0.2],'markerfacecolor',[0.8 0.2 0.2],'markersize',Mrk_sz)

    XLims = 1;
    xlim([-XLims XLims])
    set(gca,'xtick',[-XLims 0 XLims],'xticklabel',{'CCW' '0' 'CW'})
    set(gca,'ycolor','none'),
    box off
    if AddPanelNames,SetPanelName('C'),end
    
    subplot(3,2,5)
    Mrk_sz = 3;
    sub_likes_reduced  = conv2(truelikes,normpdf(xspace,0,reduced_noise),'same');
    hrCW   = area(xspace,sub_likes_reduced ,'facecolor',[0.2 0.2 0.8],'facealpha',0.5);hold on,
    hrCCW  = area(xspace,fliplr(sub_likes_reduced) ,'facecolor',[0.8 0.2 0.2],'facealpha',0.5);
    hrCCWl  = plot(xspace,sub_likes_reduced ,'color',[0 0 0]);
    hrCCWl  = plot(xspace,fliplr(sub_likes_reduced) ,'color',[0 0 0]);
    plot(xspace(MuXindxCW),0,'o','color','w','markerfacecolor','w','markersize',Mrk_sz)
    plot(xspace(MuXindxCW),sub_likes_reduced(MuXindxCW),'o','color',[0.2 0.2 0.8],'markerfacecolor',[0.2 0.2 0.8],'markersize',Mrk_sz)
    plot(xspace(MuXindxCW),fliplr(sub_likes_reduced(MuXindxCCW)),'o','color',[0.8 0.2 0.2],'markerfacecolor',[0.8 0.2 0.2],'markersize',Mrk_sz)

    XLims = 1;
    xlim([-XLims XLims])
    set(gca,'xtick',[-XLims 0 XLims],'xticklabel',{'CCW' '0' 'CW'})
    set(gca,'ycolor','none'),
    box off
    if AddPanelNames,SetPanelName('E'),end
    
    subplot(3,2,6)
    belief_cwn       = sub_likes./(sub_likes+fliplr(sub_likes));
    belief_cwb       = (sub_likes.*3)./((sub_likes.*3)+fliplr(sub_likes));
    belief_cwbln   = sub_likes_reduced./(sub_likes_reduced+fliplr(sub_likes_reduced));
    belief_cwblb   = (sub_likes_reduced.*3)./((sub_likes_reduced.*3)+fliplr(sub_likes_reduced));
    hrCWblind = plot(xspace,belief_cwbln ,'color',[.7 .7 .7],'linewidth',4); hold on,
    hrCWb     = plot(xspace,belief_cwb ,'color',[0.4 0.4 0.4],'linewidth',4,'linestyle','-');
    hrCWn     = plot(xspace,belief_cwn ,'color',[0 0 0],'linewidth',4);hold on,

    
    line([ -1; xspace(MuXindxCW)]',[belief_cwn(MuXindxCW); belief_cwn(MuXindxCW)]','color',[0 0 0],'linewidth',3,'linestyle',':')
    line([ -1; xspace(MuXindxCW)]',[belief_cwbln(MuXindxCW); belief_cwbln(MuXindxCW)]','color',[0.7 0.7 0.7],'linewidth',3,'linestyle',':')
    maxbelief = max([belief_cwbln(MuXindxCW) belief_cwb(MuXindxCW) belief_cwn(MuXindxCW)]);
    line([ xspace(MuXindxCW); xspace(MuXindxCW)]',[ 0 ; maxbelief]','color',[1 1 1],'linewidth',2,'linestyle','-')
    line([ xspace(MuXindxCW); xspace(MuXindxCW)]',[ 0 ; maxbelief]','color',[0 0 0],'linewidth',2,'linestyle',':')
    line([ -1; xspace(MuXindxCW)]',[ belief_cwb(MuXindxCW) ; belief_cwb(MuXindxCW)]','color',[0.4 0.4 0.4],'linewidth',3,'linestyle',':')
    
    XLims = 1;
    xlim([-XLims XLims])
    set(gca,'xtick',[-XLims 0 XLims],'xticklabel',{'CCW' '0' 'CW'})
    set(gca,'ytick',[0 0.5 1],'yticklabel',{'0' '50' '100'}),
    box off
    if AddPanelNames,SetPanelName('F'),end

    
    subplot(3,2,2)
    NoisePDF = normpdf(xspace,MuX,condition_noise./2);
    hrN    = area(xspace, NoisePDF./(max(NoisePDF).*1.2) ,'facecolor',[0.9 0.9 0.9],'facealpha',0.7); hold on,
    line([Xs; Xs],[zeros(size(Xs)) ; .1.*ones(size(Xs))],'color','k','linewidth',2)
    xlim([-1 1])
    ylim([0 1])

    
    XLims = 1;
    xlim([-XLims XLims])
    set(gca,'xtick',[-XLims 0 XLims],'xticklabel',{'CCW' '0' 'CW'})
    set(gca,'ycolor','none'),
    box off
    if AddPanelNames,SetPanelName('B'),end
    
    subplot(3,2,4)
    sub_likes       = conv2(truelikes,normpdf(xspace,0,condition_noise),'same');
    hrCW   = area(xspace,sub_likes.*3 ,'facecolor',[0.2 0.2 0.8],'facealpha',0.5);hold on,
    hrCCW  = area(xspace,fliplr(sub_likes) ,'facecolor',[0.8 0.2 0.2],'facealpha',0.5);
    hrCCWl  = plot(xspace,sub_likes.*3 ,'color',[0 0 0]);
    hrCCWl  = plot(xspace,fliplr(sub_likes) ,'color',[0 0 0]);
    plot(xspace(MuXindxCW),0,'o','color','w','markerfacecolor','w','markersize',Mrk_sz)
    plot(xspace(MuXindxCW),sub_likes(MuXindxCW).*3,'o','color',[0.2 0.2 0.8],'markerfacecolor',[0.2 0.2 0.8],'markersize',Mrk_sz)
    plot(xspace(MuXindxCW),fliplr(sub_likes(MuXindxCCW)),'o','color',[0.8 0.2 0.2],'markerfacecolor',[0.8 0.2 0.2],'markersize',Mrk_sz)

    XLims = 1;
    xlim([-XLims XLims])
    set(gca,'xtick',[-XLims 0 XLims],'xticklabel',{'CCW' '0' 'CW'})
    set(gca,'ycolor','none'),
    box off
    if AddPanelNames,SetPanelName('D'),end
    
    cd('Figures')
    print('Fig_main_4','-depsc')
    cd ..
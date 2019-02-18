


cd Data
is_file = dir('BestFitting_simpleDDM*');
if numel(is_file) == 0 % file does not exist yet
    SimpleDriftDiffusionFit;
elseif numel(is_file) == 1 % file exists already
    load('BestFitting_simpleDDM.mat')
end
cd ..


%%
MrkrSz = 25;
PprWidth= 21*.9;
figure('name','DDM Accuracy','color','w','units','centimeters','position',[1 1 .2*PprWidth .2*PprWidth])

BarPlot(1:3,HumanAccs(:,1:3),HumanColorLight);
BarPlot(4:6,HumanAccs(:,4:6),HumanColorDark);
LinePlot(1:3,ModelAccs(:,1:3),[.8 .0 .0]);
LinePlot(4:6,ModelAccs(:,4:6),[.8 .0 .0]);
ylim([0.5 1])
set(gca,'xtick',1:6,'xticklabel','','ytick',[0.5 1])
xlim([0 7])
box off

cd('Figures')
print('Fig_SI_4A','-depsc')
cd ..

MrkrSz = 25;
PprWidth= 21*.9;
figure('name','DDM RTs','color','w','units','centimeters','position',[1 1 .2*PprWidth .2*PprWidth])

BarPlot(1:3,HumanRTs(:,1:3),HumanColorLight);
BarPlot(4:6,HumanRTs(:,4:6),HumanColorDark);
LinePlot(1:3,ModelRTs(:,1:3),[.8 .0 .0]);
LinePlot(4:6,ModelRTs(:,4:6),[.8 .0 .0]);
ylim([0.2 0.8])
set(gca,'xtick',1:6,'xticklabel','','ytick',[0.2 0.8])
xlim([0 7])
box off

cd('Figures')
print('Fig_SI_4B','-depsc')
cd ..


%%
LightBlue = [0.6   0.6    1.0  ];
LightRed  = [1.0   0.5    0.5  ];
DarkBlue  = [0.2   0.2    0.8  ];
DarkRed   = [0.9   0.0    0.0  ];

MrkrSz = 25;
PprWidth= 21*.9;
figure('name','Psychometrics','color','w','units','centimeters','position',[1 1 .2*PprWidth .2*PprWidth])

iC = 2; iV = 1; iBiascond = 2; 
Mat1 = squeeze(nanmean(PsychoMataH(1:40,:,1,1,iBiascond)));
Mat2 = squeeze(nanmean(PsychoMataH(1:40,:,1,3,iBiascond)));
Mat3 = squeeze(nanmean(PsychoMataH(1:40,:,2,1,iBiascond)));
Mat4 = squeeze(nanmean(PsychoMataH(1:40,:,2,3,iBiascond)));

MatSE1 = squeeze(nanstd(PsychoMataH(1:40,:,1,1,iBiascond)))./sqrt(39);
MatSE2 = squeeze(nanstd(PsychoMataH(1:40,:,1,3,iBiascond)))./sqrt(39);
MatSE3 = squeeze(nanstd(PsychoMataH(1:40,:,2,1,iBiascond)))./sqrt(39);
MatSE4 = squeeze(nanstd(PsychoMataH(1:40,:,2,3,iBiascond)))./sqrt(39);

[Curv1 ,~ ,~ ,~ ] = Get_Psychometric_Boltzmann(1:6,Mat1,[]);
[Curv2 ,~ ,~ ,~ ] = Get_Psychometric_Boltzmann(1:6,Mat2,[]);
[Curv3 ,~ ,~ ,~ ] = Get_Psychometric_Boltzmann(1:6,Mat3,[]);
[Curv4 ,~ ,~ ,~ ] = Get_Psychometric_Boltzmann(1:6,Mat4,[]);

errorbar(1:6,Mat1,MatSE1,'.','marker','none','color','k')
hold on,
errorbar(1:6,Mat2,MatSE2,'.','marker','none','color','k')
errorbar(1:6,Mat3,MatSE3,'.','marker','none','color','k')
errorbar(1:6,Mat4,MatSE4,'.','marker','none','color','k')

plot(Mat1,'.','markersize',MrkrSz,'color',LightBlue,'markerfacecolor',LightBlue);
plot(Mat2,'.','markersize',MrkrSz,'color',LightRed,'markerfacecolor',LightRed);
plot(Mat3,'.','markersize',MrkrSz,'color',DarkBlue,'markerfacecolor',DarkBlue);
plot(Mat4,'.','markersize',MrkrSz,'color',DarkRed,'markerfacecolor',DarkRed);



plot(1:0.01:6,Curv1(1:0.01:6),'color',LightBlue,'linewidth',2);
plot(1:0.01:6,Curv2(1:0.01:6),'color',LightRed,'linewidth',2);
plot(1:0.01:6,Curv3(1:0.01:6),'color',DarkBlue,'linewidth',2);
plot(1:0.01:6,Curv4(1:0.01:6),'color',DarkRed,'linewidth',2);
box off
set(gca,'ytick',[0.5 1],'xtick',[1 3.5 6],'xticklabel',[],'tickdir','out')
xlim([0.5 6.5])
ylim([0.5 1])

cd('Figures')
print('Fig_SI_4C','-depsc')
cd ..


MrkrSz = 25;
PprWidth= 21*.9;
figure('name','Psychometrics','color','w','units','centimeters','position',[1 1 .2*PprWidth .2*PprWidth])

iC = 2; iV = 1; iBiascond = 2;
Mat1 = squeeze(nanmean(PsychoMatcH(21:40,:,1,1,iBiascond)));
Mat2 = squeeze(nanmean(PsychoMatcH(21:40,:,1,3,iBiascond)));
Mat3 = squeeze(nanmean(PsychoMatcH(21:40,:,2,1,iBiascond)));
Mat4 = squeeze(nanmean(PsychoMatcH(21:40,:,2,3,iBiascond)));

MatSE1 = squeeze(nanstd(PsychoMatcH(21:40,:,1,1,iBiascond)))./sqrt(19);
MatSE2 = squeeze(nanstd(PsychoMatcH(21:40,:,1,3,iBiascond)))./sqrt(19);
MatSE3 = squeeze(nanstd(PsychoMatcH(21:40,:,2,1,iBiascond)))./sqrt(19);
MatSE4 = squeeze(nanstd(PsychoMatcH(21:40,:,2,3,iBiascond)))./sqrt(19);

[Curv1 ,~ ,~ ,~ ] = Get_Psychometric_Boltzmann_C(1:6,Mat1,[]);
[Curv2 ,~ ,~ ,~ ] = Get_Psychometric_Boltzmann_C(1:6,Mat2,[]);
[Curv3 ,~ ,~ ,~ ] = Get_Psychometric_Boltzmann_C(1:6,Mat3,[]);
[Curv4 ,~ ,~ ,~ ] = Get_Psychometric_Boltzmann_C(1:6,Mat4,[]);

errorbar(1:6,Mat1,MatSE1,'.','marker','none','color','k');
hold on,
errorbar(1:6,Mat2,MatSE2,'.','marker','none','color','k');
errorbar(1:6,Mat3,MatSE3,'.','marker','none','color','k');
errorbar(1:6,Mat4,MatSE4,'.','marker','none','color','k');

plot(Mat1,'.','markersize',MrkrSz,'color',LightBlue,'markerfacecolor',LightBlue);
plot(Mat2,'.','markersize',MrkrSz,'color',LightRed,'markerfacecolor',LightRed);
plot(Mat3,'.','markersize',MrkrSz,'color',DarkBlue,'markerfacecolor',DarkBlue);
plot(Mat4,'.','markersize',MrkrSz,'color',DarkRed,'markerfacecolor',DarkRed);

plot(1:0.01:6,Curv1(1:0.01:6),'color',LightBlue,'linewidth',2);
plot(1:0.01:6,Curv2(1:0.01:6),'color',LightRed,'linewidth',2);
plot(1:0.01:6,Curv3(1:0.01:6),'color',DarkBlue,'linewidth',2);
plot(1:0.01:6,Curv4(1:0.01:6),'color',DarkRed,'linewidth',2);
box off
set(gca,'ytick',[60 100],'xtick',[1 3.5 6],'xticklabel',[],'tickdir','out')
xlim([0.5 6.5])
ylim([60 100])

cd('Figures')
print('Fig_SI_4D','-depsc')
cd ..


MrkrSz = 25;
PprWidth= 21*.9;
figure('name','Psychometrics','color','w','units','centimeters','position',[1 1 .2*PprWidth .2*PprWidth])

iC = 2; iV = 1; iBiascond = 2;
Mat1 = squeeze(nanmean(PsychoMatrH(1:40,:,1,1,iBiascond)));
Mat2 = squeeze(nanmean(PsychoMatrH(1:40,:,1,3,iBiascond)));
Mat3 = squeeze(nanmean(PsychoMatrH(1:40,:,2,1,iBiascond)));
Mat4 = squeeze(nanmean(PsychoMatrH(1:40,:,2,3,iBiascond)));

MatSE1 = squeeze(nanstd(PsychoMatrH(1:40,:,1,1,iBiascond)))./sqrt(39);
MatSE2 = squeeze(nanstd(PsychoMatrH(1:40,:,1,3,iBiascond)))./sqrt(39);
MatSE3 = squeeze(nanstd(PsychoMatrH(1:40,:,2,1,iBiascond)))./sqrt(39);
MatSE4 = squeeze(nanstd(PsychoMatrH(1:40,:,2,3,iBiascond)))./sqrt(39);

[Curv1 ,~ ,~ ,~ ] = Get_Psychometric_Boltzmann_RT(1:6,Mat1,[]);
[Curv2 ,~ ,~ ,~ ] = Get_Psychometric_Boltzmann_RT(1:6,Mat2,[]);
[Curv3 ,~ ,~ ,~ ] = Get_Psychometric_Boltzmann_RT(1:6,Mat3,[]);
[Curv4 ,~ ,~ ,~ ] = Get_Psychometric_Boltzmann_RT(1:6,Mat4,[]);

errorbar(1:6,Mat1,MatSE1,'.','marker','none','color','k');
hold on,
errorbar(1:6,Mat2,MatSE2,'.','marker','none','color','k');
errorbar(1:6,Mat3,MatSE3,'.','marker','none','color','k');
errorbar(1:6,Mat4,MatSE4,'.','marker','none','color','k');

plot(Mat1,'.','markersize',MrkrSz,'color',LightBlue,'markerfacecolor',LightBlue);
plot(Mat2,'.','markersize',MrkrSz,'color',LightRed,'markerfacecolor',LightRed);
plot(Mat3,'.','markersize',MrkrSz,'color',DarkBlue,'markerfacecolor',DarkBlue);
plot(Mat4,'.','markersize',MrkrSz,'color',DarkRed,'markerfacecolor',DarkRed);

plot(1:0.01:6,Curv1(1:0.01:6),'color',LightBlue,'linewidth',2);
plot(1:0.01:6,Curv2(1:0.01:6),'color',LightRed,'linewidth',2);
plot(1:0.01:6,Curv3(1:0.01:6),'color',DarkBlue,'linewidth',2);
plot(1:0.01:6,Curv4(1:0.01:6),'color',DarkRed,'linewidth',2);
box off
set(gca,'ytick',[0.4 0.8],'xtick',[1 3.5 6],'xticklabel',[],'tickdir','out')
xlim([0.5 6.5])
ylim([0.4 0.8])

cd('Figures')
print('Fig_SI_4E','-depsc')
cd ..






[Fhclv,XIhclv]=ksdensity(collRTsMat{2,1,2,1}(:),'bandwidth',0.05);
[Fhchv,XIhchv]=ksdensity(collRTsMat{2,3,2,1}(:),'bandwidth',0.05);

PprWidth= 21*.9;
figure('name','Density RTs','color','w','units','centimeters','position',[1 1 .2*PprWidth .2*PprWidth])
H1 = area(XIhclv,Fhclv,'facecolor','b','facealpha',0.5);
hold on,
H2 = area(XIhchv,Fhchv,'facecolor','r','facealpha',0.5);
xlim([0 3])
ylim([0 3])
box off
set(gca,'ytick',[0 3],'xtick',[0 3],'xticklabel',[0 3],'tickdir','out')

cd('Figures')
print('Fig_SI_4F','-depsc')
print('Fig_SI_4F','-dtiffn')
cd ..



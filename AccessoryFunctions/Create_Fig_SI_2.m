function [] = Create_Fig_SI_2()

cd Data
is_file = dir('Simulations_Fig_SI_2*');
if numel(is_file) == 0 % file does not exist yet
    ExhaustiveAccuracies_EnsembleModel;
elseif numel(is_file) == 1 % file exists already
    load('Simulations_Fig_SI_2.mat')
end
cd ..


caxis_lim = [0.5 0.95];
model_acss = squeeze(all_accs);
model_overc = squeeze(all_confs)-squeeze(all_accs);

Titles_all = {'Accuracy in low-c zero-v', 'Accuracy in high-c zero-v', 'Accuracy in low-c high-v'...
    'Accuracy in high-c high-v' 'Difference of above' 'Difference of above'};
Titles_all = {'' '' '' '' '' '' ''};
YLabels = 'sigma low-c';
XLabels = 'sigma high-c';
YLabels = '';
XLabels = '';

figure('color','w','units','centimeters','position',[0 0 25 7])
subplot(2,4,1)
imagesc(all_coh_low,all_coh_high,squeeze(model_acss(1,:,:)))
colormap('parula')
set(gca,'YDir','normal')
H_col = colorbar; caxis(caxis_lim)
set(H_col,'ytick',[0.55 0.95])
line([0 20],[0 20],'color','k')
title(Titles_all{1})
ylabel(YLabels)
xlabel(XLabels)
subplot(2,4,2)
imagesc(all_coh_low,all_coh_high,squeeze(model_acss(3,:,:)))
set(gca,'YDir','normal')
H_col = colorbar; caxis(caxis_lim)
set(H_col,'ytick',[0.55 0.95])
line([0 20],[0 20],'color','k')
ylabel(YLabels)
xlabel(XLabels)
title(Titles_all{3})
subplot(2,4,3)
imagesc(all_coh_low,all_coh_high,squeeze(model_acss(1,:,:)-model_acss(3,:,:)))
set(gca,'YDir','normal')
H_col2 = colorbar; caxis(round(caxis_lim-mean(caxis_lim),1))
set(H_col2,'ytick',[-0.2 0.2])
line([0 20],[0 20],'color','k')
title(Titles_all{5})
ylabel(YLabels)
xlabel(XLabels)

subplot(2,4,5)
imagesc(all_coh_low,all_coh_high,squeeze(model_acss(4,:,:)))
set(gca,'YDir','normal')
H_col = colorbar; caxis(caxis_lim)
set(H_col,'ytick',[0.55 0.95])
line([0 20],[0 20],'color','k')
title(Titles_all{2})
ylabel(YLabels)
xlabel(XLabels)
subplot(2,4,6)
imagesc(all_coh_low,all_coh_high,squeeze(model_acss(6,:,:)))
set(gca,'YDir','normal')
H_col = colorbar; caxis(caxis_lim)
set(H_col,'ytick',[0.55 0.95])
line([0 20],[0 20],'color','k')
title(Titles_all{4})
ylabel(YLabels)
xlabel(XLabels)
subplot(2,4,7)
imagesc(all_coh_low,all_coh_high,squeeze(model_acss(4,:,:)-model_acss(6,:,:)))
set(gca,'YDir','normal')
H_col2 = colorbar; caxis(round(caxis_lim-mean(caxis_lim),1))
set(H_col2,'ytick',[-0.2 0.2]);
line([0 20],[0 20],'color','k')
title(Titles_all{6})
ylabel(YLabels)
xlabel(XLabels)

subplot(2,4,4)
imagesc(all_coh_low,all_coh_high,squeeze(model_overc(1,:,:)))
set(gca,'YDir','normal')
H_col2 = colorbar; 
set(H_col2,'ytick',[-0.2 0.2]);
caxis(round(caxis_lim-mean(caxis_lim),1))
line([0 20],[0 20],'color','k')
title(Titles_all{4})
ylabel(YLabels)
xlabel(XLabels)
subplot(2,4,8)
imagesc(all_coh_low,all_coh_high,squeeze(model_overc(6,:,:)))
set(gca,'YDir','normal')
H_col2 = colorbar; caxis(round(caxis_lim-mean(caxis_lim),1))
set(H_col2,'ytick',[-0.2 0.2]);
line([0 20],[0 20],'color','k')
title(Titles_all{6})
ylabel(YLabels)
xlabel(XLabels)

cd('Figures')
print('Fig_SI_2','-depsc')
cd ..



figure('color','w','units','centimeters','position',[0 0 25 7])
subplot(2,4,1)
imagesc(all_coh_low,all_coh_high,squeeze(model_acss(1,:,:)))
colormap('parula')
set(gca,'YDir','normal','xtick',[0 10 20],'ytick',[0 10 20],'xticklabel','','yticklabel','')
H_col = colorbar; caxis(caxis_lim)
set(H_col,'ytick',[0.55 0.95])
line([0 20],[0 20],'color','k')
title(Titles_all{1})
ylabel(YLabels)
xlabel(XLabels)
subplot(2,4,2)
imagesc(all_coh_low,all_coh_high,squeeze(model_acss(3,:,:)))
set(gca,'YDir','normal','xtick',[0 10 20],'ytick',[0 10 20],'xticklabel','','yticklabel','')
H_col = colorbar; caxis(caxis_lim)
set(H_col,'ytick',[0.55 0.95])
line([0 20],[0 20],'color','k')
ylabel(YLabels)
xlabel(XLabels)
title(Titles_all{3})
subplot(2,4,3)
imagesc(all_coh_low,all_coh_high,squeeze(model_acss(1,:,:)-model_acss(3,:,:)))
set(gca,'YDir','normal','xtick',[0 10 20],'ytick',[0 10 20],'xticklabel','','yticklabel','')
H_col2 = colorbar; caxis(round(caxis_lim-mean(caxis_lim),1))
set(H_col2,'ytick',[-0.2 0.2])
line([0 20],[0 20],'color','k')
title(Titles_all{5})
ylabel(YLabels)
xlabel(XLabels)

subplot(2,4,5)
imagesc(all_coh_low,all_coh_high,squeeze(model_acss(4,:,:)))
set(gca,'YDir','normal','xtick',[0 10 20],'ytick',[0 10 20],'xticklabel','','yticklabel','')
H_col = colorbar; caxis(caxis_lim)
set(H_col,'ytick',[0.55 0.95])
line([0 20],[0 20],'color','k')
title(Titles_all{2})
ylabel(YLabels)
xlabel(XLabels)
subplot(2,4,6)
imagesc(all_coh_low,all_coh_high,squeeze(model_acss(6,:,:)))
set(gca,'YDir','normal','xtick',[0 10 20],'ytick',[0 10 20],'xticklabel','','yticklabel','')
H_col = colorbar; caxis(caxis_lim)
set(H_col,'ytick',[0.55 0.95])
line([0 20],[0 20],'color','k')
title(Titles_all{4})
ylabel(YLabels)
xlabel(XLabels)
subplot(2,4,7)
imagesc(all_coh_low,all_coh_high,squeeze(model_acss(4,:,:)-model_acss(6,:,:)))
set(gca,'YDir','normal','xtick',[0 10 20],'ytick',[0 10 20],'xticklabel','','yticklabel','')
H_col2 = colorbar; caxis(round(caxis_lim-mean(caxis_lim),1))
set(H_col2,'ytick',[-0.2 0.2]);
line([0 20],[0 20],'color','k')
title(Titles_all{6})
ylabel(YLabels)
xlabel(XLabels)

subplot(2,4,4)
imagesc(all_coh_low,all_coh_high,squeeze(model_overc(1,:,:)))
set(gca,'YDir','normal','xtick',[0 10 20],'ytick',[0 10 20],'xticklabel','','yticklabel','')
H_col2 = colorbar; 
set(H_col2,'ytick',[-0.2 0.2]);
caxis(round(caxis_lim-mean(caxis_lim),1))
line([0 20],[0 20],'color','k')
title(Titles_all{4})
ylabel(YLabels)
xlabel(XLabels)
subplot(2,4,8)
imagesc(all_coh_low,all_coh_high,squeeze(model_overc(6,:,:)))
set(gca,'YDir','normal','xtick',[0 10 20],'ytick',[0 10 20],'xticklabel','','yticklabel','')
H_col2 = colorbar; caxis(round(caxis_lim-mean(caxis_lim),1))
set(H_col2,'ytick',[-0.2 0.2]);
line([0 20],[0 20],'color','k')
title(Titles_all{6})
ylabel(YLabels)
xlabel(XLabels)

cd('Figures')
print('Fig_SI_2','-dtiffn')
cd ..


end
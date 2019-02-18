function [] = GetBehaviour_Models()
load('Data/data_human_noise_blindness_Exp_1236.mat')


% check in Noise Fits exists
cd Data
is_file = dir('model_noise_fits*');
if numel(is_file) == 0 % file does not exist yet
    [bestsets,bestvals,fitflags] = GetModelFitNoiseContVarGeneticAlgorithm(data); %paralelise
    save('model_noise_fits.mat','bestsets','bestvals','fitflags')
elseif numel(is_file) == 1 % file exists already
    load('model_noise_fits.mat')
end
cd ..

% Check if model data is saved, otherwise compute it and save it
SaveModelBehaviourData(data)

%% Summary Best Fits
WhSubs  = 1:40; 
Contr   = [0 0 0 1 1 1];
VarM    = [0 1 0 0 1 0];
VarH    = [0 0 1 0 0 1]; 
Noises  = sqrt( (Contr.*bestsets(WhSubs,1)).^2 + (Contr==0).*bestsets(WhSubs,2).^2 + (VarM.*bestsets(WhSubs,3)).^2 + (VarH.*bestsets(WhSubs,4)).^2);  
NoisesDeg = 45.*Noises;

BestSetsDegs = [ nanmean(bestsets(WhSubs,:).*45) ; nanstd(bestsets(WhSubs,:).*45)./sqrt(numel(WhSubs)-1)]
save('Stats/SummaryBestNoiseFits.mat','BestSetsDegs')



%% BIC differences
AICs = nan(9,60,2);
BIC_diff = nan(9,9);

model_names   = {'Omniscient' 'Noise_Blind' 'Variability_Mixer' ...
    'Contrast_Mixer' 'Full_Mixer'  'Average_Variability' ...
    'Average_Contrast' 'Average_Both'  'Blind_Contrast' };


is_file = dir('Stats/table_avg_bic_diffs.m*');
if numel(is_file) == 0 
    DiscreteResp = 2;
    for i_mod = 1:9
        wh_model = [i_mod]
        [modelchoices,modelaccuracies,modelconfidences, modeloptouts,model_aic] = GetModelBehaviourOfAllSubjects(data,bestsets,wh_model,DiscreteResp);
        AICs(i_mod,:,1) = model_aic(:,1);
        AICs(i_mod,:,2) = model_aic(:,2);
    end
    combinedAIC = AICs(:,1:60,1);
    combinedAIC(:,41:60) = AICs(:,41:60,2);
    
    avgAIC = nanmean(combinedAIC(:,1:60),2);
    
    % same number of parameters (BIC = AIC)
    BIC_diff = avgAIC-avgAIC';
    
    
    table_avg_bic_diffs = array2table(model_names','variablenames',{'base_model'});
    for i_mod = 1:9
        table_avg_bic_diffs = setfield(table_avg_bic_diffs,[model_names{i_mod}],BIC_diff(i_mod,:)');
        
    end
    save('Stats/table_avg_bic_diffs.mat','table_avg_bic_diffs','combinedAIC')

else
    load('Stats/table_avg_bic_diffs.mat')
end


%% Create Fig 5B
BICDiff = combinedAIC';
PprWidth= 21*.9;
figure('name','delta BIC','color','w','units','centimeters','position',[1 1 PprWidth/2 PprWidth/3])
subplot(1,2,1)
WhSubs = 1:60;
deltaBIC = BICDiff(WhSubs,2)-BICDiff(WhSubs,1);
bar(1:numel(WhSubs),sort(deltaBIC),'facecolor',[0 0 0],'barwidth',0.4);
box off
hold on
plot(1:numel(WhSubs),repmat(nanmean(deltaBIC),[1 numel(WhSubs)]),'-r','linewidth',2)
set(gca,'xtick',[1 numel(WhSubs)],'ytick',[-360 0 70])
xlim([0 numel(WhSubs)+1])
ylim([-360 70])

subplot(1,2,2)
%PprWidth= 21*.9;
%figure('name','delta BIC','color','w','units','centimeters','position',[1 1 PprWidth/3 PprWidth/3])
WhSubs = 1:60;
deltaBIC = BICDiff(WhSubs,2)-BICDiff(WhSubs,3);
bar(1:numel(WhSubs),sort(deltaBIC),'facecolor',[0 0 0],'barwidth',0.4);
box off
hold on
plot(1:numel(WhSubs),repmat(nanmean(deltaBIC),[1 numel(WhSubs)]),'-r','linewidth',2)
set(gca,'xtick',[1 numel(WhSubs)],'ytick',[-360 0 70],'yticklabel','')
xlim([0 numel(WhSubs)+1])
ylim([-360 70])


cd('Figures')
print('Fig_main_5B','-depsc')
cd ..

end

function [] = SaveModelBehaviourData(data)
% load noise fits
load('Data/model_noise_fits.mat')



cd Data
is_file = dir('data_human_noise_blindness_models.m*');
if numel(is_file) == 0 % file does not exist yet
    
    wh_trials_exp123 = (data.subject <= 60) & ~isnan(data.wasrespcor);
    DiscreteResp = 2;
    
    %optimal
    wh_model = [1];
    [modelchoices,modelaccuracies,modelconfidences, modeloptouts,model_aic] = GetModelBehaviourOfAllSubjects(data,bestsets,wh_model,DiscreteResp);
    mdata_opt = data;
    mdata_opt.whichchosen(wh_trials_exp123)   = modelchoices(wh_trials_exp123);
    mdata_opt.wasrespcor(wh_trials_exp123)    = modelaccuracies(wh_trials_exp123);
    mdata_opt.confidencerep(wh_trials_exp123) = modelconfidences(wh_trials_exp123);
    mdata_opt.wasrespoptout(wh_trials_exp123) = modeloptouts(wh_trials_exp123);
    
    %Blind late
    wh_model = [2];
    [modelchoices,modelaccuracies,modelconfidences, modeloptouts,model_aic] = GetModelBehaviourOfAllSubjects(data,bestsets,wh_model,DiscreteResp);
    mdata_blate = data;
    mdata_blate.whichchosen(wh_trials_exp123)   = modelchoices(wh_trials_exp123);
    mdata_blate.wasrespcor(wh_trials_exp123)    = modelaccuracies(wh_trials_exp123);
    mdata_blate.confidencerep(wh_trials_exp123) = modelconfidences(wh_trials_exp123);
    mdata_blate.wasrespoptout(wh_trials_exp123) = modeloptouts(wh_trials_exp123);
    
    % variability mixer:
    wh_model = [3];
    [modelchoices,modelaccuracies,modelconfidences, modeloptouts,model_aic] = GetModelBehaviourOfAllSubjects(data,bestsets,wh_model,DiscreteResp);
    mdata_semi = data;
    mdata_semi.whichchosen(wh_trials_exp123)   = modelchoices(wh_trials_exp123);
    mdata_semi.wasrespcor(wh_trials_exp123)    = modelaccuracies(wh_trials_exp123);
    mdata_semi.confidencerep(wh_trials_exp123) = modelconfidences(wh_trials_exp123);
    mdata_semi.wasrespoptout(wh_trials_exp123) = modeloptouts(wh_trials_exp123);
    
    save('data_human_noise_blindness_models_continuous.mat','mdata_opt','mdata_blate','mdata_semi')
    
    
    DiscreteResp = 1;
    
    %optimal
    wh_model = [1];
    [modelchoices,modelaccuracies,modelconfidences, modeloptouts,model_aic] = GetModelBehaviourOfAllSubjects(data,bestsets,wh_model,DiscreteResp);
    mdata_opt = mdata_opt;
    mdata_opt.whichchosen(wh_trials_exp123)   = modelchoices(wh_trials_exp123);
    mdata_opt.wasrespcor(wh_trials_exp123)    = modelaccuracies(wh_trials_exp123);
    %mdata_opt.confidencerep(wh_trials_exp123) = modelconfidences(wh_trials_exp123);
    mdata_opt.wasrespoptout(wh_trials_exp123) = modeloptouts(wh_trials_exp123);
    
    %Blind late
    wh_model = [2];
    [modelchoices,modelaccuracies,modelconfidences, modeloptouts,model_aic] = GetModelBehaviourOfAllSubjects(data,bestsets,wh_model,DiscreteResp);
    mdata_blate = mdata_blate;
    mdata_blate.whichchosen(wh_trials_exp123)   = modelchoices(wh_trials_exp123);
    mdata_blate.wasrespcor(wh_trials_exp123)    = modelaccuracies(wh_trials_exp123);
    %mdata_blate.confidencerep(wh_trials_exp123) = modelconfidences(wh_trials_exp123);
    mdata_blate.wasrespoptout(wh_trials_exp123) = modeloptouts(wh_trials_exp123);
    
    % variability mixer:
    wh_model = [3];
    [modelchoices,modelaccuracies,modelconfidences, modeloptouts,model_aic] = GetModelBehaviourOfAllSubjects(data,bestsets,wh_model,DiscreteResp);
    mdata_semi = mdata_semi;
    mdata_semi.whichchosen(wh_trials_exp123)   = modelchoices(wh_trials_exp123);
    mdata_semi.wasrespcor(wh_trials_exp123)    = modelaccuracies(wh_trials_exp123);
    %mdata_semi.confidencerep(wh_trials_exp123) = modelconfidences(wh_trials_exp123);
    mdata_semi.wasrespoptout(wh_trials_exp123) = modeloptouts(wh_trials_exp123);
    
    save('data_human_noise_blindness_models.mat','mdata_opt','mdata_blate','mdata_semi')
end

cd ..



end

function [bestsets,bestvals,fitflags] = GetModelFitNoiseContVarGeneticAlgorithm(data,paralelise)
bestsets = nan(60,4);
bestvals = nan(60,1);
fitflags = nan(60,1);
WhichDone = nan(size(bestvals));

% parameters of the genetic algorithm
PopSz  = 100;
MaxGen = 1000;
PlotInt = 1;
FcnTol = 0.001;
if paralelise
    PlotCell = {};
else
    PlotCell = { @gaplotbestindiv @gaplotbestf @gaplotdistance  @gaplotexpectation @gaplotstopping @gaplotrange};
end
InitialRanges = [  0   0   0   0 ;   2    2    2   2];
LowerBounds   = [  0   0   0   0 ];
UpperBounds   = [  inf inf inf inf];
NumParams = 4;
options = optimoptions('ga','display','off','FunctionTolerance',FcnTol,...
    'MaxGenerations',MaxGen,'PopulationSize',PopSz,'PlotInterval',PlotInt, ...
    'InitialPopulationRange',InitialRanges, ...
    'plotfcn',PlotCell);

% fit each subject

if paralelise
    NameFile = ['ParforCounter_' num2str(round(1000.*rand),'%04i')];
    StartParforCounter(NameFile,81)
    parfor iSub = 1:60
        SaveWhichStartedParfor(NameFile,iSub)
        indsub   = data.subject == iSub;
        
        % define important variables
        perceptualvals  = data.pvs(indsub,:);
        hchoice         = data.whichchosen(indsub) == 1;
        
        wastrialbiased  = data.biasedtrial(indsub) == 1;
        
        % contrast of stimuli
        contrast        = data.contrast(indsub);
        variability     = data.realstdcats(indsub);
        allcontrasts    = unique(contrast);
        lowcontrast     = contrast == allcontrasts(1);
        lowvariability  = (variability < 0.2) & (variability > 0);
        highvariability = variability > 0.2;
        
        
        indfit          = ~(wastrialbiased);
        perceptualvals  = perceptualvals(indfit,:);
        hchoice         = hchoice(indfit);
        indcontr        = lowcontrast(indfit);
        indvar1         = lowvariability(indfit);
        indvar2         = highvariability(indfit);
        
        f = @(params) GetCostOfModelNoiseContVar(perceptualvals,hchoice,indcontr,indvar1,indvar2,params);
        [bestset,fval,exitflag] = ga(f,NumParams,[],[],[],[],LowerBounds,UpperBounds,[],options);
        bestsets(iSub,:) = bestset;
        bestvals(iSub,1) = fval;
        fitflags(iSub,1) = exitflag;
        SaveWhichDoneParfor(NameFile,iSub)
        
    end
else
    for iSub = 1:60
        indsub   = data.subject == iSub;
        
        % define important variables
        perceptualvals  = data.pvs(indsub,:);
        hchoice         = data.whichchosen(indsub) == 1;
        
        wastrialbiased  = data.biasedtrial(indsub) == 1;
        
        % contrast of stimuli
        contrast        = data.contrast(indsub);
        variability     = data.realstdcats(indsub);
        allcontrasts    = unique(contrast);
        lowcontrast     = contrast == allcontrasts(1);
        lowvariability  = (variability < 0.2) & (variability > 0);
        highvariability =  variability > 0.2;
        % fit to trials with low and high contrast
        indfit          = ~(wastrialbiased);
        perceptualvals  = perceptualvals(indfit,:);
        hchoice         = hchoice(indfit);
        indcontr        = lowcontrast(indfit);
        indvar1         = lowvariability(indfit);
        indvar2         = highvariability(indfit);
        
        f = @(params) GetCostOfModelNoiseContVar(perceptualvals,hchoice,indcontr,indvar1,indvar2,params); % Define the anonymous function
        [bestset,fval,exitflag] = ga(f,NumParams,[],[],[],[],LowerBounds,UpperBounds,[],options);
        bestsets(iSub,:) = bestset;
        bestvals(iSub,1) = fval;
        fitflags(iSub,1) = exitflag;
        WhichDone(iSub) = 1;
        iSub
    end
end
end

function [] = StartParforCounter(NameFile,numloops)
WhichDone = nan(numloops,1);
TimeStarted = clock;
save(NameFile,'WhichDone','TimeStarted')
pause(1)
end

function [] = SaveWhichDoneParfor(NameFile,WhichLoop)
pause(rand.*1)
load(NameFile)
WhichDone(WhichLoop) = 1;
TimeElapsed = clock - TimeStarted;
save(NameFile,'WhichDone','TimeStarted','TimeElapsed')
end

function [] = SaveWhichStartedParfor(NameFile,WhichLoop)
pause(rand.*1)
load(NameFile)
WhichDone(WhichLoop) = 0;
TimeElapsed = clock - TimeStarted;
save(NameFile,'WhichDone','TimeStarted','TimeElapsed')
end

function [cost] = GetCostOfModelNoiseContVar(perceptualvals,hchoice,indcontr,indvar1,indvar2,params)
[mchoice] = GetChoicedNoiseContVar(perceptualvals,indcontr,indvar1,indvar2,params);
samechoice = (mchoice.*(hchoice==1)) + (1-mchoice).*(hchoice~=1);
probsame   = samechoice;
cost       = sum(-log(probsame));
end

function [mchoicep] = GetChoicedNoiseContVar(perceptualvals,indcontr,indvar1,indvar2,params)
earlynoise1     = ones(size(indcontr)).*params(1);
earlynoise2     = ones(size(indcontr)).*params(2);
early_std       = ((earlynoise1.*indcontr) + (earlynoise2.*~indcontr));
latenoise1      = ones(size(indvar1)).*params(3);
latenoise2      = ones(size(indvar2)).*params(4);
late_std        = ((latenoise1.*indvar1) + (latenoise2.*indvar2));
total_std       = sqrt(early_std.^2+ late_std.^2);
truemean        = nanmean(perceptualvals,2);
mchoicep        = normcdf(0,-truemean,total_std);
end


function [modelchoices,modelaccuracies,modelconfidences,modeloptouts,model_aic] = GetModelBehaviourOfAllSubjects(data,bestsets,wh_mod,DiscreteResp)

wh_trials_exps123 = data.subject<=60;
wh_trials_exp3    = (data.subject>40)&(data.subject<=60);
wh_trials_exp3    = wh_trials_exp3(wh_trials_exps123);
num_trials_tot    = sum(wh_trials_exps123);
modelchoices      = nan(num_trials_tot,1);
modelconfidences  = nan(num_trials_tot,1);
modeloptouts      = nan(num_trials_tot,1);
model_aic         = nan(60,2);

for i_sub = 1:60
    indsub   = data.subject == i_sub;
    
    % define important variables
    perceptualvals  = data.pvs(indsub,:);
    hchoice         = data.whichchosen(indsub) == 1;
    hchacc          = data.wasrespcor(indsub) == 1;
    hoptout         = data.wasrespoptout(indsub) == 1;
    wastrialbiased  = data.biasedtrial(indsub) == 1;
    wascueclockwise = data.whichcue(indsub) == 1;
    cueprob         = .25+((wascueclockwise==1).*.5);
    cueprob(~wastrialbiased) = 0.5;
    
    % for experiment 3 (40:60), the cue was not shown and instead an
    % opt-out option appeared
    if (i_sub > 40) & (i_sub <= 60)
        cueprob(:) = 0.5;
    end
    
    % contrast of stimuli
    contrast        = data.contrast(indsub);
    variability     = data.realstdcats(indsub);
    allcontrasts    = unique(contrast);
    lowcontrast     = contrast == allcontrasts(1);
    highcontrast    = contrast == allcontrasts(2);
    lowvariability  = (variability < 0.2) & (variability > 0);
    highvariability =  variability > 0.2;
    
    indx            = ~isnan(wastrialbiased);
    perceptualvals  = perceptualvals(indx,:);
    hchoice         = hchoice(indx);
    hoptout         = hoptout(indx);
    hchacc          = hchacc(indx);
    tcontrast       = contrast(indx);
    cueprob         = cueprob(indx);
    indcontr        = lowcontrast(indx);
    indvar1         = lowvariability(indx);
    indvar2         = highvariability(indx);
    params          = bestsets(i_sub,:);
    tvariability    = variability(indx);
    
    [mchoicep, mconf, moptout, ch_cw, conf, optout, model_name] = GetModelBehaviour_GivenParameters(perceptualvals,indcontr,indvar1,indvar2,cueprob,params,wh_mod);
    
    
    if DiscreteResp == 1
        szmchoice = nan(sum(indsub),1); szmchoice(indx) = ch_cw;
        szmconf   = nan(sum(indsub),1); szmconf(indx)   = conf;
        szmopto   = nan(sum(indsub),1); szmopto(indx)   = optout;
    else
        szmchoice = nan(sum(indsub),1); szmchoice(indx) = mchoicep;
        szmconf   = nan(sum(indsub),1); szmconf(indx)   = mconf;
        szmopto   = nan(sum(indsub),1); szmopto(indx)   = moptout;
    end
    
    modelchoices(indsub)     = szmchoice;
    modelconfidences(indsub) = szmconf;
    modeloptouts(indsub)     = szmopto;
    
    ind_biased = wastrialbiased(indx);
    pchsame = (mchoicep.*hchoice) + (1-mchoicep).*(~hchoice);
    aic_biased = -2.*sum(log(0.99.*pchsame(ind_biased) +0.01));
    model_aic(i_sub,1)        = aic_biased;
    
    poptsame = (moptout.*hoptout) + (1-moptout).*(~hoptout);
    
    aic_optable = -2.*sum(log(0.99.*poptsame(ind_biased) +0.01));
    model_aic(i_sub,2)        = aic_optable;
    
end
modelconfidences = modelconfidences.*100;
catofstim        = nanmean(data.pvs(wh_trials_exps123,:),2)>0;
modelaccuracies  = ((modelchoices).*(catofstim==1)) + (1-modelchoices).*(catofstim==0);

indoptout = (wh_trials_exp3) & (modeloptouts == 1) & (data.biasedtrial(wh_trials_exps123) == 1);
if DiscreteResp == 1
    % the cue was not shown in Exp 3 but it is counterbalanced and it
    % serves as a good "coinflip" for deciding the feedback on the 75%
    % of opted-out trials
    whichcue = data.whichcue(wh_trials_exps123);
    modelaccuracies(indoptout) = (catofstim(indoptout)==1) == (whichcue(indoptout)==1);
else
    modelaccuracies(indoptout) = 0.75;
end


end




function [mchoicep, mconf, moptout, ch_cw, conf, optout, model_name] = GetModelBehaviour_GivenParameters(perceptualvals,indcontr,indvar1,indvar2,cueprob,params,wh_mod)
% Define parameters of generative model
rng('default')
earlynoise1     = ones(size(indcontr)).*params(1);
earlynoise2     = ones(size(indcontr)).*params(2);
early_std       = ((earlynoise1.*indcontr) + (earlynoise2.*~indcontr));
latenoise1      = ones(size(indvar1)).*params(3);
latenoise2      = ones(size(indvar2)).*params(4);
late_std        = ((latenoise1.*indvar1) + (latenoise2.*indvar2));
total_std       = sqrt(early_std.^2+ late_std.^2);
truemean        = nanmean(perceptualvals,2);

genmu           = 3/45;
genstd          = 8/45;
xres            = 1000;
xspace          = linspace(-1,1,xres);
truelikes       = (normpdf(xspace,genmu,genstd) + normpdf(xspace,-genmu,genstd)).*(xspace>0);

% Define the conditions that affect noise and the amount of noise
whichcond       = [indcontr indvar1 indvar2];
allconds        = [     0     0     0;     0     0     1;     0     1     0;     1     0     0;     1     0     1;      1     1     0];
noise_allconds  = sqrt( (allconds(:,1).*params(1)).^2 + ((~allconds(:,1)).*params(2)).^2 + (allconds(:,2).*params(3)).^2 + (allconds(:,3).*params(4)).^2);
numconds        = numel(noise_allconds);

% Define the likelihood functions as "experienced" by the observer:
% OMNISCIENT
likelihoods     = nan(numconds,xres);
for icond = 1:numconds
    likelihoods(icond,:)        = conv2(truelikes,normpdf(xspace,0,noise_allconds(icond)),'same');
end

% Likelihoods averager contrast
avg_c_noise_allconds = repmat([noise_allconds(1:3)+noise_allconds(4:6)]./2,[2 1]);
likelihoods_avg_c     = nan(numconds,xres);
for icond = 1:numconds
    likelihoods_avg_c(icond,:)        = conv2(truelikes,normpdf(xspace,0,avg_c_noise_allconds(icond)),'same');
end

% Likelihoods averager variability
avg_v_noise_allconds = [repmat(nanmean(noise_allconds(1:3)),[3 1]) ;repmat(nanmean(noise_allconds(4:6)),[3 1])];
likelihoods_avg_v     = nan(numconds,xres);
for icond = 1:numconds
    likelihoods_avg_v(icond,:)        = conv2(truelikes,normpdf(xspace,0,avg_v_noise_allconds(icond)),'same');
end

% Likelihoods averager both
avg_both_noise_allconds = repmat(nanmean(noise_allconds(1:6)),[6 1]);
likelihoods_avg_both     = nan(numconds,xres);
for icond = 1:numconds
    likelihoods_avg_both(icond,:)        = conv2(truelikes,normpdf(xspace,0,avg_both_noise_allconds(icond)),'same');
end


% Define likelihood functions if collapsing across variability conditions:
% VARIABILITY MIXER
likecollapsedlowc   = nanmean(likelihoods((allconds(:,1)==1),:));
likecollapsedhigc   = nanmean(likelihoods((allconds(:,1)==0),:));
likelihoods_mixer_v       = nan(numconds,xres);
likelihoods_mixer_v(4:6,:)= [ likecollapsedlowc ; likecollapsedlowc ; likecollapsedlowc ];
likelihoods_mixer_v(1:3,:)= [ likecollapsedhigc ; likecollapsedhigc ; likecollapsedhigc ];

% Define likelihood functions if collapsing across contrast conditions:
% CONTRAST MIXER
likecollapsedzerov  = nanmean(likelihoods((sum(allconds(:,2:3),2)==0),:));
likecollapsedlowv   = nanmean(likelihoods((allconds(:,2)==1),:));
likecollapsedhigv   = nanmean(likelihoods((allconds(:,3)==1),:));
likelihoods_mixer_c       = nan(numconds,xres);
% the conditions for variability go zero high and low
likelihoods_mixer_c(4:6,:)= [ likecollapsedzerov ; likecollapsedhigv ; likecollapsedlowv ];
likelihoods_mixer_c(1:3,:)= [ likecollapsedzerov ; likecollapsedhigv ; likecollapsedlowv ];

% Define likelihood functions if collapsing across contrast conditions:
% FULL MIXER
likecollapsedall    = nanmean(likelihoods);
likelihoods_mixer_all(1:6,:)= repmat(likecollapsedall,[6 1]);

% Blind to Integration Noise
likelihoods_blind_int       = nan(numconds,xres);
likelihoods_blind_int(4:6,:)= [likelihoods(4,:) ; likelihoods(4,:) ; likelihoods(4,:)];
likelihoods_blind_int(1:3,:)= [likelihoods(1,:) ; likelihoods(1,:) ; likelihoods(1,:)];

% Blind to Encoding Noise
likelihoods_blind_enc       = nan(numconds,xres);
likelihoods_blind_enc(4:6,:)= [likelihoods(1,:) ; likelihoods(2,:) ; likelihoods(3,:)];
likelihoods_blind_enc(1:3,:)= [likelihoods(1,:) ; likelihoods(2,:) ; likelihoods(3,:)];


% Choose which likelihood functions to use to compute model behaviour
switch wh_mod
    case 1 % Omniscient
        mlikelihoods = likelihoods;
        model_name   = 'Omniscient';
    case 2 % Noise Blind (Integration)
        mlikelihoods = likelihoods_blind_int;
        model_name   = 'Noise Blind';
    case 3 % Varibility Mixer
        mlikelihoods = likelihoods_mixer_v;
        model_name   = 'Variability Mixer';
    case 4 % Contrast Mixer
        mlikelihoods = likelihoods_mixer_c;
        model_name   = 'Contrast Mixer';
    case 5 % Full Mixer
        mlikelihoods = likelihoods_mixer_all;
        model_name   = 'Full Mixer';
    case 6 % Varibility Average
        mlikelihoods = likelihoods_avg_v;
        model_name   = 'Average Variability';
    case 7 % Contrast Average
        mlikelihoods = likelihoods_avg_c;
        model_name   = 'Average Contrast';
    case 8 % Average Both
        mlikelihoods = likelihoods_avg_both;
        model_name   = 'Average Both';
    case 9 % Noise Blind (Encoding)
        mlikelihoods = likelihoods_blind_enc;
        model_name   = 'Blind Contrast';
        
end

% Get trial to trial estimates of choice probability, and posterior belief
nbiases = 3;
PSEs    = nan(nbiases,numconds);
probcw  = nan(xres,nbiases,numconds);
for icond = 1:numconds
    
    % compute the posterior odds function for the three biasing conditions
    postodds_cr = (0.75.*mlikelihoods(icond,:))./(0.25.*fliplr(mlikelihoods(icond,:)));
    postodds_nc = (0.50.*mlikelihoods(icond,:))./(0.50.*fliplr(mlikelihoods(icond,:)));
    postodds_cl = (0.25.*mlikelihoods(icond,:))./(0.75.*fliplr(mlikelihoods(icond,:)));
    
    % compute the logLR
    loglr_cr = log(postodds_cr);
    loglr_nc = log(postodds_nc);
    loglr_cl = log(postodds_cl);
    
    % Get the point of subjective equality PSE (where the ratios are equal)
    pse_cr = xspace(find(abs(loglr_cr) == min(abs(loglr_cr)),1));
    pse_nc = xspace(find(abs(loglr_nc) == min(abs(loglr_nc)),1));
    pse_cl = xspace(find(abs(loglr_cl) == min(abs(loglr_cl)),1));
    if ~isempty(pse_cr)
        PSEs(1,icond) = pse_cr;
        PSEs(2,icond) = pse_nc;
        PSEs(3,icond) = pse_cl;
    end
    
    % Convert ratios to proportions
    probcw_cr = ratio2prob(postodds_cr);
    probcw_nc = ratio2prob(postodds_nc);
    probcw_cl = ratio2prob(postodds_cl);
    probcw(:,1,icond)  = probcw_cr;
    probcw(:,2,icond)  = probcw_nc;
    probcw(:,3,icond)  = probcw_cl;
    
end

% Convert probability of choosing CW to certainty about response
conffcns  = abs(probcw-.5)+.5;
%conffcns  = probcw;

% Compute expected behaviour for each trial
ntrials     = numel(truemean);
pchoice_cw  = nan(ntrials,1);
confidence  = nan(ntrials,1);
moptout     = nan(ntrials,1);
% Compute a trial instantiation
ch_cw       = nan(ntrials,1);
conf        = nan(ntrials,1);
optout     = nan(ntrials,1);

for itrial = 1:ntrials
    
    % retrieve the trial parameters: i.e. bias, condition, mean...
    whcond      = find(sum(allconds == repmat(whichcond(itrial,:),[6 1]),2)==3);
    ibias       = find([0.75 0.5 0.25]  == cueprob(itrial));
    inoise      = total_std(itrial);
    imean       = truemean(itrial);
    
    % compute the full density of noisy evidence for the trial
    noisepdf     = normpdf(xspace,imean,inoise);
    % make the pdf add up to one
    noisepdf     = noisepdf./sum(noisepdf);
    
    % define the step function for choice
    thresh_ch     = 1.*(squeeze(probcw(:,ibias,whcond)) > 0.5)';
    % define the certainty function
    conffcn       =     squeeze(conffcns(:,ibias,whcond))';
    % define the step function for opting out
    thresh_opto   = 1.*(conffcn < 0.75);
    %thresh_opto   = 1.*((abs(conffcn-.5)+.5) < 0.75);
    
    % convolve with the noisepdf to get an estimate of the mean expected
    % behaviour:
    pchoice_cw(itrial,1)  = sum(thresh_ch.*noisepdf);
    confidence(itrial,1)  = sum(conffcn.*noisepdf);
    moptout(itrial,1)     = sum(thresh_opto.*noisepdf);
    
    % compute noisysample and pull out a trial
    noisysample  = imean+randn.*inoise;
    indnoisysample = find(abs(xspace-noisysample) == min(abs(xspace-noisysample)),1);
    ch_cw(itrial,1)  = thresh_ch(indnoisysample);
    conf(itrial,1)   = conffcn(indnoisysample);
    optout(itrial,1) = thresh_opto(indnoisysample);
    
end

%Continuous estimates
mconf              = confidence;
mchoicep           = pchoice_cw;
moptout            = moptout;


end

function [p] = ratio2prob(ratio)
p = 1./((1./(ratio))+1);
end



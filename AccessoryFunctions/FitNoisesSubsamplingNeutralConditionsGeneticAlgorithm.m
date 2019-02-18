function [bestsets,bestvals,fitflags] = FitNoisesSubsamplingNeutralConditionsGeneticAlgorithm(data)
bestsets = nan(60,3);
bestvals = nan(60,1);
fitflags = nan(60,1);
% fit each subject
for iSub = 1:60
    indsub   = data.subject == iSub;
    
    % define important variables
    perceptualvals  = data.pvs(indsub,:);
    hchoice         = data.whichchosen(indsub) == 1;
    
    wastrialbiased  = data.biasedtrial(indsub) == 1;
    
    % contrast of stimuli
    contrast        = data.contrast(indsub);
    
    % fit to trials with low and high contrast
    indfit          = (~wastrialbiased);
    perceptualvals  = perceptualvals(indfit,:);
    hchoice         = hchoice(indfit);
    tcontrast       = contrast(indfit);
    
    PopSz  = 1000;
    MaxGen = 1000;
    PlotInt = 5;
    FcnTol = 0.01;
    PlotCell = { @gaplotbestindiv @gaplotbestf @gaplotdistance  @gaplotexpectation @gaplotstopping @gaplotrange};
    InitialRanges = [   0       0     1;   2   2  8];
    LowerBounds   = [   0       0     1];
    UpperBounds   = [   inf     inf   8];
    NumParams = 3;
    options = optimoptions('ga','display','off','FunctionTolerance',FcnTol,...
        'MaxGenerations',MaxGen,'PopulationSize',PopSz,'PlotInterval',PlotInt, ...
        'InitialPopulationRange',InitialRanges, ...
        'plotfcn',PlotCell);
    f = @(params) GetCostOfSubsamplerModel(perceptualvals,hchoice,tcontrast,tcontrast,params);
    [bestset,fval,exitflag] = ga(f,NumParams,[],[],[],[],LowerBounds,UpperBounds,[],options);
    bestsets(iSub,:) = bestset;
    bestsets(iSub,3) = round(bestsets(iSub,3));
    bestvals(iSub,1) = fval;
    fitflags(iSub,1) = exitflag;
    iSub
end
end


function [cost] = GetCostOfSubsamplerModel(perceptualvals,hchoice,tcontrast,choicefreq,params)
numsamp = round(params(3));
choicefreq = choicefreq.*0;
IndLowCont = tcontrast < 0.5;
NumRep = 1000;
for i = 1:NumRep
    IndNoise = randn(size(perceptualvals,1),numsamp).*params(1);
    IndNoise(find(IndLowCont),:) = IndNoise(find(IndLowCont),:).*params(2);
    DV = sum(perceptualvals(:,1:numsamp)+IndNoise,2);
    choicefreq = choicefreq + (DV<0)./NumRep;
end
samechoice = (choicefreq.*(hchoice~=1)) + (1-choicefreq).*(hchoice==1);
probsame   = 0.01+.99.*samechoice;
cost       = sum(-log(probsame));
end

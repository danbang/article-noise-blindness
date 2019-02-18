function [] = SimpleDriftDiffusionFit(data)
NumParam = 3;
bestsets = nan(40,NumParam);
bestvals = nan(40,1);
fitflags = nan(40,1);

HumanRTs  = nan(40,6);
HumanAccs = nan(40,6);

ModelRTs  = nan(40,6);
ModelAccs = nan(40,6);

% fit each subject
for iSub = 1:40
    indsub   = data.subject == iSub;
    
    
    wastrialbiased  = data.biasedtrial(indsub) == 1;
    
    % contrast of stimuli
    contrast        = data.contrast(indsub);
    variability     = data.realstdcats(indsub);
    
    rts = data.responsetimes(indsub);
    acc = data.wasrespcor(indsub)==1;
    
    AllCs = unique(contrast);
    AllVs = unique(variability);
    for iC = 1:numel(AllCs)
        for iV = 1:numel(AllVs)
            iCond = (contrast == AllCs(iC)) & (variability == AllVs(iV));
            HumanRTs(iSub,iV+(iC-1).*3)  = nanmean(rts(iCond));
            HumanAccs(iSub,iV+(iC-1).*3) = nanmean(acc(iCond));
        end
    end

    
    PopSz  = 1000;
    MaxGen = 1000;
    PlotInt = 5;
    FcnTol = 0.000001;
    PlotCell = { @gaplotbestindiv @gaplotbestf @gaplotdistance  @gaplotexpectation @gaplotstopping @gaplotrange};
    InitialRanges = [   0       0       0     ;   2   2   2 ];
    LowerBounds   = [  -inf    -inf    -inf  ];
    UpperBounds   = [   inf     inf     inf  ];
    NumParams = 3;
    options = optimoptions('ga','display','off','FunctionTolerance',FcnTol,...
        'MaxGenerations',MaxGen,'PopulationSize',PopSz,'PlotInterval',PlotInt, ...
        'InitialPopulationRange',InitialRanges, ...
        'plotfcn',PlotCell);

    f = @(params) GetCostOfDDMaccs(HumanAccs(iSub,:),params); % Define the anonymous function
    [bestset,fval,exitflag] = ga(f,NumParams,[],[],[],[],LowerBounds,UpperBounds,[],options);
    bestsets(iSub,:) = bestset;
    bestvals(iSub,1) = fval;
    fitflags(iSub,1) = exitflag;
    iSub
    [errs,mrts] = GetDDMs(bestset);
    ModelRTs(iSub,:)  = mrts;
    ModelAccs(iSub,:) = 1-errs;
end

save('Data/BestFitting_simpleDDM.mat','bestsets','bestvals','fitflags','HumanAccs','HumanRTs','ModelAccs','ModelRTs')

end

function [cost] = GetCostOfDDMrts(hrts,params)
[errs,mrts] = GetDDMs(params);
cost = sum((hrts-mrts).^2);
end

function [cost] = GetCostOfDDMaccs(haccs,params)
[errs,mrts] = GetDDMs(params);
cost = sum((haccs-(1-errs)).^2);
end

function [errs,mrts] = GetDDMs(params)

z = params(1);
condCount = 0;
mrts = nan(1,6);
errs = nan(1,6);
for iC = 1:2
    A = iC;%params(1);
    for iV = 1:3
        condCount = condCount+1;

        fullnoise        = params(2) + (params(3).*iV);% add up early and late noise
        c = fullnoise;
        [errorrate,meanrts] = SimpleDriftDiffusionRTs(c,A,z);
        mrts(condCount) =  meanrts;  
        errs(condCount) =  errorrate;  

    end
end

end
function [errorrate,meanrts] = SimpleDriftDiffusionRTs(c,A,z)
% c = noise
% A = 
% z = threshold

%c = params(1);
%A = params(2);
%z = params(3);

errorrate = 1./(1+exp(2.*(A.*z)./(c.^2)));
meanrts   = (z./A).*tanh((A.*z)./(c.^2));

end
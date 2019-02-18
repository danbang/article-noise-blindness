function [betaschoice, betassignedconf, betasconf, betasopto] = RunRegressionFull(data)

betaschoice       = nan(60,9);
betassignedconf   = nan(60,9);
betasconf         = nan(60,6);
betasopto         = nan(60,5);

% run analyses for the original task
for iSub = 1:60
    indsub   = data.subject == iSub;
    
    % define important variables
    perceptualvals  = data.pvs(indsub,:);
    meanofstim      = nanmean(perceptualvals,2);
    
    chcw            = data.whichchosen(indsub) > 0.5;
    cue             = data.whichcue(indsub);
    
    % contrast of stimuli
    contrast        = data.contrast(indsub);    
    
    % variability of stimuli array
    actualstds      = nanstd(perceptualvals,[],2);
    
    % cueing condition
    wastrialbiased  = data.biasedtrial(indsub) == 1;
    
    
    respcor = data.wasrespcor(indsub);
    confrep = data.confidencerep(indsub)./100;
    optout  = data.wasrespoptout(indsub);
    rts     = data.responsetimes(indsub);
    indx1 = (wastrialbiased==1) & ~(isnan(rts)) ;
    indx2 = (wastrialbiased==0) ;
    Y1 = chcw(indx1);
    Y2 = confrep(indx1).*(chcw(indx1)-.5).*2;
    Y3 = confrep(indx2);
    Y4 = optout(indx1) == 1;

    X1 = [ ZTransformX(meanofstim(indx1)) cue(indx1) 2.*((contrast(indx1)==.6)-.5) ZTransformX(actualstds(indx1))];
    X2 = [(X1(:,1)) X1(:,2) ZTransformX(X1(:,1).*X1(:,3)) ZTransformX(X1(:,1).*X1(:,4)) ZTransformX(X1(:,2).*X1(:,3)) ZTransformX(X1(:,2).*X1(:,4)) ];
    
    X3 = [ZTransformX(abs(meanofstim(indx2))) 2.*((contrast(indx2)==.6)-.5) ZTransformX(actualstds(indx2)) 2.*((respcor(indx2)==1)-.5) ZTransformX(rts(indx2))];
    X4 = [ZTransformX(abs(meanofstim(indx1))) 2.*((contrast(indx1)==.6)-.5) ZTransformX(actualstds(indx1)) ZTransformX(rts(indx1))];


    if mean(~isnan(Y1))>0
        b1 = glmfit(X2,Y1,'binomial','link','probit');
    else
        b1 = nan(size(X2,2)+1,1);
    end
    if mean(~isnan(Y2))>0
        b2 = glmfit(X2,Y2);
    else
        b2 = nan(size(X2,2)+1,1);
    end
    if mean(~isnan(Y3))>0
        b3 = glmfit(X3,Y3);
    else
        b3 = nan(size(X3,2)+1,1);
    end
    if nansum(Y4)>1
        b4 = glmfit(X4,Y4,'binomial','link','probit');
    else
        b4 = nan(size(X4,2)+1,1);
    end
    
    NumReg1 = size(X2,2)+1;
    NumReg3 = size(X3,2)+1;
    NumReg4 = size(X4,2)+1;
    betaschoice(iSub,1:NumReg1)         = b1(1:NumReg1);
    betassignedconf (iSub,1:NumReg1)    = b2(1:NumReg1);
    betasconf (iSub,1:NumReg3)          = b3(1:NumReg3);
    betasopto (iSub,1:NumReg4)          = b4(1:NumReg4);
end
end

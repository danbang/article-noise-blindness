function [RTsMat,ConfMat,cRTsMat,cConfMat] = GetCollapsedRTsAndConf(data)
RTsMat       = cell(2,3,3,2);
ConfMat      = cell(2,3,3,2);
cRTsMat       = cell(3,2);
cConfMat      = cell(3,2);

for iSub = [1:40]
    indsub   = data.subject == iSub;
    
    % define important variables
    perceptualvals  = data.pvs(indsub,:);
    meanofstim      = nanmean(perceptualvals,2);
    catofstim       = meanofstim > 0;
    cue             = data.whichcue(indsub);
    catofcue        = cue == 1;
    wastrialbiased  = data.biasedtrial(indsub) == 1;
    
    valid           = (catofcue == catofstim) & wastrialbiased;
    invalid         = (catofcue ~= catofstim) & wastrialbiased;
    neutral         = ~wastrialbiased;
    
    % contrast of stimuli
    contrast        = data.contrast(indsub);
    variance        = data.realstdcats(indsub);
    
    whcont          = [0.15 0.6];
    whvars          = [unique(variance)];
    
    respcor  = data.wasrespcor(indsub);
    confrep  = data.confidencerep(indsub)./100;
    
    rts      = data.responsetimes(indsub);
        
    corrects = respcor > 0.5;
    errors   = respcor < 0.5;
    
    for iC = 1:2
        for iV = 1:3
            indxval = valid   & ~(isnan(rts)) & (contrast == whcont(iC)) & (variance == whvars(iV));
            indxinv = invalid & ~(isnan(rts)) & (contrast == whcont(iC)) & (variance == whvars(iV));
            indxneu = neutral & ~(isnan(rts)) & (contrast == whcont(iC)) & (variance == whvars(iV));
            
            RTsMat{iC,iV,1,1}   = [ RTsMat{iC,iV,1,1}; (rts(indxval & corrects))];
            RTsMat{iC,iV,2,1}   = [ RTsMat{iC,iV,2,1}; (rts(indxneu & corrects))];
            RTsMat{iC,iV,3,1}   = [ RTsMat{iC,iV,3,1}; (rts(indxinv & corrects))];
            RTsMat{iC,iV,1,2}   = [ RTsMat{iC,iV,1,2}; (rts(indxval & errors))];
            RTsMat{iC,iV,2,2}   = [ RTsMat{iC,iV,2,2}; (rts(indxneu & errors))];
            RTsMat{iC,iV,3,2}   = [ RTsMat{iC,iV,3,2}; (rts(indxinv & errors))];
            
            ConfMat{iC,iV,1,1}   = [ ConfMat{iC,iV,1,1}; (confrep(indxval & corrects))];
            ConfMat{iC,iV,2,1}   = [ ConfMat{iC,iV,2,1}; (confrep(indxneu & corrects))];
            ConfMat{iC,iV,3,1}   = [ ConfMat{iC,iV,3,1}; (confrep(indxinv & corrects))];
            ConfMat{iC,iV,1,2}   = [ ConfMat{iC,iV,1,2}; (confrep(indxval & errors))];
            ConfMat{iC,iV,2,2}   = [ ConfMat{iC,iV,2,2}; (confrep(indxneu & errors))];
            ConfMat{iC,iV,3,2}   = [ ConfMat{iC,iV,3,2}; (confrep(indxinv & errors))];
        end
    end
end
end

function [AccGain,ResCMat] = Get_AccuracyGainAndConfRes(data)

AccGain  = nan(60,2,3);
ResCMat   = nan(60,2,3,2);

% run analyses for the original task
for iSub = 1:60
    indsub   = data.subject == iSub;
    
    % contrast of stimuli
    contrast        = data.contrast(indsub);
    variance        = data.realstdcats(indsub);
    
    whcont          = unique(contrast);
    whvars          = unique(variance);
    
    % cueing condition
    wastrialbiased  = data.biasedtrial(indsub) == 1;
    
    respcor = data.wasrespcor(indsub);
    confrep = data.confidencerep(indsub)./100;% human
    rts     = data.responsetimes(indsub);
    
    for iC = 1:2
        for iV = 1:3
            indx1 = (wastrialbiased==1) & ~(isnan(rts)) & (contrast == whcont(iC)) & (variance == whvars(iV));
            indx2 = (wastrialbiased==0) & ~(isnan(rts)) & (contrast == whcont(iC)) & (variance == whvars(iV));
            
            Acc1  = respcor(indx1);
            Acc2  = respcor(indx2);
            
            Conf1  = confrep(indx1);
            Conf2  = confrep(indx2);
            
            AccGain(iSub,iC,iV)   = nanmean(Acc1)-nanmean(Acc2);
            
            ResCMat(iSub,iC,iV,1) = nanmean(Conf1(Acc1>0.5))-nanmean(Conf1(Acc1<0.5));
            ResCMat(iSub,iC,iV,2) = nanmean(Conf2(Acc2>0.5))-nanmean(Conf2(Acc2<0.5));
        end
    end
    
    
end
end
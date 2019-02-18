function [ResMat, CalMat,ConfVarMat,OptOutVarMat,ConfMuMat,OptOutMuMat] = GetConfidenceResolution(data)

NumConfBins     = 5;
CalMat          = nan(81,2,3,2,NumConfBins);
ResMat          = nan(81,2,3,2);
ConfVarMat      = nan(81,1);
OptOutVarMat    = nan(81,1);
ConfMuMat       = nan(81,1);
OptOutMuMat     = nan(81,1);

for iSub = [1:60]
    indsub   = data.subject == iSub;
        
    % contrast of stimuli
    contrast        = data.contrast(indsub);
    variance        = data.realstdcats(indsub);
    
    whcont          = [0.15 0.6];
    whvars          = [unique(variance)];
    
    % cueing condition
    wastrialbiased  = data.biasedtrial(indsub) == 1;
    
    respcor  = data.wasrespcor(indsub);
    confrep  = data.confidencerep(indsub);
    optoresp = data.wasrespoptout(indsub);
    ConfVarMat(iSub,1)      = nanstd(confrep);
    OptOutVarMat(iSub,1)    = nanstd(optoresp(wastrialbiased));
    ConfMuMat(iSub,1)       = nanmean(confrep);
    OptOutMuMat(iSub,1)     = nanmean(optoresp(wastrialbiased));
    
    rts     = data.responsetimes(indsub);
    
    for iC = 1:2
        for iV = 1:3
            indx1 = (wastrialbiased==1) & ~(isnan(rts)) & (contrast == whcont(iC)) & (variance == whvars(iV));
            indx2 = (wastrialbiased==0) & ~(isnan(rts)) & (contrast == whcont(iC)) & (variance == whvars(iV));
            
            Acc1  = respcor(indx1);
            Acc2  = respcor(indx2);
            Conf1 = confrep(indx1);
            Conf2 = confrep(indx2);
            
            ResMat(iSub,iC,iV,1)   = nanmean(Conf1(Acc1>0.5))-nanmean(Conf1(Acc1<0.5));
            ResMat(iSub,iC,iV,2)   = nanmean(Conf2(Acc2>0.5))-nanmean(Conf2(Acc2<0.5));
            for iConf = 1:NumConfBins
                
                blims = linspace(50,100,NumConfBins+1);
                lb = [49 blims(2:end-1)];
                ub = blims(2:end);
                
                indcb1 = (Conf1>lb(iConf)) & (Conf1<=ub(iConf));
                indcb2 = (Conf2>lb(iConf)) & (Conf2<=ub(iConf));
                
                CalMat(iSub,iC,iV,1,iConf)  = nanmean(Acc1(indcb1));
                CalMat(iSub,iC,iV,2,iConf)  = nanmean(Acc2(indcb2));
                
            end
        end
    end
    
    
end
end

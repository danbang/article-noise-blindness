function [PsychoMatm] = PsychometricPoints(data)

mus     = nanmean(data.pvs,2);

nB = 6;

% for the mean
bXm     = quantile(abs(mus),linspace(0,1,(nB/2)+1));
xbinsm = [-fliplr(bXm(2:end)) bXm];
llCm = [ xbinsm(1:end-1) ];
hlCm = [ xbinsm(2:end)   ];



NumSubs     = max(data.subject);
PsychoMatm  = nan(NumSubs,nB,2,3,3);

for iSub = 1:NumSubs
    
    indsub      = data.subject == iSub;
    indbiased   = data.biasedtrial == 1;
    
    cue         = data.whichcue;
    chcw        = data.whichchosen==1;
    cmr         = data.contrast;
    var         = 1+ (data.realstdcats>0) + (data.realstdcats>0.09);
    
    allvars     = unique(var);
    allcmrs     = unique(cmr);
    for iVar = 1:3
        indvar = var == allvars(iVar);
        for iCon = 1:2
            indcon  = cmr == allcmrs(iCon);
            indcw   =  indsub&indbiased&indvar&indcon&(cue==1);
            indneut =  indsub&(~indbiased)&indvar&indcon;
            indccw  =  indsub&indbiased&indvar&indcon&(cue==-1);
            
            % for the mean
            chcw1       = chcw(indcw);
            chcw2       = chcw(indneut);
            chcw3       = chcw(indccw);
            imus1       = mus(indcw);
            imus2       = mus(indneut);
            imus3       = mus(indccw);

            
            for j = 1:(nB)
                
                indBin1 = ((imus1) >= llCm(j)) & ((imus1) < hlCm(j));
                indBin2 = ((imus2) >= llCm(j)) & ((imus2) < hlCm(j));
                indBin3 = ((imus3) >= llCm(j)) & ((imus3) < hlCm(j));
                PsychoMatm(iSub,j,iCon,iVar,1) = nanmean(chcw1(indBin1));
                PsychoMatm(iSub,j,iCon,iVar,2) = nanmean(chcw2(indBin2));
                PsychoMatm(iSub,j,iCon,iVar,3) = nanmean(chcw3(indBin3));

            end
            
        end
    end
    
end

end
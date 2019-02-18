function [PsychoMatm, PsychoMatam, PsychoMatrt, PsychoMatco] = GetPsychometricPoints(data)
mus     = nanmean(data.pvs,2);
absmus  = abs(mus);
rts     = data.responsetimes;
conf    = data.confidencerep;
nB = 6;

% for the mean
bXm     = quantile(abs(mus),linspace(0,1,(nB/2)+1));
xbinsm = [-fliplr(bXm(2:end)) bXm];
llCm = [ xbinsm(1:end-1) ];
hlCm = [ xbinsm(2:end)   ];

% for the unsigned mean (and RTs and conf)
bXam    = quantile(absmus,linspace(0,1,nB+1));
xbinsam = [ bXam];
llCam = [ xbinsam(1:end-1) ];
hlCam = [ xbinsam(2:end)   ];


NumSubs     = max(data.subject);
PsychoMatm  = nan(NumSubs,nB,2,3,3);
PsychoMatam = nan(NumSubs,nB,2,3,3);
PsychoMatrt = nan(NumSubs,nB,2,3,3);
PsychoMatco = nan(NumSubs,nB,2,3,3);
for iSub = 1:NumSubs
    
    indsub      = data.subject == iSub;
    indbiased   = data.biasedtrial == 1;
    
    cue         = data.whichcue;
    chcw        = data.whichchosen==1;
    chc         = data.wasrespcor==1;
    cmr         = data.contrast;
    var         = 1+ (data.realstdcats>0) + (data.realstdcats>0.09);
    
    allvars     = unique(var);
    allcmrs     = unique(cmr);
    for iVar = 1:3
        indvar = var == allvars(iVar);
        for iCont = 1:2 
            indcon  = cmr == allcmrs(iCont);
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
            
            %for the unsigned mean
            chc1        = chc(indcw);
            chc2        = chc(indneut);
            chc3        = chc(indccw);
            iamus1      = absmus(indcw);
            iamus2      = absmus(indneut);
            iamus3      = absmus(indccw);
            
            %for RTs
            rts1        = rts(indcw);
            rts2        = rts(indneut);
            rts3        = rts(indccw);
            
            
            %for conf
            conf1        = conf(indcw);
            conf2        = conf(indneut);
            conf3        = conf(indccw);
            
            for j = 1:(nB)
                
                % for the mean
                indBin1 = ((imus1) >= llCm(j)) & ((imus1) < hlCm(j));
                indBin2 = ((imus2) >= llCm(j)) & ((imus2) < hlCm(j));
                indBin3 = ((imus3) >= llCm(j)) & ((imus3) < hlCm(j));
                PsychoMatm(iSub,j,iCont,iVar,1) = nanmean(chcw1(indBin1));
                PsychoMatm(iSub,j,iCont,iVar,2) = nanmean(chcw2(indBin2));
                PsychoMatm(iSub,j,iCont,iVar,3) = nanmean(chcw3(indBin3));
                
                %for the unsigned mean
                indBin1 = ((iamus1) >= llCam(j)) & ((iamus1) < hlCam(j));
                indBin2 = ((iamus2) >= llCam(j)) & ((iamus2) < hlCam(j));
                indBin3 = ((iamus3) >= llCam(j)) & ((iamus3) < hlCam(j));
                PsychoMatam(iSub,j,iCont,iVar,1) = nanmean(chc1(indBin1));
                PsychoMatam(iSub,j,iCont,iVar,2) = nanmean(chc2(indBin2));
                PsychoMatam(iSub,j,iCont,iVar,3) = nanmean(chc3(indBin3));
                
                %for RTs
                PsychoMatrt(iSub,j,iCont,iVar,1) = nanmean(rts1(indBin1));
                PsychoMatrt(iSub,j,iCont,iVar,2) = nanmean(rts2(indBin2));
                PsychoMatrt(iSub,j,iCont,iVar,3) = nanmean(rts3(indBin3));
                
                %for conf
                PsychoMatco(iSub,j,iCont,iVar,1) = nanmean(conf1(indBin1));
                PsychoMatco(iSub,j,iCont,iVar,2) = nanmean(conf2(indBin2));
                PsychoMatco(iSub,j,iCont,iVar,3) = nanmean(conf3(indBin3));
                
                
            end
            
        end
    end
    
end
end
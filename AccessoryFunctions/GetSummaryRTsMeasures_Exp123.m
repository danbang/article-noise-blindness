function [allresponsetimes] = GetSummaryRTsMeasures_Exp123(data)
allresponsetimes  = nan(60,12);

for iSub = 1:60
    indsub   = data.subject == iSub;
    
    % define important variables
    perceptualvals  = data.pvs(indsub,:);
    meanofstim      = nanmean(perceptualvals,2);
    catofstim       = meanofstim>0;
    
    % contrast of stimuli
    contrast        = data.contrast(indsub);
    allcontrasts    = unique(contrast);
    lowcontrast     = contrast == allcontrasts(1);
    highcontrast    = contrast == allcontrasts(2);
    
    % variability of stimuli array
    targetstds      = data.targetarraystd(indsub);
    actualstds      = nanstd(perceptualvals,[],2);
    alltargetstds   = unique(targetstds);
    medianstd       = nanmedian(actualstds(targetstds>0));
    highstd         = actualstds>medianstd;
    lowstd          = targetstds == 0;
    medstd          = ~lowstd&~highstd;
    actualstdcat    = lowstd.*0 + 1.*medstd + 2.*(highstd);
    
    % cueing condition
    wastrialbiased  = data.biasedtrial(indsub) == 1;
    wascueclockwise = data.whichcue(indsub) == 1;
    
    
    respcor = data.wasrespcor(indsub);% human
    confrep = data.confidencerep(indsub);% human
    optout  = data.wasrespoptout(indsub);
    rts     = data.responsetimes(indsub);
    
    trialtypesn = [(wastrialbiased==0) & lowcontrast  & lowstd  ...
        (wastrialbiased==0) & lowcontrast  & medstd  ...
        (wastrialbiased==0) & lowcontrast  & highstd ...
        (wastrialbiased==0) & highcontrast & lowstd ...
        (wastrialbiased==0) & highcontrast & medstd ...
        (wastrialbiased==0) & highcontrast & highstd     ];
    
    trialtypesb = [(wastrialbiased==1) & lowcontrast  & lowstd  ...
        (wastrialbiased==1) & lowcontrast  & medstd  ...
        (wastrialbiased==1) & lowcontrast  & highstd ...
        (wastrialbiased==1) & highcontrast & lowstd ...
        (wastrialbiased==1) & highcontrast & medstd ...
        (wastrialbiased==1) & highcontrast & highstd     ];
    alltrialtypes = [trialtypesn trialtypesb];
    
    % get and store accuracies (and confidence) for each condition
    respcormat                  = repmat(respcor,[1 12]);
    respcormat(~alltrialtypes)  = nan;
    accuracies                  = nanmean(respcormat);
    allaccuracies(iSub,:)       = accuracies;
    rtsmat                      = repmat(rts,[1 12]);
    rtsmat(~alltrialtypes)      = nan;
    responsetimes               = nanmean(rtsmat);
    allresponsetimes(iSub,:)    = responsetimes;
    confmat                     = repmat(confrep,[1 12]);
    confmat(~alltrialtypes)     = nan;
    confidences                 = nanmean(confmat);
    allconfidences(iSub,:)      = confidences;
    optoutmat                   = repmat(optout,[1 12]);
    optoutmat(~alltrialtypes)   = nan;
    optouts                     = optoutmat;    %optouts(~isnan(optoutmat))  = (optoutmat(~isnan(optoutmat))< 0.75);
    alloptins(iSub,:)           = 1-nanmean(optouts);
    
    % get and store bias indices
    wascuecw        = data.whichcue(indsub)== 1;
    wascueccw       = data.whichcue(indsub)==-1;
    trialtypesbycue = [ (wastrialbiased==0) & lowcontrast   & lowstd   & wascuecw  ...
        (wastrialbiased==0) & lowcontrast   & lowstd   & wascueccw ...
        (wastrialbiased==0) & lowcontrast   & medstd   & wascuecw  ...
        (wastrialbiased==0) & lowcontrast   & medstd   & wascueccw ...
        (wastrialbiased==0) & lowcontrast   & highstd  & wascuecw  ...
        (wastrialbiased==0) & lowcontrast   & highstd  & wascueccw ...
        (wastrialbiased==0) & highcontrast  & lowstd   & wascuecw  ...
        (wastrialbiased==0) & highcontrast  & lowstd   & wascueccw ...
        (wastrialbiased==0) & highcontrast  & medstd   & wascuecw  ...
        (wastrialbiased==0) & highcontrast  & medstd   & wascueccw ...
        (wastrialbiased==0) & highcontrast  & highstd  & wascuecw  ...
        (wastrialbiased==0) & highcontrast  & highstd  & wascueccw ...
        (wastrialbiased==1) & lowcontrast   & lowstd   & wascuecw  ...
        (wastrialbiased==1) & lowcontrast   & lowstd   & wascueccw ...
        (wastrialbiased==1) & lowcontrast   & medstd   & wascuecw  ...
        (wastrialbiased==1) & lowcontrast   & medstd   & wascueccw ...
        (wastrialbiased==1) & lowcontrast   & highstd  & wascuecw  ...
        (wastrialbiased==1) & lowcontrast   & highstd  & wascueccw ...
        (wastrialbiased==1) & highcontrast  & lowstd   & wascuecw  ...
        (wastrialbiased==1) & highcontrast  & lowstd   & wascueccw ...
        (wastrialbiased==1) & highcontrast  & medstd   & wascuecw  ...
        (wastrialbiased==1) & highcontrast  & medstd   & wascueccw ...
        (wastrialbiased==1) & highcontrast  & highstd  & wascuecw  ...
        (wastrialbiased==1) & highcontrast  & highstd  & wascueccw     ];
    cwstimmat  = repmat( catofstim  ,[1 24]);
    ccwstimmat = repmat(~catofstim  ,[1 24]);
    corrmat    = repmat( respcor    ,[1 24]);
    wrongmat   = repmat( 1-respcor  ,[1 24]);
    
    % compute Signal Detection Theory measures
    signalpresent  = nansum( cwstimmat  .* trialtypesbycue) + 1  ;
    signalabsent   = nansum( ccwstimmat .* trialtypesbycue) + 1  ;
    numhits        = nansum( corrmat    .* trialtypesbycue .* cwstimmat ) + 0.5;
    numfa          = nansum( wrongmat   .* trialtypesbycue .* ccwstimmat) + 0.5;
    norminvhitr    = norminv( numhits./ signalpresent);
    norminvfar     = norminv( numfa  ./ signalabsent);
    criterion      = -0.5.*(norminvhitr+norminvfar);
    dprime         = norminvhitr-norminvfar;
    
    % measure the effect that the cue has on shifting the criterion:
    % biasindex (compute also for neutral trials using random cue values)
    biasindex      = -(criterion(2:2:24)-criterion(1:2:23));
    allbiasindices(iSub,:) = biasindex;
end

end
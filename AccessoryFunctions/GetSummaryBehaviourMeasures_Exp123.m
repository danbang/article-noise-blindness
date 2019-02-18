function [allaccuracies, allconfidences, allbiasindices,alloptins] = GetSummaryBehaviourMeasures_Exp123(data)


allaccuracies  = nan(60,12);
allconfidences = nan(60,12);
allbiasindices = nan(60,12);
alloptins     = nan(60,12);

% loop through subjects
for iSub = 1:60
    
    %index which trials belong to current subject
    ind_sub   = data.subject == iSub;
    
    % define important variables
    perceptualvals  = data.pvs(ind_sub,:);
    meanofstim      = nanmean(perceptualvals,2);
    catofstim       = meanofstim>0;
    
    % contrast of stimuli
    contrast        = data.contrast(ind_sub);
    allcontrasts    = unique(contrast);
    lowcontrast     = contrast == allcontrasts(1);
    highcontrast    = contrast == allcontrasts(2);
    
    % variability of stimuli array
    targetstds      = data.targetarraystd(ind_sub);
    actualstds      = nanstd(perceptualvals,[],2);
    medianstd       = nanmedian(actualstds(targetstds>0));
    highstd         = actualstds>medianstd;
    lowstd          = targetstds == 0;
    medstd          = ~lowstd&~highstd;
    
    % cueing condition
    wastrialbiased  = data.biasedtrial(ind_sub) == 1;
    
    
    respcor = data.wasrespcor(ind_sub);
    confrep = data.confidencerep(ind_sub);
    optout  = data.wasrespoptout(ind_sub);
    
    trialtypesn = [ (wastrialbiased==0) & lowcontrast  & lowstd  ...
                    (wastrialbiased==0) & lowcontrast  & medstd  ...
                    (wastrialbiased==0) & lowcontrast  & highstd ...
                    (wastrialbiased==0) & highcontrast & lowstd  ...
                    (wastrialbiased==0) & highcontrast & medstd  ...
                    (wastrialbiased==0) & highcontrast & highstd     ];
    
    trialtypesb = [ (wastrialbiased==1) & lowcontrast  & lowstd  ...
                    (wastrialbiased==1) & lowcontrast  & medstd  ...
                    (wastrialbiased==1) & lowcontrast  & highstd ...
                    (wastrialbiased==1) & highcontrast & lowstd  ...
                    (wastrialbiased==1) & highcontrast & medstd  ...
                    (wastrialbiased==1) & highcontrast & highstd     ];
                
    alltrialtypes = [trialtypesn trialtypesb];
    
    % get and store accuracies (and confidence) for each condition
    respcormat                  = repmat(respcor,[1 12]);
    respcormat(~alltrialtypes)  = nan;
    accuracies                  = nanmean(respcormat);
    allaccuracies(iSub,:)       = accuracies;
    confmat                     = repmat(confrep,[1 12]);
    confmat(~alltrialtypes)     = nan;
    confidences                 = nanmean(confmat);
    allconfidences(iSub,:)      = confidences;
    optoutmat                   = repmat(optout,[1 12]);
    optoutmat(~alltrialtypes)   = nan;
    optouts                     = optoutmat;
    alloptins(iSub,:)           = 1-nanmean(optouts);
    
    % get and store bias indices
    wascuecw        = data.whichcue(ind_sub)== 1;
    wascueccw       = data.whichcue(ind_sub)==-1;
    trialtypesbycue = [ ...
        (wastrialbiased==0) & lowcontrast   & lowstd   & wascuecw  ...
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
    
    num_conditions = 2*2*2*3;
    cwstimmat  = repmat( catofstim  ,[1 num_conditions]);
    ccwstimmat = repmat(~catofstim  ,[1 num_conditions]);
    corrmat    = repmat( respcor    ,[1 num_conditions]);
    wrongmat   = repmat( 1-respcor  ,[1 num_conditions]);
    
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
    biasindex      = (criterion(2:2:num_conditions)-criterion(1:2:(num_conditions-1)));
    allbiasindices(iSub,:) = biasindex;
end

end

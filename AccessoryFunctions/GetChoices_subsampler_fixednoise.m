function [m_data] = GetChoices_subsampler_fixednoise(data,bestsets)
rng('default')
m_data = data;
% fit each subject
for iSub = 1:60
    indsub   = data.subject == iSub;
    
    % define important variables
    perceptualvals  = data.pvs(indsub,:);
    
    wastrialbiased  = data.biasedtrial(indsub) == 1;
    
    % contrast of stimuli
    contrast        = data.contrast(indsub);
    
    % fit to trials with low and high contrast
    indfit          = (~wastrialbiased);
    perceptualvals  = perceptualvals(indfit,:);
    tcontrast       = contrast(indfit);

    % generate subsampler choice
    numsamp = round(bestsets(iSub,3));
    IndLowCont = tcontrast < 0.5;
    rand_noise_sample = randn(size(perceptualvals,1),numsamp);
    IndNoise = rand_noise_sample.*bestsets(iSub,1).*(IndLowCont==0) + ...
               rand_noise_sample.*bestsets(iSub,2).*(IndLowCont==1);
    DV = sum(perceptualvals(:,1:numsamp)+IndNoise,2);
    acc_choice = sign(sum(perceptualvals,2)) == sign(DV);
    wh_chosen_subsamp = sign(DV);
    %% Put predictions back into data array
    ind_fitted_sub = indsub;
    ind_fitted_sub(ind_fitted_sub==1) = indfit;
    m_data.whichchosen(ind_fitted_sub) = wh_chosen_subsamp;
    m_data.wasrespcor(ind_fitted_sub) = acc_choice;
    
    
end

end
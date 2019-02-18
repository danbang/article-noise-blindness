function [] = ExhaustiveAccuracies_EnsembleModel()
    
    num_trials_cond = 4e4;
    x_all     = 3 + randn(num_trials_cond/2,1).*sqrt(8);
    x_all     = [x_all; -x_all];
    zstd0     = x_all + zeros(num_trials_cond,8);
    
    array_var4 = randn(num_trials_cond/2,8).*4;
    array_var4 = array_var4-mean(array_var4,2);
    zstd4       = x_all + [array_var4; array_var4];
    
    array_var10 = randn(num_trials_cond/2,8).*10;
    array_var10 = array_var10-mean(array_var10,2);
    zstd10      = x_all + [array_var10; array_var10];
    
    data.pvs            = [zstd0; zstd4; zstd10];
    data.targetarraystd = [zstd0(:,1).*0; zstd4(:,1).*0+4; zstd10(:,1).*0+10];
    data.contrast = mod((1:length(data.pvs))',2);
    data.contrast(data.contrast==0) = 0.15;
    data.contrast(data.contrast==1) = 0.6;

    num_subs = 1;
    num_cohs = 40;
    all_coh_low  = linspace(.1,20,num_cohs);
    all_coh_high = linspace(.1,20,num_cohs);
    
    all_vars = unique(data.targetarraystd);
    all_accs = nan(6,num_subs,num_cohs,num_cohs);
    all_confs = nan(6,num_subs,num_cohs,num_cohs);
    
    tot_count = num_subs*num_cohs*num_cohs;
    c_count = 0;
    
    for i_sub = 1:num_subs

        ind_sub = ~isnan(data.contrast);
        
        z           = data.pvs(ind_sub,:).*1;
        wh_cont     = (data.contrast(ind_sub,:) > 0.2) +1;
        sigma_var   = unique(data.targetarraystd(ind_sub,:)).*1;

        var_vec     = data.targetarraystd(ind_sub,:);
        ind_conds = [   (wh_cont==1)&(var_vec==all_vars(1)) ...
            (wh_cont==1)&(var_vec==all_vars(2)) ...
            (wh_cont==1)&(var_vec==all_vars(3)) ...
            (wh_cont==2)&(var_vec==all_vars(1)) ...
            (wh_cont==2)&(var_vec==all_vars(2)) ...
            (wh_cont==2)&(var_vec==all_vars(3)) ];
        c_accs = nan(6,1,num_cohs,num_cohs);
        c_confs = nan(6,1,num_cohs,num_cohs);
        
        parfor i_coh = 1:num_cohs
            mean_accs_allJ = nan(6,1,1,num_cohs);
            mean_confs_allJ = nan(6,1,1,num_cohs);
            for j_coh = 1:num_cohs
                c_count = c_count+1;
                
                sigma_coh = [all_coh_low(i_coh), all_coh_high(j_coh)];
                
                % maintain in Q terms needed to calcualte integral...
                [Q]= GetQ(sigma_var, sigma_coh);
                
                [post_corr] = GetProbCorrect_Mod(z,wh_cont,sigma_coh,sigma_var,Q);
                conf = .5+abs(post_corr-.5);
                p_corr = post_corr>0.5;
                mean_accs = sum(ind_conds.*p_corr)./sum(ind_conds);
                mean_confs = sum(ind_conds.*conf)./sum(ind_conds);
                mean_accs_allJ(:,1,1,j_coh) = mean_accs;
                mean_confs_allJ(:,1,1,j_coh) = mean_confs;
            end
            
            fprintf('done with another contrast')

            c_accs(:,1,i_coh,:) = mean_accs_allJ;
            c_confs(:,1,i_coh,:) = mean_confs_allJ;
            
        end
        all_accs(:,i_sub,:,:) = c_accs;
        all_confs(:,i_sub,:,:) = c_confs;
        
        
        
    end
    
    save('Simulations_Fig_SI_2.mat')

end




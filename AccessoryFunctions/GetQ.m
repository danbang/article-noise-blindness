function [Q]= GetQ(sigma_var, sigma_coh)
counter=0;
for n1= 1:length(sigma_var)
    for n2= 1: length(sigma_coh)
        counter=counter+1;
        [Q(counter).logdet_vy, Q(counter).inv_VARCOV_y, Q(counter).usefull_term, Q(counter).eff_sigma, ...
            Q(counter).eff_sigma2]= calc_needed_terms(sigma_var(n1), sigma_coh(n2));
    end
end      
end
function [p_corr] = GetProbCorrect_Mod(z,wh_cont,sigma_coh,sigma_var, Q)
% num of condition
n_trials = numel(wh_cont);
p_poscat_y = nan(n_trials,1);
for nn=1:n_trials
    
    %generate perception of z
    y = z(nn,:)+ randn(1,8).*sigma_coh(wh_cont(nn));
    
    % do inference
    [p_poscat_y(nn)]= Do_inference_INT(y, sigma_var, sigma_coh,Q);

end
is_stim_pos = mean(z,2)>0;
p_corr = (is_stim_pos==1).*p_poscat_y + (is_stim_pos==0).*(1-p_poscat_y);
end

function [p_poscat_y]= Do_inference_INT(y, sigma_var, sigma_coh,Q)

%% now the critical component--> inference.
% Lets assume that the observer knows the generation model (including the correction). 
% But she doesn't know the current category and condition.
n_tot= length(sigma_var)*length(sigma_coh);

counter=0;
log_p_poscatCond_y_analytic = zeros(1,n_tot);
log_p_negcatCond_y_analytic = zeros(1,n_tot);
for n1= 1:length(sigma_var)
    for n2= 1: length(sigma_coh)
        counter= counter+1;
        log_p_poscatCond_y_analytic(counter)= own_analytic_integral2(y.', sigma_var(n1), sigma_coh(n2),  n_tot, 1, Q(counter));
        log_p_negcatCond_y_analytic(counter)= own_analytic_integral2(y.', sigma_var(n1), sigma_coh(n2),  n_tot, 2, Q(counter));
    end
end

gmax= max([log_p_poscatCond_y_analytic log_p_negcatCond_y_analytic]);
% This is good because we later normalize. So we can reduce the same
% number from all values...
p_poscatCond_y_analytic= exp(log_p_poscatCond_y_analytic- gmax);
p_negcatCond_y_analytic= exp(log_p_negcatCond_y_analytic- gmax);

% and marginalize over condition
p_poscat_y= sum(p_poscatCond_y_analytic);
p_negcat_y= sum(p_negcatCond_y_analytic);

% normalize (because we didn't include the normalization constant)
p_poscat_y= p_poscat_y./(p_poscat_y+ p_negcat_y);

end

function log_res= own_analytic_integral2(y, sigma_var, sigma_coh,  ncond, way,Q)

sig_x2=8;
mu_x=[3 -3];
ytimessum= y.'*sum(Q.inv_VARCOV_y,2);

% log_terms...
log_const_outside_integral_begin= .5*log(2*pi*Q.eff_sigma2)- .5*log(2*pi*sig_x2)- Q.logdet_vy ...
    -(mu_x(1)^2+ sig_x2*y.'*Q.inv_VARCOV_y*y)/(2*sig_x2);
eff_mu=  (mu_x+ sig_x2*ytimessum)/Q.usefull_term;

in_exp= (eff_mu.^2)/(2*sig_x2)*Q.usefull_term;

% move this outside the integral...for numerical stability!!
maxinexp= max(in_exp); 
in_exp= in_exp-maxinexp;
log_const_outside_integral_begin= log_const_outside_integral_begin+ maxinexp;

% const_outside_integral= exp((eff_mu.^2)/(2*sig_x2)*usefull_term);
const_outside_integral= exp(in_exp);

if way==1 % integral from x=0 to x=inf
    res= .5* const_outside_integral*(1- normcdf(0,eff_mu, Q.eff_sigma)).';
else % integral from -inf to 0 is requested
    res= .5* const_outside_integral*normcdf(0,eff_mu, Q.eff_sigma).';
end

p_cond= 1/ncond;
p_cat= .5; % assumes categories equally likely
log_res= log_const_outside_integral_begin+ log(p_cond) + log(p_cat) + log(res);
end
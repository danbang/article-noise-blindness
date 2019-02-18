function [ranovatbl,rm,mauch_tbl,epsi_tbl] = RunRAnovaN_SSz(Y)
NumVars = size(Y,2);
rmc     = repmat([ 1 1 2 2],[1 2]);rmc = categorical(rmc(1:NumVars)');
sig     = repmat([ 1 2 1 2],[1 2]);sig = categorical(sig(1:NumVars)');
set     = repmat([ 1 1 1 1 2 2 2 2],[1 1]);set = categorical(set(1:NumVars)');


withtbl = table(rmc,sig,set);
withtbl.rmc_sig = withtbl.rmc .* withtbl.sig;
withtbl.rmc_set = withtbl.rmc .* withtbl.set;
withtbl.sig_set = withtbl.sig .* withtbl.set;
withtbl.rmc_sig_set = withtbl.rmc .*withtbl.sig .* withtbl.set;
for ivar = 1:NumVars, varNames{ivar} = ['Y' num2str(ivar)]; end
tbl           = array2table(Y,'VariableNames',varNames);

modelspec = ['Y1-Y' num2str(NumVars) '~1'];
rm = fitrm(tbl,modelspec,'WithinDesign',withtbl, 'WithinModel','1+rmc*sig*set');


[ranovatbl, A, C, D] = ranova(rm,'WithinModel','1+rmc*sig*set');
 mauch_tbl   = mauchly(rm,C);
 epsi_tbl    = epsilon(rm,C);

end
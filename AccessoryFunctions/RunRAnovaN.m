function [ranovatbl,rm,mauch_tbl,epsi_tbl] = RunRAnovaN(Y)
NumVars = size(Y,2);
rmc     = repmat([ 1 1 1 2 2 2 ],[1 1]);rmc = categorical(rmc(1:NumVars)');
sig     = repmat([ 1 2 3 1 2 3 ],[1 1]);sig = categorical(sig(1:NumVars)');

withtbl = table(rmc,sig);
withtbl.rmc_sig = withtbl.rmc .* withtbl.sig;
for ivar = 1:NumVars, varNames{ivar} = ['Y' num2str(ivar)]; end
tbl           = array2table(Y,'VariableNames',varNames);

modelspec = ['Y1-Y' num2str(NumVars) '~1'];
rm = fitrm(tbl,modelspec,'WithinDesign',withtbl, 'WithinModel','1+rmc*sig');

[ranovatbl, ~, C, ~] = ranova(rm,'WithinModel','1+rmc*sig');
mauch_tbl   = mauchly(rm,C);
epsi_tbl    = epsilon(rm,C);
end
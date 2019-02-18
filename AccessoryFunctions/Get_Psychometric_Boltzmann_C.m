function [CurvFit Coef r_quared Flag ] = Get_Psychometric_Boltzmann_C(x,y,iCol)

StPnt = [ 75 75 10 3.5 ];
FtTyp = fittype('(a1-a2)./(1+exp((x-xo)./dx))+a2',...
     'dependent',{'y'},'independent',{'x'},...
     'coefficients',{'a1', 'a2', 'dx', 'xo'});
 LoBound = [ -500  -500   1   -inf];
 UpBound = [  500   500    inf    inf];
 FitOpt = fitoptions( 'Method', 'nonlinearleastsquares','algorithm','trust-region', ... 
    'StartPoint',StPnt  ,'Lower',LoBound, 'Upper', UpBound,'maxfunevals',1000);
 
[CurvFit Good Output] = fit(x(:),y(:),FtTyp, FitOpt);
Flag = Output.exitflag;
Coef = [CurvFit.a1 CurvFit.a2 CurvFit.dx CurvFit.xo];
r_quared = Good.rsquare;
end
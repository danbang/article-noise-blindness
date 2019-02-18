function [CurvFit Coef r_squared Flag ] = Get_Psychometric_Boltzmann_RT(x,y,iCol)

StPnt = [ 0.5 0.5 1 3.5 ];
FtTyp = fittype('(a1-a2)./(1+exp((x-xo)./dx))+a2',...
     'dependent',{'y'},'independent',{'x'},...
     'coefficients',{'a1', 'a2', 'dx', 'xo'});
 LoBound = [ -5  -5   -inf   -inf];
 UpBound = [  5   5    inf    inf];

 FitOpt = fitoptions( 'Method', 'nonlinearleastsquares','algorithm','trust-region', ... 
    'StartPoint',StPnt  ,'Lower',LoBound, 'Upper', UpBound,'maxfunevals',1000);
 
 [CurvFit Good Output] = fit(x(:),y(:),FtTyp, FitOpt);
Flag = Output.exitflag;
Coef = [CurvFit.a1 CurvFit.a2 CurvFit.dx CurvFit.xo];
r_squared = Good.rsquare;

if isempty(iCol)
    do_plot = 0;
else
    do_plot = 1;
end
if do_plot == 1
    figure1 = figure;
    DxText = num2str((Coef(2)-Coef(1)));

    plot(x,y,'*b','DisplayName',DxText)
    hold on
    h_ = plot(CurvFit,'fit',0.99 );
    annotation(figure1,'textbox',[0.1875 0.8133 0.08929 0.06429],...
        'String',DxText);


end
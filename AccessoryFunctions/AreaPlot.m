function [h] = AreaPlot(x,y,Col,alphaVal)
    
if nargin < 2
    y = x;
    x = size(y,2);
end

if nargin < 3
    Col = [.3 .3 1];
end

if nargin < 4
    alphaVal = .7;
end

yMean = nanmean(y,1);

yStd = nanstd(y,1);

ySE = yStd/(sqrt(sum(~isnan(y(:,1)))-1));

yHigh = yMean+ySE;
yLow = yMean-ySE;

h = patch([x fliplr(x)], [(yHigh) fliplr(yLow)],Col,'edgecolor',Col,'facealpha',alphaVal);
hold on
hp = plot(x,yMean,'color',Col/2,'linewidth',0.05);
set(gca,'LineWidth',2);
box off


function [HandeBars] = BarPlotJitter(x,y,Col,Alpha)
if nargin < 2
    y = x;
    x = size(y,2);
end
if nargin < 3
    Col = [.3 .3 1];
end
if nargin < 4
    Alpha = 1;
end
if (numel(y) == 1) & (numel(x) == 1)
    yMean = y;
    HandeBars = bar(x,yMean,'facecolor',Col);
    pH = arrayfun(@(x) allchild(x),HandeBars);
    set(pH,'FaceAlpha',Alpha);
    hold on
elseif (sum(size(y) == 1) > 0) & (length(y) == length(x))
    yMean = y;
    HandeBars = bar(x,yMean,'facecolor',Col);
    pH = arrayfun(@(x) allchild(x),HandeBars);
    set(pH,'FaceAlpha',Alpha);
    hold on
else
    yMean = nanmean(y);
    yStd = nanstd(y);
    ySE = yStd/(sqrt(sum(~isnan(y(:,1)))-1));
    
    HandeBars = bar(x,yMean,'facecolor',Col);
    hold on
    jit = CreateSemiGaussianJitter(y);
    plot(jit,y,'.','color',[0.3 0.3 0.3]);
    errorbar(x,yMean, ySE,'.','color','k')
end

end




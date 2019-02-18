function [jitX] = CreateSemiGaussianJitter(X)

num_cols = size(X,2);
jitX     = zeros(size(X));
for i_col = 1:num_cols
    jitX(:,i_col) = (rand(size(jitX,1),1)-.5).*GetSemiPercentile(X(:,i_col)) + i_col;
    
end

end

function [X] = GetSemiPercentile(Y)
is_ok = ~isnan(Y);
X = Y(is_ok);
X = tiedrank(X);
X = X/(numel(X)+1);
X = norminv(X,0,1);
X = 0.5.*normpdf(X,0,1)./(normpdf(0,0,1));
Y(is_ok) = X;
end
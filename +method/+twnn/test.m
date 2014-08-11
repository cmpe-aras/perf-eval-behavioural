function [ inferredLabelsDays ] = test( pars, learnedParams, testFeatMatDays )
%TWNN Time Delayed Neural Network

% initializations
inferredLabelsDays = cell(length(testFeatMatDays),1);

% set learned parameters
w0 = learnedParams.w0;
w = learnedParams.w;
v0 = learnedParams.v0;
v = learnedParams.v;
windowSize = pars.method.twnn.windowSize;

% classify
for n=1:length(testFeatMatDays)
    
    x = testFeatMatDays{n}';
    
    % concatanate delayed inputs
    windowed_data = zeros(size(x,1), windowSize*size(x,2));
    for i=1:size(x,1)
        combinedFeatures = x(i,:);
        for j=1:floor(windowSize/2)
            prevIndex = i-j;
            nextIndex = i+j;
            
            if prevIndex > 0
                prevFeatures = x(prevIndex,:);
            else
                prevFeatures = zeros(1,size(x,2));
            end
            
            if nextIndex < size(x,2)+1
                nextFeatures = x(nextIndex,:);
            else
                nextFeatures = zeros(1,size(x,2));
            end
            
            combinedFeatures = [ prevFeatures combinedFeatures nextFeatures ];
        end
        windowed_data(i,:) = combinedFeatures;
    end
    x = windowed_data;
    
    % initializations
    H = size(w,1);
    T = size(x,1);
    est = zeros(T,1);
    
    for t=1:T
        z = zeros(H,1);
        for h=1:H
            z(h) = sigmoid(w(h,:)*x(t,:)'+w0(h));
        end
        o = v*z+v0;
        y = softmax(o);
        
        [~,c] = max(y);
        est(t) = c;
    end
    
    inferredLabelsDays{n} = est';
end

end


function [ learnedParams ] = train( curExp, pars )
%TWNN time windowed neural network

% set parameters
H = pars.method.twnn.numHiddenUnits;
n = pars.method.twnn.learningFactor;
epochs = pars.method.twnn.epochs;
windowSize = pars.method.twnn.windowSize;

% concatenate training features & labels
x = [];
classes = [];
for i=1:length(curExp.trainFeatMat)
    x = [x; curExp.trainFeatMat{i}'];
    classes = [classes; curExp.trainLabels{i}'];
end

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
K = max(classes);
dim = size(x,2);

r = zeros(size(classes,1),K);
for i=1:size(classes,1)
    r(i,classes(i)) = 1;
end

T = size(x,1);

w = 0.02*rand(H,dim)-0.01;
w0 = 0.02*rand(H,1)-0.01;

v = 0.02*rand(K,H)-0.01;
v0 = 0.02*rand(K,1)-0.01;

% backpropagation
z = zeros(H,1);

for i=1:epochs
    
    ix=randperm(T);
    for t=ix
        
        % g_h
        for h=1:H
            z(h) = sigmoid(w(h,:)*x(t,:)'+w0(h));
        end
        
        % o
        o = v*z+v0;
        
        % y
        y = softmax(o);
        
        % update equations
        dv = n*(r(t,:)'-y)*z';
        dv0 = n*(r(t,:)'-y);
        
        dw = zeros(H,dim);
        dw0 = zeros(H,1);
        for h=1:H
            dw(h,:) = n * ((r(t,:)'-y)'*v(:,h)) * z(h) * (1-z(h)) * x(t,:);
            dw0(h) = n * ((r(t,:)'-y)'*v(:,h)) * z(h) * (1-z(h));
        end
        
        v = v + dv;
        v0 = v0 + dv0;
        w = w + dw;
        w0 = w0 + dw0;
    end
    
    str = ['TWNN training epoch ', num2str(i),' completed'];
    disp(str);
end

learnedParams.w0 = w0;
learnedParams.w = w;
learnedParams.v0 = v0;
learnedParams.v = v;

end

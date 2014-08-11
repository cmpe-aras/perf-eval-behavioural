function [ curExp, pars ] = lda( curExp, pars )
%LDA Linear Discriminant Analysis
%Reduces input data dimensionality to dim

dim = pars.feature.extract.dimReduceSize;

% concatenate training features & labels
training = [];
classes = [];
for i=1:length(curExp.trainFeatMat)
    training = [training; curExp.trainFeatMat{i}'];
    classes = [classes; curExp.trainLabels{i}'];
end

numClasses = size(unique(classes),1);
numFeatures = size(training,2);

% count number of different class instances
classNums = zeros(1,numClasses);
for i=1:size(training,1)
    classNums(classes(i)) = classNums(classes(i)) + 1;
end

% initialize classdata cell array
classdata = cell(1,numClasses);
for i=1:numClasses
    classdata{i} = zeros(classNums(i),numFeatures);
end

% separate classes to classdata cell array
classIndex = ones(1,numClasses);
for i=1:size(training,1)
    classdata{classes(i)}(classIndex(classes(i)),:) = training(i,:);
    classIndex(classes(i)) = classIndex(classes(i)) + 1;
end

m = cell(1,numClasses);
S = cell(1,numClasses);
for i=1:numClasses
    m{i} = mean(classdata{i});
    S{i} = cov(classdata{i});
end

M = zeros(1,numFeatures);
for i=1:numClasses
    M = M + m{i};
end
M = M/numClasses;

Sw = zeros(numFeatures);
for i=1:numClasses
    Sw = Sw + S{i};
end

Sb = zeros(numFeatures);
for i=1:numClasses
    Sb = Sb + size(classdata{i},1)*(m{i}-M)'*(m{i}-M);
end

[eigVec, eigVal] = eig(Sw\Sb);

eigVal = diag(eigVal);
[~, ind] = sort(eigVal,1,'descend');

eigVec = eigVec(:,ind);
V = eigVec(:,1:dim);

% linear transformation on training & test features for dim. reduction
for i=1:length(curExp.trainFeatMat)
    curExp.trainFeatMat{i} = V' * curExp.trainFeatMat{i};
end
for i=1:length(curExp.testFeatMat)
    curExp.testFeatMat{i} = V' * curExp.testFeatMat{i};
end

% update parameters
pars.feature.extract.numSense = dim;

end


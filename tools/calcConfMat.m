function confmat = calcConfMat(lab1, lab2)

% Make sure labs are in 1xN form
if (size(lab1,2)~=1)
    lab1 = lab1';
end
if (size(lab2,2)~=1)
    lab2 = lab2';
end

classList = unique([lab1 lab2]);

nC = length(classList);
confmat = zeros(nC,nC);

%fix gaps
[dummy,lab1] = ismember(lab1,classList);
[dummy,lab2] = ismember(lab2,classList);

idx = sub2ind([nC, nC], lab1, lab2);

idxList = unique(idx);
for i=1:length(idxList),
    subidx = find(idx==idxList(i));
    confmat(idxList(i)) = length(subidx);
end

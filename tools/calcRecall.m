function rec = calcRecall(orgLabels, modLabels)

confMat = calcConfMat(orgLabels', modLabels');
diagConf = diag(confMat);
sumConf2 = sum(confMat,2);
idx = (sumConf2~=0);
rec = mean(diagConf(idx)./sumConf2(idx));
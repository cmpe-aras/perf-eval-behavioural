function prec = calcPrecision(orgLabels, modLabels)

confMat = calcConfMat(orgLabels', modLabels');
diagConf = diag(confMat);
sumConf1 = sum(confMat,1);
idx = (sumConf1==0);
sumConf1(idx)=1;
prec = mean(diagConf./sumConf1');

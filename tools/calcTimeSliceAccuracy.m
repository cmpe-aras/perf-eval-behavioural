function acc = calcTimeSliceAccuracy(orgLabels, modLabels)

acc = sum(orgLabels==modLabels)/length(modLabels);
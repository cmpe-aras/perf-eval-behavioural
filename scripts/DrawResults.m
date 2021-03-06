clear all
%%
directory = './Results/TWNN/RAW/21/';
%directory = './Results/HMM/';
mat_files = dir(fullfile(strcat(directory,'*.mat')));
for i=1:length(mat_files)
    name = mat_files(i).name;
    eval(['load ' directory name]);

    if strcmp( name(1:6),'ARAS_A' )
        data.actLabels{1}='IDLE';
        data.actLabels{2}='Outside';
        data.actLabels{3}='Preparing Meal';
        data.actLabels{4}='Having Meal';
        data.actLabels{5}='Washing dishes';
        data.actLabels{6}='Snack';
        data.actLabels{7}='Sleeping';
        data.actLabels{8}='Watching TV';
        data.actLabels{9}='Studying';
        data.actLabels{10}='Taking shower';
        data.actLabels{11}='Toileting';
        data.actLabels{12}='Brushing teeth';
        data.actLabels{13}='Telephone';
        data.actLabels{14}='Dressing';
    elseif strcmp( name(1:6),'ARAS_B' )
        data.actLabels{1}='IDLE';
        data.actLabels{2}='Outside';
        data.actLabels{3}='Preparing Meal';
        data.actLabels{4}='Having Meal';
        data.actLabels{5}='Snack';
        data.actLabels{6}='Sleeping';
        data.actLabels{7}='Watching TV';
        data.actLabels{8}='Studying';
        data.actLabels{9}='Taking shower';
        data.actLabels{10}='Toileting';
        data.actLabels{11}='Brushing teeth';
        data.actLabels{12}='Dressing';
    end

    [perfCell] = result.prep.frameSegmentResults(resultCell,pars);
    [P, N, EAD] = getDrawableResults(perfCell);
    
    drawP = fliplr( P ./ repmat( sum(P,2) , 1, size(P,2) ));
    drawN = fliplr(N ./ repmat( sum(N,2) , 1, size(N,2) ));
    
    name = name(1:length(name) - 4);
    
    exportFrameFig(drawP,drawN,name,data);
    drawEAD = EAD ./ repmat( sum(EAD,2) , 1, size(EAD,2) );
    exportSegmentFig(drawEAD,name,data);
end

%% Traditional Metrics Part
for i=1:length(mat_files)
    name = mat_files(i).name;
    eval(['load ' directory name]);
    
    performanceCell = calcFmeasure(resultCell,pars);
    confMat = performanceCell.confMat{1};
    
    acc = sum( diag(confMat)) / sum(sum(confMat));
    prec = diag(confMat) ./ sum(confMat,2);
    rec = diag(confMat) ./ sum(confMat,1)';
    prec(isnan(prec)) = 0;
    rec(isnan(rec)) = 0;
    fmeas = (2* prec .* rec) ./ ( prec + rec );
    fmeas(isnan(fmeas)) = 0;
    
    A(i,:) = [acc mean(prec) mean(rec) mean(fmeas)];
    leg{i} = name;
end
bar(A);
set(gca,'xticklabel',leg );


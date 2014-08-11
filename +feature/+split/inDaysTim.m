function [dataDays, pars] = inDaysTim(data, pars)

FeatIn = data.features;
LabIn = data.labels;
DatIn = data.dates;
SegIn = data.segments;

cutHour = 3;

FeatOut = {};
LabOut = {};
DatOut = {};
SegOut = {};

infoDays.firstDay = floor(DatIn(1));
infoDays.daysIdx = unique(floor(DatIn));
if (isfield(pars.feature.split,'numFolds'))
    infoDays.numDays = pars.feature.split.numFolds;
else
    infoDays.numDays = length(infoDays.daysIdx);
end

idxSaves = [];

index = 1;
for i=1:infoDays.numDays,
    
    % day starts at 'cuthour' and ends at 'cuthour'  
    idx = find((DatIn>=(infoDays.firstDay+(i)+(cutHour/24)) & DatIn<(infoDays.firstDay+(i+1)+(cutHour/24))));
    
    %drop empty days
    if (isempty(idx))
        continue;
    end
    
    %drop days which contains only one activity
%     if ( length(unique(LabIn(:,idx))) == 1 )
%         continue;
%     end
    
    FeatOut{index}= FeatIn(:,idx);
    LabOut{index} = LabIn(:,idx);
    DatOut{index} = DatIn(:,idx);
    SegOut{index} = SegIn(:,idx);
    
    index = index + 1;
end

dataDays.features = FeatOut;
dataDays.labels = LabOut;
dataDays.dates = DatOut;
dataDays.segments = SegOut;
dataDays.activityMap= data.activityMap;

% remIdxList = [];
% for i=1:length(LabOut),
%     if (length(unique(LabOut{i}))==1)
%         remIdxList = [remIdxList i];
%     end        
% end

% FeatOut(remIdxList) = [];
% LabOut(remIdxList) = [];
% DatOut(remIdxList) = [];
% SegOut(remIdxList) = [];

% Store info in pars struct
[st,i] = dbstack;
pars.feature.split.method = st(1).name; % save current function name
pars.feature.split.numFolds = length(FeatOut);
pars.feature.split.firstDay = infoDays.firstDay;
pars.feature.split.dayDatenums = infoDays.daysIdx;
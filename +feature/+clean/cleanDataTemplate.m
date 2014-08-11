function [data, pars] = cleanDataTemplate(data, pars)

%     %drop empty days
%     if (isempty(idx))
%         continue;
%     end
%     
%     %drop days which contains only one activity
%     if ( length(unique(LabIn(:,idx))) == 1 )
%         continue;
%     end
%     
% %% Correct Idle activity
% actList = unique(Labels); % 0 means IDLE activity
% if (ismember(0,actList))  % If we have IDLE activity in the data set
%     if (pars.features.extract.useIdle) % if we want to use IDLE activity
%         Labels = Labels + 1; % then we add one to every label so that IDLE activity becomes 1
%         % other activities is shifted by one
%         % We need to shift Activity_Map as well
%         actMap = [0; Activity_Map]; 
%     else
%         % If we do not want to use IDLE then we simply remove instances
%         % that have 0 as label
%         idx = find(Labels ~= 0);
%         Labels = Labels(idx);
%         FeatMat= FeatMat(:,idx);
%     end          
% end

% Use this function as a starting point for making cleanData functions

%% Input data
FeatMat= data.features;
Labels= data.labels;
Dates= data.dates;
Segments= data.segments;



%% Output data
data.features = FeatMat;
data.labels = Labels;
data.dates = Dates;
data.segments = Segments;


%% create a seperate clean function for each of these below if needed
%% Filter days without training data
%% do this in create3amDaycell
% numDays = ceil(Dates(end) - Dates(1));
% firstDay = floor(Dates(1));
% for i=1:numDays,
%     % Calculate when first day was
%     curDate = firstDay+(i-1);
% 
%     if (curDate~= floor(as.start) & curDate~= floor(as.end))
%        idxInclude = find(~ismember((floor(Dates)),curDate));
%         Labels = Labels(idxInclude);
%         FeatMat= FeatMat(:,idxInclude);
%         Dates = Dates(idxInclude);
%         Segments= Segments(idxInclude);
%     end
% end


%% Reduce the idle space to percentage% (default=10%)
% percentage = 0.1;
% throwOut = [];
% startLenLabs = length(Labels);
% startDist = histc(Labels, actList);
% if (isfield(globPars,'reduceIdle'))
%     if (globPars.reduceIdle == 1 & globPars.useIdle)
%         idx = find(Labels==1);
%         idx2 = find(idx(1:end-1)~=idx(2:end)-1);
%         startPoint = idx(1);
%         for i=1:length(idx2),
%             endPoint = idx(idx2(i));
%             len = endPoint - startPoint;
%             redLen = floor((percentage * len)/2);
%             throwOut = [throwOut (startPoint+redLen):(endPoint-redLen)];
%                         
%             startPoint = idx(idx2(i)+1);                    
%         end
%     end
%     idx = find(~ismember(1:length(Labels),throwOut));
%     
%     Labels = Labels(idx);
%     FeatMat= FeatMat(:,idx);
%     Dates = Dates(idx);
%     Segments = Segments(idx);
% 
%     endLenLabs = length(Labels);
%     endDist = histc(Labels, actList);
%     disp(sprintf('Reduced dataset size from %d to %d timeslices, by reducing idle to %d%%',startLenLabs,endLenLabs,percentage*100));
%     szDist = sprintf('%6.2f%%,',100*startDist/sum(startDist)); 
%     disp(sprintf('Distribution at start: %s',szDist));
%     szDist = sprintf('%6.2f%%,',100*endDist/sum(endDist));
%     disp(sprintf('Distribution at end: %s',szDist));
% end

%% Throw out data between xxh and yyh
% if (isfield(globPars,'startHour') & isfield(globPars,'endHour'))
%     startLenLabs = length(Labels);
%     startDist = histc(Labels, actList);
% 
%     idx = find( (Dates-floor(Dates)) >= globPars.startHour/24 & (Dates-floor(Dates)) <= globPars.endHour/24);
%     
%     Labels = Labels(idx);
%     FeatMat= FeatMat(:,idx);
%     Dates = Dates(idx);
%     Segments = Segments(idx);
%     
%     endLenLabs = length(Labels);
%     endDist = histc(Labels, actList);
%     disp(sprintf('Reduced dataset size from %d to %d timeslices, by keeping data between %dh and %dh%',startLenLabs,endLenLabs,globPars.startHour,globPars.endHour));
%     szDist = sprintf('%6.2f%%,',100*startDist/sum(startDist)); 
%     disp(sprintf('Distribution at start: %s',szDist));
%     szDist = sprintf('%6.2f%%,',100*endDist/sum(endDist));
%     disp(sprintf('Distribution at end: %s',szDist));
% end
% 


[st,i] = dbstack;
pars.features.clean.method = st(1).name; % save current function name



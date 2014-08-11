function [P, N, EAD] = getDrawableResults(perfCell,exp)
% prepares the drawable results for a given experiment
if(nargin < 2)
    exp = 1;
end

[~, nFold, nAct] = size(perfCell);
for  act = 1:nAct
    FrameStats = zeros(2,5);
    EventStats = zeros(2,5);
    for  fold = 1:nFold
        FrameStats = FrameStats + perfCell{exp,fold,act}.FrameStats;
        
        GT = perfCell{exp,fold,act}.GtActSegments;
        for i=1:numel(GT)
            if(strcmp(GT(i).type,'D'))
                EventStats(1,1) = EventStats(1,1) + 1;
            elseif(strcmp(GT(i).type,'F'))
                EventStats(1,2) = EventStats(1,2) + 1;
            elseif(strcmp(GT(i).type,'FM'))
                EventStats(1,3) = EventStats(1,3) + 1;
            elseif(strcmp(GT(i).type,'M'))
                EventStats(1,4) = EventStats(1,4) + 1;
            elseif(strcmp(GT(i).type,'C'))
                EventStats(1,5) = EventStats(1,5) + 1;
            else
                disp('Haydaa');
            end
        end
        
        OUT = perfCell{exp,fold,act}.OutActSegments;
        for i=1:numel(OUT)
            if(strcmp(OUT(i).type,'C'))
                EventStats(2,1) = EventStats(2,1) + 1;
            elseif(strcmp(OUT(i).type,'Mprime'))
                EventStats(2,2) = EventStats(2,2) + 1;
            elseif(strcmp(OUT(i).type,'FMprime'))
                EventStats(2,3) = EventStats(2,3) + 1;
            elseif(strcmp(OUT(i).type,'Fprime'))
                EventStats(2,4) = EventStats(2,4) + 1;
            elseif(strcmp(OUT(i).type,'Iprime'))
                EventStats(2,5) = EventStats(2,5) + 1;
            else
                disp('Haydaa 2');
            end
        end
    end % End folds
    
    P(act,:) = FrameStats(1,:);
    N(act,:) = FrameStats(2,:);
    
    EADAct(act,:) =  EventStats(1,:);
    EADRet(act,:) =  EventStats(2,:);
end

EAD = [EADAct EADRet(:,2:end)];
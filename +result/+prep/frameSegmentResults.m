function [perfCell] = frameSegmentResults(resultCell,pars)

[expCount, folds] = size(resultCell);
actList = pars.feature.extract.actList;

% 'FN' , 'FP' = -1 , -2
% FN ve FP'leri 8'e bolecegiz daha sonra
Outcome = {'TP','TN','I','M','D','F','Oa','Ow','Ua','Uw'};
% TODO instead of exact enumeration use Outcome array to differentiate the
% error types

perfCell = cell(expCount, folds , length(actList) );

for exp = 1:expCount
    for fold = 1:folds
        for act = actList  % for all activities calculates statistics seperately
            clear GT INF GTSegments InfSegments Segments SegResult
            GT = resultCell{exp,fold}.inputData.testLabels{1};
            INF = resultCell{exp,fold}.inferedLabelsDays{1};
            
            GT(GT ~= act) = 0;
            INF(INF ~= act) = 0;
            
            % Segments
            GTSegments =  [ GT(:,1:end-1) - GT(:,2:end) 0];
            GTSegments(GTSegments ~= 0)= 1;
            GTIdx = [ 0 find(GTSegments) length(GT)];
            
            InfSegments =  [ INF(:,1:end-1) - INF(:,2:end) 0];
            InfSegments(InfSegments ~= 0)= 1;
            InfIdx = [ 0 find(InfSegments) length(INF)];
            
            Segments = InfSegments | GTSegments;
            SegIdx = [ 0 find(Segments) length(INF)];
            
            SegResult = zeros(1,length(SegIdx)-1);
            for segId = 1 : length(SegIdx)-1
                gtSeg = GT(SegIdx(segId)+1:SegIdx(segId+1));
                infSeg = INF(SegIdx(segId)+1:SegIdx(segId+1));
                if( sum(gtSeg-infSeg) == 0 )% TP or TN
                    if( gtSeg(1) == act )
                        SegResult(segId) = 1; % TP
                    else
                        SegResult(segId) = 2; % TN
                    end
                else % FP or FN
                    if( gtSeg(1) == act )
                        SegResult(segId) = -1; % FN
                    else
                        SegResult(segId) = -2; % FP
                    end
                end
            end
            
            SegResultN = SegResult;
            for i = 1:length(SegResult)
                if( SegResult(i) >0 )
                    continue;
                end
                
                if i == 1
                    if( SegResult(i) == -2 && ( SegResult(i+1) == 2 || SegResult(i+1) == -1 ) )
                        SegResultN(i) = 3; % I
                    elseif( SegResult(i) == -1 && ( SegResult(i+1) == 2 || SegResult(i+1) == -2 ) )
                        SegResultN(i) = 5; % D
                    elseif( SegResult(i) == -2 && SegResult(i+1) == 1 )
                        SegResultN(i) = 7; % Oa
                    elseif( SegResult(i) == -1 && SegResult(i+1) == 1 )
                        SegResultN(i) = 9; % Ua
                    else
                        disp('Noluyo ya');
                    end
                    
                    continue;
                end
                
                % Trailer
                if i == length(SegResult)
                    if(  (SegResult(i-1) == 2 || SegResult(i-1) == -1 ) &&  SegResult(i) == -2 )
                        SegResultN(i) = 3; % I
                    elseif( (SegResult(i-1) == 2 || SegResult(i-1) == -2 ) &&  SegResult(i) == -1 )
                        SegResultN(i) = 5; % D
                    elseif(  SegResult(i-1) == 1 &&  SegResult(i) == -2 )
                        SegResultN(i) = 8; % Ow
                    elseif(  SegResult(i-1) == 1 &&  SegResult(i) == -1 )
                        SegResultN(i) = 10; % Uw
                    else
                        disp('Noluyo ya 3');
                    end
                    
                    break;
                end
                
                % Body
                if( SegResult(i-1) == 1 && SegResult(i) == -2 && SegResult(i+1) == 1)
                    SegResultN(i) = 4; % M
                elseif( SegResult(i-1) == 1 && SegResult(i) == -1 && SegResult(i+1) == 1)
                    SegResultN(i) =6; % F
                elseif( (SegResult(i-1) == 2 || SegResult(i-1) == -1 )&& SegResult(i) == -2 && SegResult(i+1) == 1 )
                    SegResultN(i) = 7; % Oa
                elseif( (SegResult(i-1) == 2 || SegResult(i-1) == -2 ) && SegResult(i) == -1 && SegResult(i+1) == 1)
                    SegResultN(i) = 9; % Ua
                elseif( (SegResult(i-1) == 2 || SegResult(i-1) == -1 ) && SegResult(i) == -2 && (SegResult(i+1) == 2 || SegResult(i+1) == -1 ) )
                    SegResultN(i) = 3; % I
                elseif( (SegResult(i-1) == 2 || SegResult(i-1) == -2 ) && SegResult(i) == -1 && (SegResult(i+1) == 2 || SegResult(i+1) == -2 ) )
                    SegResultN(i) = 5; % D
                elseif( SegResult(i-1) == 1 && SegResult(i) == -2 && (SegResult(i+1) == 2 || SegResult(i+1) == -1 ) )
                    SegResultN(i) = 8; % Ow
                elseif( SegResult(i-1) == 1 && SegResult(i) == -1 && (SegResult(i+1) == 2 || SegResult(i+1) == -2 ) )
                    SegResultN(i) = 10; % Uw
                else
                    disp('Noluyo ya 2');
                end
            end
            
            if (~isempty(find( unique(SegResultN) < 0,1 )))
                disp('8 kategoriye atanamadý');
            end
            
            %              1    2   3   4   5   6   7    8    9    10
            % Outcome = {'TP','TN','I','M','D','F','Oa','Ow','Ua','Uw'};
            % for each GTIdx
            % find the corresponding SegIdx
            %clear GtActSegments OutActSegments
            GtActSegments = struct([]) ;
            OutActSegments = struct([]) ;
            index = 1;
            for i=2:length(GTIdx)
                if( GT(GTIdx(i)) == 0 )
                    continue; % Activite segmenti degil
                end
                
                id = find( SegIdx <= GTIdx(i) & SegIdx > GTIdx(i-1) );
                GroundEvents = SegResultN(id-1) ;
                a = '';
                if ~isempty(find(GroundEvents == 5))
                    a = 'D';
                elseif ~isempty(find(GroundEvents == 6))
                    a = 'F';
                end
                
                GtActSegments(index).start = GTIdx(i-1)+1;
                GtActSegments(index).end = GTIdx(i);
                GtActSegments(index).type = a;
                index = index + 1;
            end

%             if(numel(GtActSegments) == 0 )
%                disp('hey');
%             end
            
            index = 1;
            for i=2:length(InfIdx)
                if( INF(InfIdx(i)) == 0 )
                    continue; % Activite segmenti degil
                end
                
                id = find( SegIdx <= InfIdx(i) & SegIdx > InfIdx(i-1) );
                OutEvents = SegResultN(id-1) ;
                a = '';
                if ~isempty(find(OutEvents == 3))
                    a = 'Iprime';
                elseif ~isempty(find(OutEvents == 4))
                    a = 'Mprime';
                end
                
                s = InfIdx(i-1)+1;
                e = InfIdx(i);
                % F lerle kesisen var mi
                for f=1:numel(GtActSegments)
                    if( strcmp( GtActSegments(f).type ,'F') )
                        sb = GtActSegments(f).start;
                        se = GtActSegments(f).end;
                        
                        if(( sb <= s  &&  se <= e  && se >= s ) || ...
                                ( s <= sb && sb <= e && se >= e ) ||...
                                ( sb <= s && se >= e  ) || ( s <= sb && se <= e) )
                            if( strcmp(a,'Mprime') )
                                a = 'FMprime';
                            else
                                a = 'Fprime';
                            end
                        end
                    end
                end
                
                if( strcmp(a,''))
                    a = 'C';
                end
                OutActSegments(index).start = s;
                OutActSegments(index).end = e;
                OutActSegments(index).type = a;
                index = index + 1;
            end
            
            % M' lerle kesisen var mi
            for f=1:numel(GtActSegments)
                s = GtActSegments(f).start;
                e = GtActSegments(f).end;
                a = GtActSegments(f).type;
                %if( ~exist('OutActSegments'))
                if(numel(OutActSegments) == 0)
                    a = 'D';
                else
                    for t=1:numel(OutActSegments)
                        if( strcmp(OutActSegments(t).type,'Mprime') || strcmp(OutActSegments(t).type,'FMprime'))
                            sb = OutActSegments(t).start;
                            se = OutActSegments(t).end;
                            
                            if(( sb <= s  &&  se <= e  && se >= s ) || ...
                                    ( s <= sb && sb <= e && se >= e ) ||...
                                    ( sb <= s && se >= e  ) || ( s <= sb && se <= e) )
                                if( strcmp(a,'F') )
                                    a = 'FM';
                                else
                                    a = 'M';
                                end
                            end
                            
                        end
                    end
                end
                
                if( strcmp(a,''))
                    a = 'C';
                end
                GtActSegments(f).type = a;
            end
            
            perfCell{exp,fold,act}.GT = GT;
            perfCell{exp,fold,act}.INF = INF;
            perfCell{exp,fold,act}.GtActSegments = GtActSegments;
            perfCell{exp,fold,act}.OutActSegments = OutActSegments;
            perfCell{exp,fold,act}.SegIdx = SegIdx;
            perfCell{exp,fold,act}.SegResult = SegResult;
            perfCell{exp,fold,act}.SegResultN = SegResultN;
            SegResultDur = SegIdx(2:end)-SegIdx(1:end-1);
            perfCell{exp,fold,act}.SegResultDur = SegResultDur;
            %              1    2   3   4   5   6   7    8    9    10
            % Outcome = {'TP','TN','I','M','D','F','Oa','Ow','Ua','Uw'};
            D = sum(SegResultDur(find(SegResultN == 5)));
            F = sum(SegResultDur(find(SegResultN == 6)));
            Ua= sum(SegResultDur(find(SegResultN == 9)));
            Uw= sum(SegResultDur(find(SegResultN == 10)));
            TP= sum(SegResultDur(find(SegResultN == 1)));
            
            I = sum(SegResultDur(find(SegResultN == 3)));
            M = sum(SegResultDur(find(SegResultN == 4)));
            Oa= sum(SegResultDur(find(SegResultN == 7)));
            Ow= sum(SegResultDur(find(SegResultN == 8)));
            TN= sum(SegResultDur(find(SegResultN == 2)));
            
            FrameStats = [D F Ua Uw TP ; I M Oa Ow TN];
            perfCell{exp,fold,act}.FrameStats = FrameStats;
        end
    end % folds
end % experiments

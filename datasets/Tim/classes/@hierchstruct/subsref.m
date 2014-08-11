function ret = subsref(hs, S)
% HIERCHSTRUCT/SUBSREF		A class for storing data from datasets in a
%                             standardized way
%
% Change History :
% Date           Time	Prog	Note
% 31-May-2007	 14:41  TvK     Created under MATLAB 7.1.0.246

% Tvk = Tim van Kasteren
% University of Amsterdam (UvA) - Intelligent Autonomous Systems (IAS) group
% e-mail : tlmkaste@science.uva.nl
% website: http://www.science.uva.nl/~tlmkaste/

switch S(1).type
case '()'
    N = length(S(1).subs);
    switch N
        case 1
            idx = S(1).subs{1};
            ret = hierchstruct(hs.as(idx), hs.events(idx));
            if (size(S,2)>1), ret = subsref(ret, S(2:end)); end;
        otherwise
            error('see : help hierchstruct/subsref;'); 
    end
case '.'
  switch S(1).subs
    case 'len'
        ret = hs.as.len;
    case 'as'
        ret = hs.as;
    case 'actstart'
        ret = hs.as.start;
    case 'actend'
        ret = hs.as.end;
    case 'actstartstr'
        ret = hs.as.startstr;
    case 'actendstr'
        ret = hs.as.endstr;
    case 'actstartdate'
        ret = hs.as.startdate;
    case 'actenddate'
        ret = hs.as.enddate;
    case 'actstarttime'
        ret = hs.as.starttime;
    case 'actendtime'
        ret = hs.as.endtime;
    case 'actid'
        ret = hs.as.id;
    case 'actIDs'
        ret = hs.as.getIDs;
    case 'getIDs'
        ret = hs.as.getIDs;
    case 'events'
        if (length(hs.events)==1)
            ret = hs.events{1};
            if (length(S)>1)
                ret = subsref(hs.events{1}, S(2:end));
            end
        else
            ret = hs.events;
            if (length(S)>1)
                ret = cell(length(hs.events),1);
                for i=1:length(hs.events),
                    ret(i) = {subsref(hs.events{i}, S(2:end))};
                end
                
            end
        end
    otherwise
        error('Invalid field name')
  end
  
case '{}'
    error('Cell array indexing not supported by actstruct objects')
end
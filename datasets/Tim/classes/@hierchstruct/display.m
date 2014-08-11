function  display(hs)

% HIERCHSTRUCT/DISPLAY		Display Function
%
%
% Note	:

% Uses :

% Change History :
% Date           Time	Prog	Note
% 31-May-2007	 14:26  TvK     Created under MATLAB 7.1.0.246

% Tvk = Tim van Kasteren
% University of Amsterdam (UvA) - Intelligent Autonomous Systems (IAS) group
% e-mail : tlmkaste@science.uva.nl
% website: http://www.science.uva.nl/~tlmkaste/

fprintf(1,'\nStart time          \tEnd time            \tID\tEvents\n'); 
fprintf(1,  '--------------------\t--------------------\t--\t------\n'); 

for i=1:hs.as.len,
    fprintf(1, '%s\t%s\t%d\t%d\n', datestr(hs.as(i).start),datestr(hs.as(i).end),hs.as(i).id,hs.events{i}.len);
end

if (hs.as.len>1)
    fprintf(1, 'Length: %d\n', hs.as.len);
end

    


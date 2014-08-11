function [hs] = hierchstruct(varargin)
% HIERCHSTRUCT/HIERCHSTRUCT		A class for storing data from datasets in a
%                             standardized way
%
%  hs = HIERCHSTRUCT(activities, events)
%
% Inputs :
% activities: in ACTSTRUCT form
% events: in SENSSTRUCT form
%
% Outputs :
%	None
%

% Uses :

% Change History :
% Date           Time	Prog	Note
% 31-May-2007	 14:21  TvK     Created under MATLAB 7.1.0.246

% Tvk = Tim van Kasteren
% University of Amsterdam (UvA) - Intelligent Autonomous Systems (IAS) group
% e-mail : tlmkaste@science.uva.nl
% website: http://www.science.uva.nl/~tlmkaste/

if nargin == 0
   hs.as = {};
   hs.events = {};
   hs = class(hs,'hierchstruct')
   return;
end

hs = struct('as',{},'events',{});

x = varargin{1};

% Handle various sorts of inputs as described in Matlab guidelines
switch class(x),
  case 'hierchstruct',
    hs = x;
    return;
  case 'actstruct',
    switch nargin,
        case 2,
           as   = varargin{1}; 
           events = varargin{2};
           
           if (as.len ~= length(events))
               error('Number of events should be equal to number of activities');
           end
        otherwise,
           error('Invalid number of input variables, please use format: actstruct(start, end, id)');           
    end,
    hs(1).as = as;
    hs(1).events = events;
  otherwise,
    error('Please check arguments to the HIERCHSTRUCT constructor...');
end;

hs = class(hs,'hierchstruct');

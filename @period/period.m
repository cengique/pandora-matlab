function obj = period(start_time, end_time)

% period - Start and end times of a period in terms of the dt of the trace
%	to which belongs.
%
% Usage:
% obj = period(start_time, end_time)
%
% Description:
%   Parameters:
%	(see below for the rest)
%		
%   Returns a structure object with the following fields:
%	start_time, end_time: Inclusive period [dt].
%
% General operations on period objects:
%   period		- Construct a new period object.
%
% Additional methods:
%	See methods('period')
%
% See also: trace, spikes, spike_shape
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/07/30

%# TODO:
%# - Maybe period should have its own dt?

if nargin == 0 %# Called with no params
   obj.start_time = 0;
   obj.end_time = 0;
   obj = class(obj,'period');
 elseif isa(start_time,'period') %# copy constructor?
   obj = start_time;
 else
   obj.start_time = start_time;
   obj.end_time = end_time;
   obj = class(obj,'period');
end


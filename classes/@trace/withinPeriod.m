function obj = withinPeriod(t, a_period, props)

% withinPeriod - Returns a trace object valid only within the given period.
%
% Usage:
% obj = withinPeriod(t, a_period, props)
%
% Description:
%
%   Parameters:
%	t: A trace object.
%	a_period: The desired period
%	props: A structure with any optional properties.
%	  useAvailable: If 1, don't stop if period not available, use maximum available.
%
%   Returns:
%	obj: A trace object
%
% See also: trace, period
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/25
% Modified:

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% TODO:
% - Relate this method by overloading an abstract class/interface duration(?) 

if ~ exist('props', 'var')
  props = struct;
end

try
    if isfield(props, 'useAvailable')
      t.data = t.data(max(1, a_period.start_time):min(a_period.end_time, length(t.data)));
    else
      t.data = t.data(a_period.start_time:a_period.end_time);
    end
catch
  err = lasterror;
  if err.identifier == 'MATLAB:badsubscript'
    error([ 'The requested period (' num2str(a_period.start_time) ', ' num2str(a_period.end_time) ...
	    ') is out of range of the trace ' t.id ' with length ' num2str(length(t.data)) ]);
  else
    rethrow(err);
  end
end

obj = t;


function [obj a_period] = withinPeriod(t, a_period, props)

% withinPeriod - Returns a trace object valid only within the given period.
%
% Usage:
% [obj a_period] = withinPeriod(t, a_period, props)
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
%	a_period: The period object, updated if useAvailable is requested.
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
    a_period = ...
        period(max(1, a_period.start_time), ...
               min(a_period.end_time, ...
                   size(t.data, 1)));
  end
  t.data = t.data(a_period.start_time:a_period.end_time, :);
catch
  err = lasterror;
  if strcmp(err.identifier, 'MATLAB:badsubscript')
    error([ 'The requested period (' num2str(a_period.start_time) ...
            ', ' num2str(a_period.end_time) ...
	    ') is out of range of the trace ' t.id ' with length ' ...
            num2str(size(t.data, 1)) '. Try prop useAvailable.']);
  else
    rethrow(err);
  end
end

obj = t;

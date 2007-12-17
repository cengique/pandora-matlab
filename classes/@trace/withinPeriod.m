function obj = withinPeriod(t, a_period)

% withinPeriod - Returns a trace object valid only within the given period.
%
% Usage:
% obj = withinPeriod(t, a_period)
%
% Description:
%
%   Parameters:
%	t: A trace object.
%	a_period: The desired period
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

try
t.data = t.data(a_period.start_time:a_period.end_time);
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


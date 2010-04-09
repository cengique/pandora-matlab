function whole_period = periodWhole(a_vc)

% periodWhole - Returns the boundaries of the whole period. 
%
% Usage:
% whole_period = periodWhole(a_vc)
%
% Description:
%
%   Parameters:
%	a_vc: A voltage_clamp object.
%
% See also: period, trace, voltage_clamp
%
% $Id: periodWhole.m 818 2007-08-28 20:28:51Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/04/08

% Copyright (c) 2010 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

whole_period = period(1, length(a_vc.v.data));

function [a_vc a_period] = withinPeriod(a_vc, a_period, props)

% withinPeriod - Returns a voltage_clamp object valid only within the given period.
%
% Usage:
% [a_vc a_period] = withinPeriod(a_vc, a_period, props)
%
% Description:
%
% Parameters:
%   a_vc: A voltage_clamp object.
%   a_period: The desired period [dt].
%   props: A structure with any optional properties.
%     useAvailable: If 1, don't stop if period not available, use maximum available.
%
% Returns:
%   a_vc: A voltage_clamp object
%   a_period: The period object, updated if useAvailable is requested.
%
% See also: trace/withinPeriod, trace, period
%
% $Id: withinPeriod.m 234 2010-10-21 22:06:52Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/03/29

% Copyright (c) 2010 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

[a_vc.i a_period] = withinPeriod(a_vc.i, a_period, props);
[a_vc.v a_period] = withinPeriod(a_vc.v, a_period, props);

num_samples = size(a_vc.v.data, 1);

% shift time values
a_vc.time_steps = a_vc.time_steps - a_period.start_time + 1;

% only time steps within new period
a_vc.time_steps = ...
    a_vc.time_steps( a_vc.time_steps > 0 & a_vc.time_steps <= num_samples);
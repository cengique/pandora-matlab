function the_period = periodPulseIni100ms(t)

% periodPulseIni100ms - Returns the first 100ms of the CIP period of 
%			cip_trace, t. 
%
% Usage:
% the_period = periodPulseIni100ms(t)
%
% Description:
%   Parameters:
%	t: A trace object.
%
%   Returns:
%	the_period: A period object.
%
% See also: period, cip_trace, trace
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/25

time_start = 1;

if isfield(t.props, 'trace_time_start')
  time_start = t.props.trace_time_start;
end

the_period = period(t.pulse_time_start, 100e-3 / t.trace.dt);

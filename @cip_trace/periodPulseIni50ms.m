function _period = periodPulseIni50ms(t)

% periodPulseIni50ms - Returns the first 50ms of the CIP period of 
%			cip_trace, t. 
%
% Usage:
% _period = periodPulseIni50ms(t)
%
% Description:
%   Parameters:
%	t: A trace object.
%
%   Returns:
%	_period: A period object.
%
% See also: period, cip_trace, trace
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/25

time_start = 1;

if isfield(t.props, 'trace_time_start')
  time_start = t.props.trace_time_start;
end

_period = period(t.pulse_time_start, 50e-3 / t.dt);

function obj = cip_trace(datasrc, dt, dy, ...
			 pulse_time_start, pulse_time_width, id, props)

% cip_trace - A trace with a current injection pulse (CIP).
%
% Usage:
% obj = cip_trace(datasrc, dt, dy,
%		  pulse_time_start, pulse_time_width, id, props)
%
% Description:
%		
% Uses the generic trace object to store an averaged spike shape. 
% Inherits the common methods defined in trace.
%
%   Parameters:
%	datasrc: A vector of data points containing the spike shape.
%	dt: Time resolution [s].
%	dy: y-axis resolution [ISI (V, A, etc.)]
%	pulse_time_start, pulse_time_width:
%		Start and width of the pulse [dt]
%	id: Identification string.
%	props: A structure with any optional properties, such as:
%		trace_time_start: Samples in the beginning to discard [dt]
%		(see trace for more)
%
%   Returns a structure object with the following fields:
%	trace, pulse_time_start, pulse_time_width, props.
%
% General methods of cip_trace objects:
%   cip_trace		- Construct a new cip_trace object.
%   plot		- Graph the cip_trace.
%   display		- Returns and displays the identification string.
%   get			- Gets attributes of this object and parents.
%   subsref		- Allows usage of . operator.
%   spikes		- Converter method to get a spikes object.
%   calc*		- Various tests.
%   getResults		- Calculates a set of tests.
%   period* 		- Period objects defined for periods of interest.
%
% Additional methods:
%   See methods('cip_trace')
%
% See also: trace, spikes, spike_shape, period
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/07/30

if nargin == 0 %# Called with no params
  trace_obj = trace;
  obj.pulse_time_start = 1;
  obj.pulse_time_width = 1;
  obj.props = struct([]);
  obj = class(obj, 'cip_trace', trace_obj);
elseif isa(datasrc, 'cip_trace') %# copy constructor?
  obj = datasrc;
else
  if ~ exist('props')
    props.trace_time_start = 1;
  end

  trace_obj = trace(datasrc, dt, dy, id, props);

  %# Adjust time variables if data is cropped
  if isfield(props, 'trace_time_start')
    pulse_time_start = pulse_time_start - props.trace_time_start + 1;
  end

  obj.pulse_time_start = pulse_time_start;
  obj.pulse_time_width = pulse_time_width;
  obj.props = props;

  obj = class(obj, 'cip_trace', trace_obj);
end


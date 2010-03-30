function a_vc = voltage_clamp(data_i, data_v, dt, di, dv, id, props)

% voltage_clamp - Voltage clamp object with current and voltage traces.
%
% Usage:
% a_vc = voltage_clamp(datasrc, dt, dy,
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
% Returns a structure object with the following fields:
%   v: Voltage trace object, 
%   i: Current trace object,
%   time_steps: Times of voltage steps.
%   v_steps: Mean voltage values before each step (including one after
%            last step)
%   i_steps: Mean current values of steady-state before each step.
%   trace: A parent trace object to inherit methods from.
%
% General methods of voltage_clamp objects:
%   voltage_clamp		- Construct a new voltage_clamp object.
%
% Additional methods:
%   See methods('voltage_clamp')
%
% See also: trace, period
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/02/05

% Copyright (c) 2007-2010 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% TODO:
% - find step times here?

if nargin == 0 % Called with no params
  a_vc = struct;
  a_vc.i = trace;
  a_vc.v = trace;
  a_vc.time_steps = [];
  a_vc.v_steps = [];
  a_vc.i_steps = [];
  a_vc = class(a_vc, 'voltage_clamp', trace);
elseif isa(data_i, 'voltage_clamp') % copy constructor?
  a_vc = data_i;
else
  if ~ exist('props', 'var')
    props = struct;
  end

  % find time and values of voltage steps and steady-state currents
  [time_steps, v_steps, i_steps] = ...
    findSteps(data_v, data_i, dt, props);

  a_vc = struct;
  a_vc.i = trace(data_i, dt, di, [ id ', I' ], props);
  a_vc.v = trace(data_v, dt, dv, [ id ', V' ], props);
  a_vc.time_steps = time_steps;
  a_vc.v_steps = v_steps;
  a_vc.i_steps = i_steps;

  a_vc = class(a_vc, 'voltage_clamp', trace([], dt, NaN, id, props));
end

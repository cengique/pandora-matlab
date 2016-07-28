function a_cc = current_clamp(data_i, data_v, dt, di, dv, id, props)

% current_clamp - Current clamp object with current and voltage traces.
%
% Usage 1:
% a_cc = current_clamp(data_i, data_v, dt, di, dv, id, props)
%
% Parameters:
%   data_i,data_v: Column vectors of I and V data traces.
%   dt: Time resolution [s].
%   di,dv: y-axis resolution for I and V [A and V, resp]
%   id: Identification string.
%   props: A structure with any optional properties, such as:
%     paramsStruct: Contains parameter names and values that are constant
%     		    for these traces.
%		trace_time_start: Samples in the beginning to discard [dt]
%		(see trace for more)
% Usage 2:
% a_cc = current_clamp(a_vc)
%
% Parameters:
%   a_vc: An existing voltage_clamp object that actually contains
%       	current-clamp data.
%
% Returns a structure object with the following fields:
%   voltage_clamp: voltage_clamp object.
%
% Description:
%   Subclasses the voltage_clamp object that uses the generic trace object
% to store voltage clamp I, V data. Inherits the common methods defined
% in voltage_clamp and trace.
%
% Example:
% >> a27h_cc = ...
%      current_clamp(abf2voltage_clamp(abf_file, '', struct('iSteps', 1)));
% (iSteps must be passed to abf2voltage_clamp for analyzing current
% steps)
%
% General methods of current_clamp objects:
%   current_clamp		- Construct a new current_clamp object.
%
% Additional methods:
%   See methods('current_clamp')
%
% See also: trace, period
%
% $Id: current_clamp.m 234 2010-10-21 22:06:52Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/02/05

% Copyright (c) 2007-2011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

props = defaultValue('props', struct);

if nargin == 0 % Called with no params
  a_cc = struct;
  a_cc = class(a_cc, 'current_clamp', voltage_clamp);
elseif isa(data_i, 'current_clamp') % copy constructor?
  a_cc = data_i;
elseif isa(data_i, 'voltage_clamp') % copy from vc object
  a_cc = struct;
  a_cc = class(a_cc, 'current_clamp', data_i);
  a_cc = updateSteps(setProp(a_cc, 'iSteps', 1));
else
  a_cc = struct;
  a_cc = class(a_cc, 'current_clamp', ...
               voltage_clamp(data_i, data_v, dt, di, dv, id, ...
                             mergeStructs(props, ...
                                          struct('iSteps', 1))));
  
end
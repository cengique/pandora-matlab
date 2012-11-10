function a_cc = trace2cc(a_tr, cip_times, cip_vals, props) 

% trace2cc - Converts a single-column trace vector into a current_clamp object.
%
% Usage:
% a_cc = trace2cc(a_tr, cip_times, cip_vals, props) 
%
% Parameters: 
%   a_tr: A trace object.
%   cip_times: Start and end times of current injection [ms].
%   cip_vals: A vector of current injection (CIP) parameter values 
%	[nA]. The number of the elements in this vector must 
% 	be capable of dividing the length of the trace evenly.
%   props: A structure with any optional properties.
%     Ihold: [nA] Specifies holding current if different than first step value.
%     dt: Simulation time step of recorded data [s]. Use dt*nout of XPP (Default=1e-3).
%     paramsVary: Structure with variable name associated with an
%     		array. If only one value is given cip_vals, use the
%     		values for this variable for the multiple trials found in file.
%     (others are passed to current_clamp)
%
% Returns:
%   a_cc: A current_clamp object.
%
% Description:
%
% Example:
% The following creates a current clamp object from the cur_inj45pA_t
% trace object, a current step of holding at -10 to 0 nA at times 50 and
% 500 ms. The props 'threshold' and 'paramsStruct' are passed to current_clamp.
% >> a_cc = trace2cc(cur_inj45pA_t, [50 500], 0, ...
%                struct('threshold', 10, 'Ihold', -10, 'paramsStruct', ...
%                       struct('gL_nS', 7, 'gKs_nS', 50.1, 'Cm_pA', 5)));
%
% See also: plotXPPparamRanges, current_clamp
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/03/04

% Copyright (c) 2011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% http://opensource.org/licenses/afl-3.0.php.

props = defaultValue('props', struct);

% if not varying CIP, take variable values from struct
if isfield(props, 'paramsVary')
  param_names = fieldnames(props.paramsVary);
  num_vals = 1;
  for param_num = 1:length(param_names)
    param_vals = props.paramsVary.(param_names{param_num});
    num_vals = num_vals * length(param_vals);
  end
  cip_vals = repmat(cip_vals, 1, num_vals);
end

num_traces = length(cip_vals);
num_allpts = size(a_tr.data, 1);
num_onepts = num_allpts / num_traces;
data = reshape(a_tr.data, num_onepts, num_traces);

I_hold = getFieldDefault(props, 'Ihold', cip_vals(1));

current_steps = ...
    get(makeIdealClampV([cip_times num_onepts * a_tr.dt * 1e3], ...
                        I_hold, cip_vals, I_hold, a_tr.dt * 1e3, ...
                        a_tr.id), 'data');

a_cc = ...
    current_clamp(current_steps, data, a_tr.dt, 1e-9, a_tr.dy, ...
                  [ a_tr.id ' CIPs [' sprintf('%.2f ', cip_vals) ']' ], ...
                  mergeStructs(props, struct));

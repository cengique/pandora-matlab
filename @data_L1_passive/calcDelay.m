function [delay] = calcDelay(pas, props)

% calcDelay - Calculates an estimate of current delay after voltage pulse.
%
% Usage:
% [delay] = calcDelay(pas, props)
%
% Parameters:
%   pas: A data_L1_passive object.
%   props: Structure with optional properties.
%     stepNum: Voltage pulse to be considered (default=1).
%     traceNum: Trace number ti be analyzed (default=1).
%
% Returns:
%   delay: [ms].
%
% Description:
%
% See also: 
%
% $Id: calcDelay.m 896 2007-12-17 18:48:55Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/01/04

% Copyright (c) 2011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 % Called with no params
  error('Need object.');
end

props = defaultValue('props', struct);
trace_num = getFieldDefault(props, 'traceNum', 1);
step_num = getFieldDefault(props, 'stepNum', 1);

start_dt = pas.data_vc.time_steps(step_num);
dt = pas.data_vc.trace.dt * 1e3;

first_ms = 2;
t_begin = first_ms/dt;

delay = (find_change(pas.data_vc.i.data(:, trace_num), ...
                     start_dt - min(t_begin, start_dt - 1), 5) - start_dt) * dt;

function t_change = find_change(data, idx_start, num_mV, dt)
% find starting baseline
  v_start = mean(data(idx_start:(idx_start + t_begin)));
  v_start_sd = std(data(idx_start:(idx_start + t_begin)));
  
  % find beginning of step (used to be: 5*v_start_sd)
  t_change = find(abs(data(idx_start:end) - v_start) > 5*v_start_sd); 
  if ~ isempty(t_change)
    t_change = idx_start - 1 + t_change(1);
  end % else return empty
end


end

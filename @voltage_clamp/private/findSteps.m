function [time_steps, v_steps, i_steps] = ...
    findSteps(data_v, data_i, dt, props)

% findSteps - Find time and magnitude of voltage steps and corresponding average steady-state currents.
%
% Usage:
% [time_steps, v_steps, i_steps] = 
%   findSteps(data_v, data_i, dt, props)
%
% Parameters:
%   data_v: Voltage traces (assumed [mV]),
%   data_i: Current traces (assumed [nA]),
%   dt: Time step [ms],
%   props: A structure with any optional properties.
%     timeBefore: Time to skip before step [ms] (default=2).
%     timeAvg: Time to average [ms] (default=2).
%		
% Returns:
%   time_steps: Times of voltage steps.
%   v_steps: Mean voltage values before each step (including one after
%            last step)
%   i_steps: Mean current values of steady-state before each step.
%
% Description:
%
% Example:
% >> a_vc = abf_voltage_clamp('data-dir/cell-A.abf')
% >> plotFigure(findSteps(a_vc, 2, 'I/V curve'))
%
% See also: voltage_clamp, plot_abstract, plotFigure, plot_superpose
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/03/11

% TODO: 

if ~ exist('props', 'var')
  props = struct;
end

time = (0:(size(data_i, 1)-1))*dt;
num_mags = size(data_v, 2);

% 2 ms delay after steps to look for next
step_delay = getFieldDefault(props, 'timeBefore', 2) / dt; 
step_dur = getFieldDefault(props, 'timeAvg', 2) / dt; 

% Start from beginning to find all voltage steps. Use 1st and 2nd
% magnitudes if available because sometimes voltage steps can be missed if
% they remain at same voltage for one step)
time_steps = findTimes(1, 1 - step_delay);
time_steps2 = findTimes(2, 1 - step_delay);

% use whichever found more steps 
if length(time_steps2) > length(time_steps)
  time_steps = time_steps2;
end

num_steps = length(time_steps);

% for each step, find mean voltage and current
v_steps = repmat(NaN, num_steps + 1, num_mags);
i_steps = repmat(NaN, num_steps, num_mags);
for step_num = 1:num_steps
  step_time = time_steps(step_num);
  step_range = ...
      max(step_time - step_delay - step_dur, 1) : (step_time - step_delay);
  v_steps(step_num, :) = ...
       mean(data_v( step_range, : ));
  i_steps(step_num, :) = ...
      mean(data_i( step_range, : ));
end

% get the ending voltage
data_len = size(data_v, 1);
step_range = ...
    min(step_time + step_delay, data_len) : ...
    min(step_time + 2 * step_delay, data_len);

v_steps(step_num + 1, :) = ...
    mean(data_v( step_range, : ));

function time_steps = findTimes(mag_num, time_change)
  time_steps = [];
  while ~ isempty(time_change)
    time_change = findChange(data_v(:, min(mag_num, num_mags)), time_change + step_delay, 3, dt); 
    time_steps = [ time_steps, time_change ];
  end
end
end

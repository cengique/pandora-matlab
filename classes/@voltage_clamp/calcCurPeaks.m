function a_vc = calcCurPeaks(a_vc, step_num, props)

% calcCurPeaks - Find current peaks during a voltage step.
%
% Usage:
% a_vc = calcCurPeaks(a_vc, step_num, props)
%
% Parameters:
%   a_vc: A voltage clamp object.
%   step_num: 1 for prestep, 2 for the first step, 3 for next, etc (default=2).
%   props: A structure with any optional properties.
%     pulseRange: Use this range for finding peaks [dt].
%     pulseStartRel: Time to start relative to the step beginning (default=+.3)
%       [ms]. If it has two elements, first one  specifies the voltage step .
%     pulseEndRel: Time to end relative to the step end (default=-.3) [ms]. Like
%       pulseStartRel, allows specifying voltage step.
%     avgAroundMs: If given, after finding a peak, average +/- ms around
%     	it to reduce noise.
%		
% Returns:
%   a_vc: Updated voltage_clamp object that contains props.iPeaks.
%
% Description:
%
% Example:
% >> a_vc = calcCurPeaks(a_vc, 2)
%
% See also: voltage_clamp, findSteps
%
% $Id: calcCurPeaks.m 497 2011-06-24 18:44:14Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/03/30

% TODO: 
% - also return peak times.
  
props = defaultValue('props', struct);
step_num = defaultValue('step_num', 2);
num_vsteps = size(a_vc.i_steps, 2);
dt = get(a_vc, 'dt');

assert(step_num > 1);

% by default, don't take first .3 and last 3 ms of period

% select the initial part before v-dep currents get activated
rel_start = getFieldDefault(props, 'pulseStartRel', [+.3]); % [ms]

if length(rel_start) > 1
  start_step_num = rel_start(1);
  rel_start = rel_start(2);
else
  start_step_num = step_num - 1;
end

rel_end = getFieldDefault(props, 'pulseEndRel', [-3]); % [ms]

if length(rel_end) > 1
  end_step_num = rel_end(1);
  rel_end = rel_end(2);
else
  end_step_num = step_num;
end

if start_step_num < 1
  start_time = 0;
else
  start_time = a_vc.time_steps(start_step_num);
end

if end_step_num > length(a_vc.time_steps)
  end_time = size(a_vc.i.data, 1);
else
  end_time = a_vc.time_steps(end_step_num);
end

range_maxima = ...
    getFieldDefault(props, 'pulseRange', ...
                           [start_time + ...
                    round(rel_start * 1e-3 / dt), ...
                    end_time + ...
                    round(rel_end * 1e-3 / dt)]);
range_vc = ...
    withinPeriod(a_vc, period(range_maxima(1), range_maxima(2)), ...
                 struct('useAvailable', 1));

i_peaks = repmat(NaN, 1, num_vsteps);
for vstep_num = 1:num_vsteps
  % find direction of peaks for each voltage step
  %steps_mag = mean(range_vc.i.data(:, vstep_num));
% $$$   if steps_mag > 0
% $$$     f = @max;
% $$$   else
% $$$     f = @min;
% $$$   end

  % compare magnitude of min and max peaks; mean may give wrong results
  % if averaged across a long duration
  [min_val min_idx]  = ...
      min(range_vc.i.data(:, vstep_num), [], 1);
  [max_val max_idx]  = ...
      max(range_vc.i.data(:, vstep_num), [], 1);

  if abs(min_val) > abs(max_val)
    val = min_val; idx = min_idx;
  else
    val = max_val; idx = max_idx;
  end  

  if isfield(props, 'avgAroundMs')
    avgDts = round(props.avgAroundMs * 1e-3 / dt);
    i_peaks(vstep_num) = ...
        mean(range_vc.i.data(idx + ...
                             [max(-avgDts, -(idx - 1)):min(avgDts, ...
                                                      diff(range_maxima) ...
                                                      - idx)], vstep_num));
  else
    i_peaks(vstep_num) = val;
  end
end
a_vc = setProp(a_vc, 'iPeaks', i_peaks);

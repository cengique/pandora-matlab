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
% $Id: calcCurPeaks.m 79 2010-03-30 15:55:11Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/03/30

% TODO: 
% - also return peak times.
  
props = defaultValue('props', struct);
step_num = defaultValue('step_num', 2);
num_vsteps = size(a_vc.i_steps, 2);


assert(step_num > 1);

% don't take last 3 ms of period
range_vc = ...
    withinPeriod(a_vc, period(a_vc.time_steps(step_num - 1), ...
                              a_vc.time_steps(step_num) - 3e-3 / get(a_vc, 'dt')));

for vstep_num = 1:num_vsteps
  % find direction of peaks for each voltage step
  steps_mag = mean(a_vc.i.data(:, vstep_num));

  if steps_mag > 0
    f = @max;
  else
    f = @min;
  end
  
  i_peaks(vstep_num) = ...
      feval(f, range_vc.i.data(:, vstep_num), [], 1);
end
a_vc = setProp(a_vc, 'iPeaks', i_peaks);

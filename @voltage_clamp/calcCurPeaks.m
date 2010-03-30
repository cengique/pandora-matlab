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

% find direction of peaks
steps_mag = mean(a_vc.i_steps(step_num, :));

if steps_mag > 0
  f = @max;
else
  f = @min;
end

assert(step_num > 1);

range_vc = ...
    withinPeriod(a_vc, period(a_vc.time_steps(step_num - 1), ...
                              a_vc.time_steps(step_num)));

a_vc = setProp(a_vc, 'iPeaks', ...
                     feval(f, range_vc.i.data, [], 1));

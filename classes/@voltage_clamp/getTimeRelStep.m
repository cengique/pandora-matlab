function rel_time = getTimeRelStep(a_vc, step_num, rel_time, props)

% getTimeRelStep - Return time relative to a voltage step.
%
% Usage:
% rel_time = getTimeRelStep(a_vc, step_num, rel_time, props)
%
% Parameters:
%   a_vc: A voltage_clamp object.
%   step_num: Relative to this voltage step. 1 for start of trace,
%   	2 for first voltage change, and so on.
%   rel_time: One or more time values in a vector [ms].
%   props: A structure with any optional properties.
%		
% Returns:
%   rel_time: Time vector from start of trace [dt].
%
% Description:
%
% Example:
% Select [-10, 50] ms range from step 1 into a new VC object.
% >> new_vc = withinPeriod(a_vc, period(getTimeRelStep(a_vc, 1, [-10 50])))
%
% See also: voltage_clamp
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/18

if ~ exist('props', 'var')
  props = struct;
end

rel_time = ...
    round(rel_time * 1e-3/ get(a_vc, 'dt') );
if step_num > 1
  rel_time = ...
      rel_time + a_vc.time_steps(step_num - 1);
end
  

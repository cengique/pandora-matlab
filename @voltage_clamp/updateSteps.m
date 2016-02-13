function a_vc = updateSteps(a_vc, props)

% updateSteps - Update voltage step time and magnitude info.
%
% Usage:
% a_vc = updateSteps(a_vc, props)
%
% Parameters:
%   a_vc: A voltage_clamp object.
%   props: A structure with any optional properties.
%		
% Returns:
%   a_vc: Updated object.
%
% Description:
%   Called by simModel.
%
% Example:
%
% See also: voltage_clamp
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/18

if ~ exist('props', 'var')
  props = struct;
end

% recalculate values of step steady-state currents
[time_steps, v_steps, i_steps] = ...
    findSteps(a_vc.v.data, a_vc.i.data, ...
              get(a_vc, 'dt') * 1e3, mergeStructs(props, get(a_vc, 'props')));

a_vc.time_steps = time_steps;
a_vc.v_steps = v_steps;
a_vc.i_steps = i_steps;
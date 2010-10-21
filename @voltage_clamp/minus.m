function sub_vc = minus(left_vc, right_vc, props)

% minus - Subtract voltage clamp object right_vc from left_vc.
%
% Usage:
% sub_vc = minus(left_vc, right_vc, props)
%
% Parameters:
%   left_vc, right_vc: voltage_clamp objects.
%   props: A structure with any optional properties.
%		
% Returns:
%   sub_vc: voltage_clamp object with subtracted current and 
%     voltage of left_vc.
%
% Description:
%   Also returns the subtracted voltage trace in props.sub_v for visual
% inspection of match between the two voltage traces.
%
% Example:
% >> sub_vc = minus(vc1, vc2)
% OR
% >> sub_vc = vc1 - vc2;
% plot the subtracted voltage clamp
% >> plot(sub_vc)
% plot the subtracted voltage trace, too
% >> plot(sub_vc.props.sub_v)
%
% See also: voltage_clamp
%
% $Id: minus.m 137 2010-07-23 01:35:01Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/03/10

if ~ exist('props', 'var')
  props = struct;
end

sub_vc = set(left_vc, 'i', left_vc.i - right_vc.i);
sub_vc = set(sub_vc, 'id', ...
                     ['(' get(left_vc, 'id') ' - ' get(right_vc, 'id') ')' ]);

% recalculate values of step steady-state currents
[time_steps, v_steps, i_steps] = ...
    findSteps(sub_vc.v.data, sub_vc.i.data, get(sub_vc, 'dt') * 1e3, props);

sub_vc.i_steps = i_steps;

% set a new property with the subtracted voltage trace if anybody wants
% to see discrepancies between the two voltage clamp recordings
sub_vc = setProp(sub_vc, 'sub_v', left_vc.v - right_vc.v);
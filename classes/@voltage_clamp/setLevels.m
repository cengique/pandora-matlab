function a_vc = setLevels(a_vc, levels, props)

% setLevels - Choose which voltage and current step levels to keep.
%
% Usage:
% a_vc = setLevels(a_vc, levels, props)
%
% Parameters:
%   a_vc: A voltage_clamp object.
%   levels: Only keep these voltage and current level indices.
%   props: A structure with any optional properties.
%		
% Returns:
%   a_vc: A voltage_clamp object that contains only the selected levels.
%
% Description:
%
% Example:
% >> a_vc = setLevels(a_vc, 1:3) % only select the first few levels
%
% See also: voltage_clamp
%
% $Id: setLevels.m 234 2010-10-21 22:06:52Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/03/30

% TODO: 

if ~ exist('props', 'var')
  props = struct;
end

% select data levels
a_vc.v.data = a_vc.v.data(:, levels);
a_vc.i.data = a_vc.i.data(:, levels);

% update calculated values
a_vc.i_steps = a_vc.i_steps(:, levels);
a_vc.v_steps = a_vc.v_steps(:, levels);

a_vc = set(a_vc, 'id', [ get(a_vc, 'id') '; levels: [' ...
                    sprintf('%d ', levels) ']' ] );

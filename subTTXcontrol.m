function sub_vc = subTTXcontrol(vc1, vc2, title_str, props)

% subTTXcontrol - Subtract voltage clamp object vc2 from vc1.
%
% Usage:
% sub_vc = subTTXcontrol(vc1, vc2, title_str, props)
%
% Parameters:
%   vc1, vc2: voltage_clamp objects.
%   title_str: (Optional) Text to appear in the plot title.
%   props: A structure with any optional properties.
%		
% Returns:
%   sub_vc: Subtracted voltage clamp object.
%
% Description:
%
% Example:
% >> sub_vc = ...
%    subTTXcontrol(vc_control, vc_ttx, 'Control - TTX')
%
% See also: voltage_clamp
%
% $Id: subTTXcontrol.m 79 2010-03-30 15:55:11Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/03/12

if ~ exist('props', 'var')
  props = struct;
end

if ~ exist('title_str', 'var')
  title_str = 'Control - TTX';
end

cell_name_1 = get(vc1, 'id');
cell_name_2 = get(vc2, 'id');

% subtract
sub_vc = vc1 - vc2;
sub_cell_name = [ cell_name_1 ' - ' cell_name_2 ', I'];

i_p1 = plot_abstract(vc1, '', struct('onlyPlot', 'i', 'noLegends', 1));
axis_limits = i_p1.props.axisLimits;

% plot all
plotFigure(...
  plot_stack({...
    plot_abstract(sub_vc, '', struct('onlyPlot', 'v', 'noLegends', 1)), ...
    set(i_p1, ...
        'axis_labels', {'time [ms]', [ cell_name_1 ', I_1 [nA]' ]}), ...
    set(plot_abstract(vc2, '', struct('onlyPlot', 'i', 'noLegends', 1)), ...
        'axis_labels', {'time [ms]', [ cell_name_2 ', I_2' ]}), ...
    set(plot_abstract(sub_vc, '', struct('onlyPlot', 'i', 'noLegends', 1)), ...
        'axis_labels', {'time [ms]', [ [ 'I_1-I_2' ] ]})}, ...
             axis_limits, 'y', [ sub_cell_name ': ' title_str ], ...
             mergeStructs(props, ...
                          struct('titlesPos', 'none', ...
                                 'xLabelsPos', 'bottom', ...
                                 'fixedSize', [4 5], 'noTitle', 1))));

% plot superposed IV plots
plotFigure(...
  plot_superpose({...
    plotSteadyIV(vc1, 2, '', struct('label', 'control', 'noTitle', 1, ...
                                    'fixedSize', [2.5, 2])), ...
    plotSteadyIV(vc2, 2, '', struct('label', 'TTX')), ...
    plotSteadyIV(sub_vc, 2, '', struct('label', 'sub'))}));
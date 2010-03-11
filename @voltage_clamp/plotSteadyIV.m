function a_p = plotSteadyIV(a_vc, step_num, title_str, props)

% plotSteadyIV - Plot the I/V curve at the end of a voltage step.
%
% Usage:
% a_p = plotSteadyIV(a_vc, step_num, title_str, props)
%
% Parameters:
%   a_vc: A voltage clamp object.
%   step_num: 1 for prestep, 2 for the first step, 3 for 2nd, etc.
%   title_str: (Optional) Text to appear in the plot title.
%   props: A structure with any optional properties.
%     quiet: If 1, only use given title_str.
%     label: add this as a line label to be used in superposed plots.
%		
% Returns:
%   a_p: A plot_abstract object.
%
% Description:
%   Can be superposed with other I/V plot objects (see plot_superpose).
%
% Example:
% >> a_vc = abf_voltage_clamp('data-dir/cell-A.abf')
% >> plotFigure(plotSteadyIV(a_vc, 2, 'I/V curve'))
%
% See also: voltage_clamp, plot_abstract, plotFigure, plot_superpose
%
% $Id: plotSteadyIV.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/03/10

% TODO: 

if ~ exist('props', 'var')
  props = struct;
end

if isfield(props, 'label')
  plot_label = props.label;
else
  plot_label = 'data';
end

dt = get(a_vc, 'dt');

data_i = get(a_vc.i, 'data');
data_v = get(a_vc.v, 'data');
cell_name = get(a_vc, 'id');
time = (0:(size(data_i, 1)-1))*dt;

if isfield(props, 'quiet')
  all_title = properTeXLabel(title_str);
else
  all_title = ...
      properTeXLabel([ 'I/V curve: ' cell_name title_str ]);
end

% find step start
t_step_start = findChange(data_v(:, 1), 1, 3);
  
% find step ends
t_step_end = findChange(data_v(:, 1), t_step_start + 20 / dt, 3);

% calc prepulse steady-state values
range_prepulse = (t_step_start - 10 / dt) : (t_step_start - 8 / dt);
v_prepulse = ...
    mean(data_v( range_prepulse, : ));
i_prepulse = ...
    mean(data_i( range_prepulse, : )); % Do for each current separately

% calc step steady-state values
range_steps = (t_step_end - 5 / dt) : (t_step_end - 1 / dt);
v_steps = ...
    mean(data_v( range_steps, : ), 1);

i_steps = ...
    mean(data_i( range_steps, : ), 1);

if step_num == 1
  % plot prepulse drift
  a_p = ...
    plot_abstract(...
      {v_steps, i_prepulse}, ...
      {'step voltage [mV]', 'prepulse current [nA]'}, ...
      all_title, {plot_label}, 'plot', ...
      mergeStructs(props, ...
                   struct('tightLimits', 1, ...
                          'plotProps', struct('LineWidth', 2))));
elseif step_num == 2
  a_p = ...
    plot_abstract(...
      {v_steps, i_steps}, ...
      {'step voltage [mV]', 'current [nA]'}, ...
      all_title, {plot_label}, 'plot', ...
      mergeStructs(props, ...
                   struct('tightLimits', 1, ...
                          'plotProps', struct('LineWidth', 2))));  
else
  error('step_num > 2 not implemented.')
end

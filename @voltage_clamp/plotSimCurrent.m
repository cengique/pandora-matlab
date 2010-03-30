function a_p = plotSimCurrent(a_vc, f_I_v, props)

% plotSimCurrent - Simulate voltage clamp current on a model channel and superpose on data.
%
% Usage:
% a_p = plotSimCurrent(a_vc, f_I_v, props)
%
% Parameters:
%   a_vc: A voltage_clamp object.
%   f_I_v: param_func object representing the model channel. 
%   props: A structure with any optional properties.
%     delay: If given, use as voltage clamp delay [ms].
%     levels: Only plot these voltage level indices.
%		
% Returns:
%   a_p: A plot_abstract object.
%
% Description:
%
% Example:
% >> plotFigure(plotSimCurrent(a_vc))
%
% See also: param_I_v, param_func, plot_abstract
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/03/29

% TODO: 

if ~ exist('props', 'var')
  props = struct;
end

dt = get(a_vc, 'dt');

data_i = get(a_vc.i, 'data');
data_v = get(a_vc.v, 'data');
cell_name = get(a_vc, 'id');
time = (0:(size(data_i, 1)-1))*dt;

% choose the range
period_range = period(round(a_vc.time_steps(1) - 10 / dt), ...
                      round(a_vc.time_steps(2) + 10 / dt));
range_steps = array(period_range);

% restrict the a_vc to given range to prepare for subtraction
[a_range_vc period_range] = ...
    withinPeriod(a_vc, period_range, struct('useAvailable', 1)); 

% integrate current for each voltage step
model_vc = simModel(a_range_vc, f_I_v, props); 
    
% nicely plot current and voltage trace in separate axes  
line_colors = lines(length(a_vc.v_steps)); %hsv(length(v_steps));

% stacked plot
% $$$ a_p = ...
% $$$   plot_stack({...
% $$$     plot_abstract({time, data_i}, {'time [ms]', 'I_{data} [nA]'}, ...
% $$$                   'data', {}, 'plot', struct('ColorOrder', line_colors)), ...
% $$$     plot_abstract({time(range_steps), Isim}, {'time [ms]', 'I_{sim} [nA]'}, ...
% $$$                   'model', {}, 'plot', struct('ColorOrder', line_colors)), ...
% $$$     plot_abstract({time, data_v}, {'time [ms]', 'V_m [mV]'}, ...
% $$$                   'all currents', {}, 'plot', struct('ColorOrder', line_colors))}, ...
% $$$              [min(time(range_steps)) max(time(range_steps)) NaN NaN], ...
% $$$              'y', [ cell_name ], ...
% $$$              struct('titlesPos', 'none', 'xLabelsPos', 'bottom', ...
% $$$                     'fixedSize', [4 4], 'noTitle', 1));

a_p = ...
  plot_stack({...
    plot_abstract(a_range_vc, '', ...
                  struct('label', 'data', 'onlyPlot', 'i')), ...
    plot_abstract(model_vc, '', ...
                  struct('label', 'sim', 'onlyPlot', 'i')), ...
    plot_abstract(a_range_vc, '', struct('onlyPlot', 'v'))}, ...
             [time(period_range.start_time) ...
              time(period_range.end_time) NaN NaN], ...
             'y', [ cell_name ], ...
             struct('titlesPos', 'none', 'xLabelsPos', 'bottom', ...
                    'fixedSize', [4 4], 'noTitle', 1));

end

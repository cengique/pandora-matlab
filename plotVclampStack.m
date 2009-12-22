function plot_handle = plotVclampStack(time, data_i, data_v, cell_name, props)

% plotVclampStack -  Vertical stack plot of voltage-clamp I and V traces.
%
% Usage:
% plot_handle = plotVclampStack(time, data_i, data_v, cell_name, props)
%
% Parameters:
%   time: Time vector for measurements [ms],
%   data_i: Current traces [nA],
%   data_v: Voltage traces [mV],
%   cell_name: A label for cell plotted.
%   props: A structure with any optional properties.
%     (passed to plot_stack)
%		
% Returns:
%   plot_handle: Figure handle.
%
% Description:
%
% Example:
% >> [time, dt, data_i, data_v, cell_name] = ...
%    loadVclampAbf('data-dir/cell-A.abf')
% >> plotVclampStack(time, data_i, data_v, cell_name);
%
% See also: loadVclampAbf, plot_stack
%
% $Id: plotVclampStack.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2009/12/17

% nicely plot current and voltage trace in separate axes
  plot_handle = ...
      plotFigure(...
        plot_stack({...
          plot_abstract({time, data_i}, {'time [ms]', 'I [nA]'}, ...
                        'all currents', {}, 'plot', struct), ...
          plot_abstract({time, data_v}, {'time [ms]', 'V_m [mV]'}, ...
                        'all currents', {}, 'plot', struct)}, ...
                   [], 'y', [ cell_name ': Raw data' ], ...
                   mergeStructs(props, ...
                                struct('titlesPos', 'none', ...
                                       'xLabelsPos', 'bottom', ...
                                       'fixedSize', [4 3], 'noTitle', 1))));
  
function [time, dt, sub_data_i, sub_data_v, cell_name_1, cell_name_2] = ...
      sub2VclampAbf(filename1, filename2, title_str, props)

% sub2VclampAbf - Subtract  ABF filename2 from filename1.
%
% Usage:
% [time, dt, sub_data_i, sub_data_v, cell_name_1, cell_name_2] = 
%   sub2VclampAbf(filename, props)
%
% Parameters:
%   filename: Full path to filename.
%   props: A structure with any optional properties.
%		
% Returns:
%   time: Time vector for measurements [ms],
%   dt: Time step [ms],
%   sub_data_i: Current traces (assumed [nA]),
%   sub_data_v: Voltage traces (assumed [mV]),
%   cell_name: Extracted from the file name part of the path.
%
% Description:
%   Return subtracted voltage traces, too, to show no change in voltage
%   protocol.
%
% Example:
% >> [time, dt, sub_data_i, sub_data_v, cell_name] = ...
%    sub2VclampAbf('data-dir/cell-A.abf')
% >> plotVclampStack(time, sub_data_i, sub_data_v, cell_name);
%
% See also: abf2load, plotVclampAbf, plotVclampStack
%
% $Id: sub2VclampAbf.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/02/05

if ~ exist('props', 'var')
  props = struct;
end

if ~ exist('title_str', 'var')
  title_str = '';
end

% load and subtract them
[time, dt, data_i_1, data_v_1, cell_name_1] = ...
    loadVclampAbf(filename1, props);

[time, dt, data_i_2, data_v_2, cell_name_2] = ...
    loadVclampAbf(filename2, props);

sub_data_i = data_i_1 - data_i_2;
sub_data_v = data_v_1 - data_v_2;

% plot all
sub_cell_name = [ cell_name_1 ' - ' cell_name_2 ', I'];
plotFigure(...
  plot_stack({...
    plot_abstract({time, data_i_1}, {'time [ms]', 'I_1 [nA]'}, ...
                  [ cell_name_1 ], {}, 'plot', struct), ...
    plot_abstract({time, data_i_2}, {'time [ms]', 'I_2'}, ...
                  [ cell_name_2 ], {}, 'plot', struct), ...
    plot_abstract({time, data_i_1 - data_i_2}, {'time [ms]', ...
                    [ 'I_1-I_2' ] }, sub_cell_name, {}, ...
                  'plot', struct), ...
    plot_abstract({time, data_v_1}, {'time [ms]', 'V_{m,1} [mV]'}, ...
                  'voltage steps', {}, 'plot', struct), ...
    plot_abstract({time, sub_data_v}, {'time [ms]', [ 'V_{m,1}-V_{m,2}']}, ...
                  'voltage steps', {}, 'plot', struct)}, ...
             [], 'y', [ sub_cell_name ': ' title_str ], ...
             mergeStructs(props, struct('titlesPos', 'none', 'xLabelsPos', 'bottom', ...
                                        'fixedSize', [4 6], 'noTitle', 1))))
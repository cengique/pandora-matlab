function plot_handle = plotVclampAbf(filename, props)

% plotVclampAbf -  Vertical stack plot of voltage-clamp I and V traces from ABF file.
%
% Usage:
% plot_handle = plotVclampAbf(filename, props)
%
% Parameters:
%   filename: Full path to filename.
%   props: A structure with any optional properties.
%     (passed to loadVclampAbf and plotVclampStack)
%		
% Returns:
%   plot_handle: Figure handle.
%
% Description:
%
% Example:
% >> plotVclampAbf('data-dir/cell-A.abf')
% 
% See also: loadVclampAbf, plotVclampStack
%
% $Id: plotVclampAbf.m 114 2010-05-20 19:44:17Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2009/12/17

  if ~ exist('props', 'var')
    props = struct;
  end

  if ~ exist('filename', 'var')
    filename = '';
  end

  % load data from ABF file
  [time, dt, data_i, data_v, cell_name] = ...
      loadVclampAbf(filename, props);

  num_pages = size(data_i, 3);
  if num_pages > 1
    for page_num=1:num_pages
      plot_handle = ...
          plotVclampStack(time, squeeze(data_i(:, page_num, :)), data_v, cell_name, ...
                          mergeStructs(props, ...
                                       struct('fixedSize', [8 6])));
    end
  else
    % plot it
    % TODO: not make it fixed size?
    % only take set of first current traces
    plot_handle = ...
        plotVclampStack(time, data_i(:, :, 1), data_v, cell_name, ...
                        mergeStructs(props, ...
                                     struct('fixedSize', [8 6])));
  end
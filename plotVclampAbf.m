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
% $Id: plotVclampAbf.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2009/12/17

  if ~ exist('props', 'var')
    props = struct;
  end
  
  % load data from ABF file
  [time, dt, data_i, data_v, cell_name] = ...
      loadVclampAbf(filename, props);

  % plot it
  % TODO: not make it fixed size?
  plot_handle = ...
      plotVclampStack(time, data_i, data_v, cell_name, ...
                      mergeStructs(props, ...
                                   struct('fixedSize', [8 6])));
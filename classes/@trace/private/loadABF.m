function [dt, data, y_units, dy, cell_name] = loadABF(filename, props)

% loadABF - Load trace from an ABF file.
%
% Usage:
% [dt, data, y_units, dy, cell_name] = loadABF(filename, props)
%
% Parameters:
%   filename: Full path to filename.
%   props: A structure with any optional properties.
%     channel: Read this channel from ABF file.
%		
% Returns:
%   dt: Time step [s],
%   data: Trace data (current assumed [nA], voltage assumed [mV]),
%   y_units: 'A' or 'V' for amperes or voltage, resp.
%   dy: Resolution of data in ISI units (V, A, etc). Example: 1e-3 for mV
%   cell_name: Extracted from the file name part of the path.
%
% Description:
%   ABF2 files are not fully supported (see abf2load.m). Time is
% assumed to be in s and converted to ms.
%
% Example:
% >> [time, dt, data, cell_name] = ...
%    loadABF('data-dir/cell-A.abf')
%
% See also: abf2load
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2012/03/07

  % extract cell name from file
  [pathstr, cell_name, ext] = fileparts(filename);
  
  % read ABF file
  [data, dt, info] = abf2load(filename);  

  % convert from us to s
  dt = dt * 1e-6;
  
  % - now at least lookup the correct V and I channels
  chan = strmatch('mV', info.recChUnits);
  y_units = 'V';
  dy = 1e-3;

  if isempty(chan)
    % try current units nA and pA
    chan = strmatch('nA', info.recChUnits);
    dy = 1e-9;
    y_units = 'A';
    
    if isempty(chan)
      chan = strmatch('pA', info.recChUnits);
      dy = 1e-12;
      if isempty(chan)
        dy = 1;
        chan = 1;
        info.recChUnits
        warning(['Cannot parse channel units above. Tried mV, nA and pA.']);
      end
    end
  end

  if isfield(props, 'channel')
    chan = props.channel;
  end
  
  data = squeeze(data(:, chan, :));
  end

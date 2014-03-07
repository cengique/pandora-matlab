function [time, dt, data_i, data_v, cell_name] = loadVclampAbf(filename, props)

% loadVclampAbf - Load I and V traces from an ABF file.
%
% Usage:
% [time, dt, data_i, data_v, cell_name] = loadVclampAbf(filename, props)
%
% Parameters:
%   filename: Full path to filename.
%   props: A structure with any optional properties.
%     scaleI: multiplier to correct I values to the units specified in file.
%     actualProtocols: Means current trace is a TTL pulse and its
%     		       magnitude is meaningless.
%		
% Returns:
%   time: Time vector for measurements [ms],
%   dt: Time step [ms],
%   data_i: Current traces (assumed [nA]),
%   data_v: Voltage traces (assumed [mV]),
%   cell_name: Extracted from the file name part of the path.
%
% Description:
%   If filename is wrong or not specified, a dialog will pop up to choose
% file. ABF2 files are not fully supported (see abf2load.m). Time is
% assumed to be in s and converted to ms.
%
% Example:
% >> [time, dt, data_i, data_v, cell_name] = ...
%    loadVclampAbf('data-dir/cell-A.abf')
% >> plotVclampStack(time, data_i, data_v, cell_name);
%
% See also: abf2load, plotVclampAbf, plotVclampStack
%
% $Id: loadVclampAbf.m 794 2014-01-15 16:40:57Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2009/12/17
%
% Modified: Fred Sieling <fred.sieling@gmail.com>

% TODO: make this an object

  props = defaultValue('props', struct);
  
  % extract cell name from file
  [pathstr, cell_name, ext] = fileparts(filename);
  
  % open given file
  fid = fopen(filename);
  
  % if fails, bring up user interface (UI)
  if (fid < 0) 
    disp([ 'Cannot open ABF file "' filename '".' ]);

    curdir = cd;
    cd(pathstr);
    [filename, pathstr] = ...
        uigetfile( ...
          {'*.abf', 'Axon Files (*.abf)'; ...
           '*.*',   'All Files (*.*)'}, ...
          'Pick a file');
    cd(curdir);
    
    filename = [ pathstr filesep filename ];
    
    % try opening again
    fid = fopen(filename);
  
  end

  % open and close to check existence
  fclose(fid);

  % extract cell name from file
  [pathstr, cell_name, ext] = fileparts(filename);

  % read ABF file
  [data, dt, info] = abf2load(filename);  

  % convert time to ms
  % TODO: read time units from metadata
  dt = dt / 1e3;

  % contruct time array
  time = (0:(info.dataPtsPerChan-1))'*dt;
  
  % separate current and voltage
  % TODO: 
  % - read units from metadata and convert to target units
  % - create a voltage_clamp object to store this info (subclass of trace)

  % - now at least lookup the correct V and I channels
  chan_v = strmatch('mV', info.recChUnits);

  % try V then
  if isempty(chan_v)
    chan_v = strmatch('V', info.recChUnits);
    v_scale = 1e3;
    if isempty(chan_v)
      error(['Cannot parse voltage channel units: ''' info.recChUnits ...
             '''. ']);
    end
  end
  
  % try current units nA and pA
  chan_i = strmatch('nA', info.recChUnits);
  i_scale = 1;
  
  if isempty(chan_i)
    chan_i = strmatch('pA', info.recChUnits);
    i_scale = 1e-3;
    if isempty(chan_i)
      error(['Cannot parse current channel units: ''' info.recChUnits ...
             '''. ']);
    end
  end

  if isfield(props, 'scaleI')
    i_scale = i_scale * props.scaleI;
  end
  
  if isfield(props,'actualProtocols')
      data_v = squeeze(data(:, chan_v, :));      % in mV
      data_i = squeeze(data(:,2));      % as TTL pulse (scale is meaningless)
  else
      data_v = squeeze(data(:, chan_v, :));      % in mV
      data_i = squeeze(data(:, chan_i, :)) * i_scale; % always in nA
  end

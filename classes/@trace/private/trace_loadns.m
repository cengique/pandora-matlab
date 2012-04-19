function [trace_data, trace_dt, trace_id, props] = trace_loadns(filename, props)

% trace_loadns - Load a trace from a Neuroshare-compliant file.
%
% Usage:
% [trace_data, trace_dt, trace_id, props] = trace_loadns(filename, props)
%
% Parameters:
%   filename: A neuroshare-compliant file name with the proper extension.
%   props: A structure with any optional properties passed from trace.
%		
% Returns:
%   trace_data: Loaded trace data.
%   trace_dt: Time resolution or 1 / sample rate in 1/Hz.
%   trace_id: Entity label from NS file.
%   props: Return modified props back to trace.
%
% Description:
%   See http://neuroshare.org. Windows DLLs must be in the search path. Some
% code was taken from the FIND Toolbox:
% Meier R.,Boven KH., Aertsen A. and Egert U.  FIND - Finding Information in
% Neural Data, An open-source analysis toolbox for multiple-neuron
% recordings and network simulations (2007), Proc 7th German Neurosci
% Meeting, p.1212
%
% See also: trace.m
%
% $Id$
%
% Author: 
% Cengiz Gunay <cgunay@emory.edu> and Ralph Meier <meier@biologie.uni-freiburg.de>, 2008/10/20

% Load the appropriate DLL based on the file extension

vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

if ~ ispc
    error(['Vendor-supplied NeuroShare DLLs only work in Windows version of Matlab. ' ...
        'Please submit your grievances to the NeuroShare community at http://neuroshare.org.']);
end
    

% unify file extensions to lowercase
  file_ext = lower(filename(end-3:end));
  
  switch file_ext 
    case '.mcd' %Multi Channel Systems
      DLLName = 'nsMCDLibrary.dll';
    case '.smr' % PC spike2, Cambridge Electronic Design Ltd.
      DLLName = 'NSCEDSON.DLL';
    case '.son' % Mac spike2, Cambridge Electronic Design Ltd.
      DLLName = 'NSCEDSON.DLL';
    case '.map' % Alpha Omega Eng.
      DLLName = 'nsAOLibrary.dll';
      %     case '' %Cambridge Electronics. DLL is somehow buggy and can't be
      %     loaded.
      %         DLLName = 'CFS32.dll';
    case '.nex' % Nex Technologies (NeuroExplorer)
      DLLName = 'NeuroExplorerNeuroShareLibrary.dll';
    case '.plx' % Plexon Inc.
      DLLName = 'nsPlxLibrary.dll';
    case '.stb' % Tucker-Davis
      DLLName = 'nsTDTLib.dll';
    case '.nev' % Cyberkinetics Inc., Library for Cerebus file group
      DLLName = 'nsNEVLibrary.dll';
    case '.nsn' % Neuroshare Native File Format
      DLLName = 'nsNSNLibrary.dll';
    otherwise
      % prompt user for DLL file?
      error([ 'No NeuroShare DLL available for this type (' file_ext ') of file.' ])
  end
  
  % In Windows, Matlab cannot find the NeuroShare DLLs unless the full path is given
  mpath = mfilename('fullpath');
  sep = filesep;
  [pathstr, name, ext, versn] = fileparts(mpath);
  DLLName = [ pathstr sep DLLName ];
  
  %%% find the DLL 
  if (ns_SetLibrary(DLLName) ~= 0)
    error(['NeuroShare DLL "' DLLName '" was not found!']);
  end
  
  % Open data file
  [nsresult, hfile] = ns_OpenFile(filename);
  if (nsresult ~= 0)
    error([ 'Cannot open NeuroShare data file "' filename '".' ]);
    return
  end

  % Get file information
  [nsresult, FileInfo] = ns_GetFileInfo(hfile);

  % Gives you EntityCount, TimeStampResolution and TimeSpan
  if (nsresult ~= 0)
    disp('Data file information did not load!');
    return
  end

  % Build catalogue of entities
  [nsresult, EntityInfo] = ns_GetEntityInfo(hfile, [1 : 1 : FileInfo.EntityCount]);

  % recorded data is here
  SegmentList = find([EntityInfo.EntityType] == 3);
  cSegment = length(SegmentList);

  % what to do with analog entrieS?? some recordings may have this instead of
  % segments?
  AnalogList = find([EntityInfo.EntityType] == 2);
  cAnalog = length(AnalogList);

  if (cSegment == 0 && cAnalog == 0)
    error('No segment or analog entities available in file!');
  end

  if ~ isfield(props, 'nsType') 
      % default data type is segment if exists
      if cSegment > 0
          props.nsType = 'segment'; 
      else
          props.nsType = 'analog'; 
      end
  end

  % read desired channel
  if ~ isfield(props, 'channel')
      if verbose, warning('Channel not specified in props, defaulting to 1.'); end
      props.channel = 1;
  end

  % read desired traces
  if ~ isfield(props, 'traces')
      if verbose, warning('Traces not specified in props, defaulting to [1].'); end
      props.traces = 1;
  end

  % Throw away entity infos we don't need to save memory
  EntityInfo = rmfield(EntityInfo, 'EntityType');

  switch props.nsType
      case 'segment'
          if cSegment == 0, error('Segment entities are selected, but none in file!'); end
          ChannelList = SegmentList;
      case 'analog'
          if cAnalog == 0, error('Analog entities are selected, but none in file!'); end
          ChannelList = AnalogList;
  end
  
  if props.channel > length(ChannelList)
      error(['Selected channel (' num2str(props.channel) ...
          ') is greater than number of available channels (' length(ChannelList) ').']);
  else
      ChannelIDs = ChannelList(props.channel);
  end
  
  % the name of the channel:
  trace_id = EntityInfo(ChannelIDs).EntityLabel;

  % Number of traces available for this channel
  num_traces = EntityInfo(ChannelIDs).ItemCount;

  switch props.nsType 
      case 'segment'
          if any(props.traces > num_traces)
              error([ 'Selected a non-existant trace number. Max number of traces ' ...
                  'in channel is ' num2str(num_traces) '.' ]);
          end

          % Load the waveform data and do the analysis
          [nsresult, nsSegmentInfo] = ns_GetSegmentInfo(hfile, ChannelIDs);
          [nsresult, nsSegmentSourceInfo] = ns_GetSegmentSourceInfo(hfile, ChannelIDs, 1);

          % Load the requested traces on the selected channel
          [nsresult, timestamps_wf, trace_data, sampleCount, unitIDs] = ...
              ns_GetSegmentData(hfile, ChannelIDs, props.traces);

          trace_dt = 1 / nsSegmentInfo.SampleRate;

          clear nsSegmentInfo nsSegmentSourceInfo sampleCount UnitIDs;

      case 'analog'
          % Load the waveform data and do the analysis
          [nsresult, nsAnalogInfo] = ns_GetAnalogInfo(hfile, ChannelIDs);

          % check if traces are sequential
          trace_diff = diff(props.traces);
          if ~ isempty(trace_diff) && any(trace_diff > 1)
              error(['Only sequential traces can be loaded from Analog entities in NeuroShare files. ' ...
                  'Traces selected (' num2str(props.traces) ') are not sequentially ordered.']);
          end
          
          if verbose
              warning(['Loading Analog type data from NeuroShare file, ignoring props.traces to ' ...
                  'load all available data. Data may be discontiguous!']);
          end
          
          % Load all traces on the selected channel
          [nsresult, contCount, trace_data] = ...
              ns_GetAnalogData(hfile, ChannelIDs, 1, num_traces);

          trace_dt = 1 / nsAnalogInfo.SampleRate;

          clear nsAnalogInfo contCount;
  end

% Close data file. Should be done by the library but just in case. 
ns_CloseFile(hfile);

% Unload DLL
clear mexprog;

% always make a vertical vector for trace
trace_data = trace_data(:);
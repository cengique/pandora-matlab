function [a_tss h5_infos] = ns_load_cip_tracesets(data_src, props)

% ns_load_tracesets - Return a set of physiol_cip_traceset objects loaded from a single NeuroSAGE HDF5 file.
%
% Usage:
% a_tss = ns_load_tracesets(data_src, props)
%
% Description:
%   This allows customized loading each NeuroSAGE file separately. Only
% loads traces that has the word 'cip' or 'spont' in the NeuroSAGE sequence name.
% Sample rate, channel gain and dy values are read from the acquisition data.
%
%   Parameters:
%	data_src: A pattern for one or more NeuroSAGE filename or structure output of ns_open_file.
%	props: A structure with any optional properties.
%	  VmChan: (Optional) If a string, read voltage trace from channel having
%	  	  this string (e.g., 'Amp1 Vm'). If numeric, use as channel
%	  	  number. Added to the neuron_id to distinguish
%	  	  multiple neurons recorded in same file. If not
%	  	  specified, the first voltage channel is used.
%	  ImChan: (Optional) Similar to VmChan for reading current
%	  	  trace. Does not affect neuron_id.
%	  addTreats: Structure of default treatment names and their
%	  	values for this traceset to keep consistent accross 
%		tracesets. Use only lowercase in treatment names.
%	  fixTreats: Override wrong treatment information with
%	  	these. Same format as addTreats.
%	  renameTreats: Structure with from->to rename pairs.
%	  trials: A vector of trials to load from the file. All others
%	  	are skipped.
%	  (All other props are passed to physiol_cip_traceset)
%		
%   Returns:
%	a_tss: Cell array of physiol_cip_traceset objects.
%
%
% See also: physiol_cip_traceset_fileset, physiol_cip_traceset, params_tests_dataset
%
% $Id: ns_load_tracesets.m 894 2007-12-17 17:30:33Z cengiz $
%
% Author: Li, Su; Cengiz Gunay <cgunay@emory.edu>; and Jeremy Edgerton, 2007/12/18
%
% Modified: 

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% TODO: save hdf_info structure in a standart file after loading, and
% look for it next time.
  
  vs = warning('query', 'verbose');
  verbose = strcmp(vs.state, 'on');

  if ~ exist('props', 'var')
    props = struct;
  end

  n = 1;                                % traceset counter
  a_tss = {};
  h5_infos = {};
  if ischar(data_src)                   % filename
    if any(strfind(data_src, '*'))      % contains wildcards
      [datapath, name, ext, ver] = fileparts(data_src);
      files = dir(data_src);
      if isempty(files)
        error(['File pattern (' data_src ') returned no matches.']);
      end
      for k = 1:length(files)
        % recurse
        [a_ts h5_info] = ...
            ns_load_tracesets([ datapath '/' files(k).name ], props);
        a_tss = [ a_tss, a_ts ];
        h5_infos = [ h5_infos, {h5_info} ];
      end
      return;
    end
    filename = data_src;
  elseif iscell(data_src)
    % if cell input, run for each separately
    for k = 1:length(data_src)
      % recurse
      [a_ts h5_info] = ...
          ns_load_tracesets(data_src{k}, props);
      a_tss = [ a_tss, a_ts ];
      h5_infos = [ h5_infos, {h5_info} ];
    end
    return;
  elseif isstruct(data_src)
    % assume it's hdf5 structure returned from ns_open_file
    filename = data_src.Name;
  else
    error(['Unknown input type (' class(data_src) ') for data_src.']);
  end

  [nfo h5] = ns_file_info(data_src, 'hc');
  h5_infos{n} = h5;
  if isempty(nfo)
    warning('Nothing found in file by ns_file_info.');
    return;
  end
  % Warning: Li Su's approach of finding neurons based on first six letters of
  % filename is not general. Converted to use ExperimentTag with the
  % combination of recording voltage channel as unique id for neuron names.

  % only load tracesets from CIP sequences 
  idx = strcat(strfind(upper(nfo(:,4)),'CIP'), strfind(upper(nfo(:,4)),'SPONT'));
  % CG commented Li Su custom exceptions
% $$$     not_idx=strcat(strfind(upper(nfo(:,4)),'SHORT'), ...
% $$$                    strfind(upper(nfo(:,4)),'DYN'), ...
% $$$                    strfind(upper(nfo(:,4)),'SK'));
  not_idx = [];
  for l=1:length(idx)
    % && isempty(not_idx{l})
    if isfield(props, 'trials')
      % check if among the given trials
      trials = intersect(nfo{l,1}, props.trials);
    else
      % otherwise take all
      trials = nfo{l,1};
    end
    if ~isempty(idx{l}) && ~isempty(trials)
      first_trial = h5.Trials{nfo{l,1}(1)};
      
      % read user attributes
      atts = getfuzzyfield(first_trial, 'User');
      
      % Read channel and gain info
      % voltage channel 
      if isfield(props, 'VmChan')
        Vm_chan = ...
            find_chan_acquisition_name(first_trial, props.VmChan);
      else
        Vm_chan = ...
            find_chan_acquisition_dataaxis(first_trial, 'Voltage');
        Vm_chan = Vm_chan(1);         % Take first channel
      end
      
      % Make the voltage channel part of neuron_id because there may be
      % multiple cells in same file!
      neuron_id = [ h5.ExperimentTag '_chan' num2str(Vm_chan) ] ;
      
      switch first_trial.AcquisitionData{Vm_chan}.DataUnit
        case 'mV'
          Vm_dy = 1e-3;
        otherwise
          Vm_dy = 1;
      end

      % Don't set the gain, because ns_read already applies it
      % We may need to apply a default gain if it is not forgotten to
      % be set.
      %Vm_gain =
      %  first_trial.AcquisitionData{Vm_chan}.Transform(1).Scale;
      Vm_gain = 1;
      Vm_dt = 1/first_trial.AcquisitionData{Vm_chan}.SamplingRate;

      % current channel 
      if isfield(props, 'ImChan')
        Im_chan = ...
            find_chan_acquisition_name(first_trial, props.ImChan);
      else
        Im_chan = ...
            find_chan_acquisition_dataaxis(first_trial, 'Current');
        Im_chan = Im_chan(1);         % Take first channel
      end
      
      % no gain for Im chan
      Im_gain = 1;
      
      % default attributes
      if isfield(props, 'addTreats')
        % add more defaults, overriding originals in case of clash
        default = props.addTreats;
      else
        default = struct;
      end
      
      if ~isempty(atts)
        % no Bad trials
        if ~isempty(getfuzzyfield(atts, 'Bad'))
          continue
        end
        % parse the structure value from string to numbers.
        treatments = atts;
        fields = fieldnames(treatments);
        for m=1:length(fields)
          n1=fields{m};
          [num unit]=numunit(treatments.(n1));
          if isempty(unit)
            num=-num-1;
          elseif ~isempty(strfind(unit,'mM'))
            num=num*1e-3;
          elseif ~isempty(strfind(unit, 'uM'))
            num=num*1e-6;
          elseif ~isempty(strfind(unit, 'nM'))
            num=num*1e-9;
          elseif ~isempty(strfind(unit, 'pM'))
            num=num*1e-12;
          end
          if ~isequal(lower(n1), 'bad') && ~isequal(lower(n1), 'bias')
            default.(lower(n1))=num;
          end
        end
      end
      if isfield(props, 'renameTreats')
        default = renameTreats(default, props.renameTreats);
      end
        
      if isfield(props, 'fixTreats')
        % override treatments read with these
        default = mergeStructs(props.fixTreats, default);
      end
      atts=default;
      
      if verbose
        atts, n, trials
      end
      
      % n is dynamically incremented, cannot pre-allocate for list_cp_ts
      a_tss{n} = ...
          physiol_cip_traceset(trials, filename, ...
                               [Vm_chan Im_chan Vm_gain Im_gain], Vm_dt, Vm_dy, atts , ...
                               neuron_id, mergeStructs(props, struct('nsHDF5', h5)));
      n=n+1;
    end % if idx
  end % idx
  end % function ns_load_tracesets
  
  function chan_num = find_chan_acquisition_name(a_trial, ...
                                                 a_chan_name_str)
    chan_num = ...
        find(cellfun(@(x)(~isempty(strfind(lower(x.Name), lower(a_chan_name_str)))), ...
                     a_trial.AcquisitionData));
    if isempty(chan_num)
      error([ 'Cannot find desired channel "' a_chan_name_str ...
              '" in the acquisition data for trial ' a_trial.Name ...
              '.' ]);
    end
  end
  
  function chan_num = find_chan_acquisition_dataaxis(a_trial, ...
                                                     a_dataaxis_str)
    chan_num = ...
        find(cellfun(@(x)(strcmp(x.DataAxis, a_dataaxis_str)), ...
                     a_trial.AcquisitionData));
    if isempty(chan_num)
      error([ 'Cannot find any channels with "' a_dataaxis_str '"' ...
              'in the acquisition data axis for trial ' a_trial.Name ...
              '.' ]);
    end
  end

  function treats = renameTreats(treats, rename_struct)
    for treat_name = fieldnames(rename_struct)'
      treat_name = treat_name{1};
      found_name = getfuzzyfield(treats, treat_name);
      if isfield(treats, lower(treat_name))
        % exists: rename and delete old
        % always keep lowercase
        treats.(lower(rename_struct.(treat_name))) = ...
            treats.(lower(treat_name));
        treats = rmfield(treats, lower(treat_name));
      end
    end
  end
function obj = physiol_cip_traceset(trace_str, data_src, ...
				    chaninfo, dt, dy, treatments, neuron_id, props)

% physiol_cip_traceset - Dataset of cip traces from same PCDX file.
%
% Usage:
% obj = physiol_cip_traceset(trace_str, data_src, chaninfo, dt, dy, treatments, neuron_id, props);
%
% Description:
%   This is a subclass of params_tests_dataset. Each trace varies in bias, 
% pulse times and cip magnitude.
%
%   Parameters:
%	trace_str: Trace list in the format for loadtraces or just a Matlab vector.
%	data_src: Absolute path of PCDX data source.
%	chaninfo: 4-element array containing vchan, ichan, vgain, igain
%	  vchan, ichan: Current and voltage channels.
%	  vgain, igain: External gain factors for voltage channel and current 
%			channel
%	  (vgain does NOT include the 10X amplification from the Axoclamp,
%	   so vgain = 1 would mean no additional amplification beyond the 10X.)
%	dt: Time resolution [s].
%	dy: Y-axis resolution [V] or [A].
%	treatments: Structure containing the names and concentrations
%		    of compounds.
%	neuron_id: Neuron name.
%	props: A structure with any optional properties.
%	  nsHDF5: For NeuroSAGE HDF5 files, processing is faster if the output
%	  	  of ns_open_file is given here. Must be defined to allow
%	  	  special NeuroSAGE processing.
%	  profile_class_name: Use this cip_trace function to return a
%	  		profile (Default: 'getProfileAllSpikes').
%	  cip_list: Vector of cip levels to which the current trace will be matched.
%	  (All other props are passed to cip_trace objects)
%		
%   Returns a structure object with the following fields:
%	params_tests_dataset,
%	data_src, ichan, vchan, vgain, igain, treatments.
%
% General operations on physiol_cip_traceset objects:
%   physiol_cip_traceset - Construct a new object.
%   loadItemProfile	- Builds a cip_trace_profile for a trace in the set.
%   cip_trace_profile	- Load a cip_trace_profile corresponding to a trace.
%   CIPform		- Get CIP pulse information.
%
% Additional methods:
%	See methods('physiol_cip_traceset'), and 
%	    methods('params_tests_dataset').
%
% See also: cip_traces, params_tests_dataset, params_tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu> and Thomas Sangrey, 2005/01/17

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

if nargin == 0 % Called with no params
  obj.data_src = [];
  obj.vchan = 0;
  obj.ichan = 0;
  obj.vgain = 1;
  obj.igain = 1;
  obj.treatments = struct([]);
  obj.neuron_id = '';
  obj = class(obj, 'physiol_cip_traceset', params_tests_dataset);
elseif isa(trace_str, 'physiol_cip_traceset') % copy constructor?
  obj = trace_str;
else


  obj.data_src = data_src;
  obj.vchan = chaninfo(1);
  obj.ichan = chaninfo(2);
  obj.vgain = chaninfo(3);
  obj.igain = chaninfo(4);
  obj.treatments = treatments;
  obj.neuron_id = neuron_id;

  if ~ exist('treatments') || isempty(treatments)
      obj.treatments = struct([]);
  end
  
  trace_list = [];
  if isstr(trace_str)
      trace_list = gettracelist2(trace_str);
  else
      trace_list = trace_str;
      trace_str = array2str(trace_str); % edited by Li Su.
  end

  if ~ exist('props')
    props = struct;
  end
  
  if ~ isfield(props, 'profile_class_name')
    props.profile_class_name = 'getProfileAllSpikes';
  end
  
  if isfield(props, 'nsHDF5') || ~isempty(strfind(data_src, '.hdf5'))
    if isfield(props, 'nsHDF5') && isstruct(props.nsHDF5)
      % it's much faster to do this only once!
      ns_h5_info = props.nsHDF5;
    else
      ns_h5_info = ns_open_file(data_src, true);
    end
    % remove it from props to save space:
    props.nsHDF5 = [];
    
    % read in new info
    Trials = ns_select_trials(ns_h5_info, trace_list);
    % remove some unused fields in Trial info to keep props slim. by Li Su
    Trials = cellfun(@(x)rmfield(x,...
                {'HDF5', ...
                 'ExperimentControl', ...
                 'InstrumentConfiguration', ...
                 'StimulationData' ...
                }), ...
             Trials, 'uniformoutput', false);
    props.Trials = Trials;
    props.cip_list = ns_CIPlist(ns_h5_info, trace_list);

    if verbose, props, end

    if ~ isempty(trace_list) && isempty(props.Trials)
      trace_list
      props
      error('Cannot find any of the above trials with ns_select_trials.');
    end    
    
    tr1=trace_list(1); ch=max([obj.vchan 1]);
    if ~exist('dt','var') || isempty(dt)
      dt = 1/props.Trials{tr1}.AcquisitionData{ch}.SamplingRate;
    end

    if ~exist('dy','var') || isempty(dy)
      dy = 1; %/pros.Trials{tr1}.AcquisitionData{ch}.SamplingRate;
    end
  end

  % reading CIP list from the file
  
  % Create the object 
  obj = class(obj, 'physiol_cip_traceset', ...
	      params_tests_dataset(trace_list, dt, dy, ...
				   [ 'traceset ' neuron_id ' (' data_src '), trials ' ...
				    trace_str ' ' props.Trials{1}.SequenceName ' '], props));
    % add sequence name into traceset name. by Li Su

end


function obj = physiol_cip_traceset(trace_str, data_src, ...
				   chaninfo, dt, dy, tmts, id)

% physiol_cip_traceset - Dataset of cip traces from same PCDX file.
%
% Usage:
% obj = physiol_cip_traceset(trace_str, data_src, chaninfo, dt, dy, tmts, id);
%
% Description:
%   This is a subclass of params_tests_dataset. Each trace varies in bias, 
% pulse times and cip magnitude.
%
%   Parameters:
%	trace_str: Trace list in the format for loadtraces.
%	data_src: Absolute path of PCDX data source.
%	chaninfo: 4-element array containing vchan, ichan, vgain, igain
%		vchan, ichan: Current and voltage channels.
%		vgain, igain: external gain factors for voltage channel and current 
%			channel
%			--> vgain does NOT include the 10X amplification from the Axoclamp,
%			so vgain = 1 would mean no additional amplification beyond the 10X.
%	dt: time resolution [s].
%	dy: y-axis resolution [V] or [A].
%	tmts: structure containing the names and concentrations of compounds
%	id: neuron id name
%		
%   Returns a structure object with the following fields:
%	params_tests_dataset,
%	data_src, ichan, vchan, vgain, igain, treatments, id
%	-->treatments is a struct with fieldnames corresponding to treatment names
%		and field values corresponding to concentrations.
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
% Author: Cengiz Gunay <cgunay@emory.edu> and Thomas Sangrey, 2005/01/17

if nargin == 0 %# Called with no params
  obj.data_src = [];
  obj.vchan = 0;
  obj.ichan = 0;
  obj.vgain = 1;
  obj.igain = 1;
  obj.treatments = struct([]);
  obj.id = '';
  obj = class(obj, 'physiol_cip_traceset', params_tests_dataset);
elseif isa(trace_str, 'physiol_cip_traceset') %# copy constructor?
  obj = trace_str;
else
  obj.data_src = data_src;
  obj.vchan = chaninfo(1);
  obj.ichan = chaninfo(2);
  obj.vgain = chaninfo(3);
  obj.igain = chaninfo(4);
  obj.treatments = tmts;
  obj.id = id;
  
  %# Create the object 
  obj = class(obj, 'physiol_cip_traceset', ...
	      params_tests_dataset(gettracelist2(trace_str), dt, dy, ...
				   [ 'traceset ' data_src ' ' ...
						 trace_str ' ' ], struct([])));

end


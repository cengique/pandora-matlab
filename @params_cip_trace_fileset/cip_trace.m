function a_cip_trace = cip_trace(fileset, file_index, props)

% cip_trace - Loads raw cip_traces for each given file_index in this fileset.
%
% Usage:
% a_cip_trace = cip_trace(fileset, file_index|a_db, props)
%
% Description:
%
%   Parameters:
%	fileset: A params_tests_fileset.
%	file_index: A single or array of indices of files in fileset.
%	a_db: A DB created by this fileset to read the item indices from.
%	props: A structure with any optional properties.
%	  neuronLabel: Used for annotation purposes.
%		
%   Returns:
%	a_cip_trace: A cip_trace object.
%
% See also: cip_trace, params_tests_fileset
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/13

if ~exist('props')
  props = struct;
end

if isa(file_index, 'tests_db')
  a_db = file_index;
  col_data = get(onlyRowsTests(a_db, ':', 'ItemIndex'), 'data');
  %# recurse
  a_cip_trace = cip_trace(fileset, col_data, props);
else
  num_indices = length(file_index);
  a_cip_trace(1:num_indices) = cip_trace;
  for an_index = 1:num_indices
    filename = getItem(fileset, file_index(an_index));
    fullname = fullfile(get(fileset, 'path'), filename);

    f_props = get(fileset, 'props');
    if isfield(f_props, 'param_rows')
      %# Take parameter values from the specified parameter file,
      %# in addition to the ones specified on data filenames.
      names_vals = parseGenesisFilename(fullname);
      if isfield(f_props, 'num_params')
	num_params = f_props.num_params;
      else
	num_params = size(names_vals, 1);
      end
      if ~ isfield(f_props, 'param_trial_name')
	f_props.param_trial_name = 'trial';
      end
      str_index = strmatch(f_props.param_trial_name, names_vals{1:num_params, 1});
      
      if length(str_index) < 1
	error(['Parameter lookup from rows is requested, but cannot find ' ...
	       'the "' f_props.param_trial_name '" parameter in the data filename ' fullname ]);
      end
    
      trial_num = names_vals{str_index, 2};
      trace_id = [ 't' num2str(trial_num) ];
    else
      trace_id = num2str(file_index(an_index));
    end

    %# overwrite the above trace id if one specified in neuronLabel
    if isfield(props, 'neuronLabel')
      trace_id = props.neuronLabel;
    end
    
    %# Load a cip_trace object
    a_cip_trace(an_index) = ...
	cip_trace(fullname, get(fileset, 'dt'), get(fileset, 'dy'), ...
		  fileset.pulse_time_start, fileset.pulse_time_width, ...
		  [get(fileset, 'id') '(' trace_id ')'], ...
		  mergeStructs(props, get(fileset, 'props')));
  end
end

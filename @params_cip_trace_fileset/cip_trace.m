function a_cip_trace = cip_trace(fileset, file_index)

% cip_trace - Loads a raw cip_trace given a file_index to this fileset.
%
% Usage 1:
% a_cip_trace = cip_trace(fileset, file_index)
%
% Usage 2:
% a_cip_trace = cip_trace(fileset, a_db)
%
% Description:
%
%   Parameters:
%	fileset: A params_tests_fileset.
%	file_index: Index of file in fileset.
%	a_db: A DB created by this fileset to read the item indices from.
%		
%   Returns:
%	a_cip_trace: A cip_trace object.
%
% See also: cip_trace, params_tests_fileset
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/13

if isa(file_index, 'tests_db')
  a_db = file_index;
  col_data = get(onlyRowsTests(a_db, ':', 'ItemIndex'), 'data');
  num_rows = dbsize(a_db, 1);
  a_cip_trace = repmat(cip_trace, 1, num_rows);
  for row_num = 1:num_rows
    %# recurse
    a_cip_trace(row_num) = ...
	cip_trace(fileset, col_data(row_num, 1));
  end
else
  filename = getItem(fileset, file_index);
  fullname = fullfile(get(fileset, 'path'), filename);

  props = get(fileset, 'props');
  if isfield(props, 'param_rows')
    %# Take parameter values from the specified parameter file,
    %# in addition to the ones specified on data filenames.
    names_vals = parseGenesisFilename(fullname);
    if isfield(props, 'num_params')
      num_params = props.num_params;
    else
      num_params = size(names_vals, 1);
    end
    str_index = strmatch('trial', names_vals{1:num_params, 1});
    
    if length(str_index) < 1
      error(['Parameter lookup from rows is requested, but cannot find ' ...
	     'the "trial" parameter in the data filename ' fullname ]);
    end
    
    trial_num = names_vals{str_index, 2};
    trace_id = [ 't' num2str(trial_num) ];
  else
    trace_id = num2str(file_index);
  end

  %# Load a cip_trace object
  a_cip_trace = ...
      cip_trace(fullname, get(fileset, 'dt'), get(fileset, 'dy'), ...
		fileset.pulse_time_start, fileset.pulse_time_width, ...
		[get(fileset, 'id') '(' trace_id ')'], ...
		get(fileset, 'props'));
end

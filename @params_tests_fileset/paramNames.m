function param_names = paramNames(fileset, item)

% paramNames - Returns the ordered names of parameters for this fileset.
%
% Usage:
% param_names = paramNames(fileset, item)
%
% Description:
% Looks at the filename of the first file to find the parameter names.
%
%   Parameters:
%	fileset: A params_tests_fileset.
%	item: (Optional) If given, read param names by loading item at this index.
%		
%   Returns:
%	params_names: Cell array with ordered parameter names.
%
% See also: params_tests_fileset, paramNames, testNames
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/10

if ~ exist('item')
  item = 1;
end

props = get(fileset, 'props');

filename = getItem(fileset, item);
fullname = fullfile(fileset.path, filename);

names_vals = parseGenesisFilename(fullname);

if isfield(props, 'num_params')
  num_params = props.num_params;
else
  num_params = size(names_vals, 1);
end

if isfield(props, 'param_names')


  %# Take parameter values from the specified parameter file,
  %# in addition to the ones specified on data filenames.

  str_index = strmatch('trial', props.param_names);

  if length(str_index) < 1
    error(['Parameter lookup from rows is requested, but cannot find ' ...
	   'the "trial" parameter in the parameter names: ' props.param_names ]);
  end

  %# Remove the parameter "trial" from the list of parameters 
  %# coming from the param rows file
  trues = true(1, length(props.param_names));
  trues(str_index) = false;

  add_param_names = { props.param_names{trues} };
else
  add_param_names = { };
end

%# Convert param names to cell array
param_names = { add_param_names{:}, names_vals{1:num_params, 1} };

function param_names = paramNames(fileset)

% paramNames - Returns the ordered names of parameters for this fileset.
%
% Usage:
% param_names = paramNames(fileset)
%
% Description:
% Looks at the filename of the first file to find the parameter names.
%
%   Parameters:
%	fileset: A params_tests_fileset.
%		
%   Returns:
%	params_names: Cell array with ordered parameter names.
%
% See also: params_tests_fileset, paramNames, testNames
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/10

filename = getItem(fileset, 1);
fullname = fullfile(fileset.path, filename);

names_vals = parseGenesisFilename(fullname);

if isfield(fileset.props, 'num_params')
  num_params = fileset.props.num_params;
else
  num_params = size(names_vals, 1);
end

%# Convert param names to cell array
param_names = { names_vals{1:num_params, 1} };
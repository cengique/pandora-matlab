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
% See also: params_tests_fileset, testNames, parseFilenameNamesVals
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/10

% Copyright (c) 2004-14 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('item', 'var')
  item = 1;
end

props = get(fileset, 'props');
param_names = {};

filename = getItem(fileset, item);
fullname = fullfile(fileset.path, filename);

% if given, use the regular expression to parse parameters
if isfield(props, 'fileParamsRegexp')
  try 
    param_regexp = regexp(fullname, props.fileParamsRegexp, 'names');
  
    num_params = length(param_regexp);
    
    % convert the regexp sturcture into cell array
    for param_num = 1:num_params
        param_names{param_num} = param_regexp(param_num).name;
    end
  catch me
    error('pandora:fileset:regexpError', ...
        [me.message ': props.fileParamsRegexp must be a regular expression ' ...
         'with named captures for variables "name" and "val". See ' ...
         '"names" option to regexp.']);
  end
% if props.num_params ~= 0 then parse file names
elseif ~ isfield(props, 'num_params') || props.num_params ~= 0  
  names_vals = parseFilenameNamesVals(fullname, props);

  if isfield(props, 'num_params')
    num_params = props.num_params;
  else
    num_params = size(names_vals, 1);
  end
  
  param_names = { names_vals{1:num_params, 1} };
end

% parameter names in addition to the ones specified in data filenames
if isfield(props, 'param_names')
  str_index = strmatch('trial', props.param_names);
  trues = true(1, length(props.param_names));

  if ~ isempty(str_index)
    % Remove the parameter "trial" from the list of parameters 
    % coming from the param rows file
    trues(str_index) = false;
  end

  % Convert param names to cell array
  param_names = { props.param_names{trues}, param_names{:} };
end



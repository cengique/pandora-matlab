function [a_fileset, index_list] = addFiles(a_fileset, file_pattern, props)

% addFiles - Adds to existing list of files in set.
%
% Usage:
% [a_fileset, index_list] = addFiles(a_fileset, file_pattern, props)
%
% Description:
%
% Parameters:
%	a_fileset: A params_tests_fileset object.
%	file_pattern: File pattern, or cell array of patterns, matching additional files.
%	props: A structure with any optional properties.
%	  param_row_filename: Update parameters from here. The 'trial' parameter is used
%			to address rows from this file and acquire parameters.
%
% Returns:
%	a_fileset: The augmented fileset object.
%	index_list: The vector of index numbers of the new files added. Can be used
%		to selectively load the new files into a DB using params_test_db.
%		
% See also: params_tests_fileset, params_tests_dataset/params_test_db.
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/02/01

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

if ~ exist('props')
  props = struct([]);
end

%# First find all filenames matching the pattern

%# Multiple patterns in cell array allowed
if iscell(file_pattern)
  num_patterns = length(file_pattern);
  
  %# Separate filename components
  [obj.path, name, ext, ver] = fileparts(file_pattern{1});
else
  num_patterns = 1;
  
  %# Separate filename components
  [obj.path, name, ext, ver] = fileparts(file_pattern);
end

%# Loop over patterns (or do one pattern only)
total_entries = 0;
for pattern_num = 1:num_patterns
  if iscell(file_pattern)
    this_pattern = file_pattern{pattern_num};
  else
    this_pattern = file_pattern;
  end
  
  filestruct = dir(this_pattern);
  entries = size(filestruct, 1);
  [filenames{total_entries + (1:entries)}] = deal(filestruct(:).name);
  total_entries = total_entries + entries;
end

%# Add to existing list
existing_list = get(a_fileset, 'list');
num_existing = length(existing_list);
a_fileset = set(a_fileset, 'list', { existing_list{:}, filenames{:}});
index_list = (num_existing + 1):(num_existing + length(filenames));

%# Update the parameter values
if isfield(props, 'param_row_filename')
  param_rows = dlmread(props.param_row_filename);
  props.param_rows = param_rows(2:end, 1:param_rows(1, 2)); %# strip off excess columns

  a_fileset = set(a_fileset, 'props', mergeStructs(props, get(a_fileset, 'props')));
end

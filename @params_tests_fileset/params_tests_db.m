function db_obj = params_tests_db(obj, props)

% params_tests_db - Generates a params_tests_db object from the fileset.
%
% Usage:
% db_obj = params_tests_db(obj, props)
%
% Description:
%   This is a converter method to convert from params_tests_fileset to
% params_tests_db. A customized subclass should provide the correct 
% paramNames, testNames, and fileResultsRow functions. Adds a FileIndex
% column to the DB to keep track of raw data files after shuffling.
%
%   Parameters:
%	obj: A params_tests_fileset object.
%	props: Any optional params to pass to params_tests_db.
%		
%   Returns:
%	db_obj: A params_tests_db object.
%
% See also: params_tests_db, params_tests_fileset
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/09

if ~ exist('props')
  props = struct([]);
end

%# Collect info for generating the DB
param_names = paramNames(obj);
test_names = testNames(obj);
test_names = {test_names{:}, 'FileIndex'};
num_files = length(obj.filenames);

%# Preallocate matrices to dramatically speed up the filling process
params = repmat(0, num_files, length(param_names));
tests = repmat(0, num_files, length(test_names));

%# Batch process all files
start_time = cputime;

for file_index=1:num_files
  filename = obj.filenames{file_index};

  fullname = fullfile(obj.path, filename);
  [params_row, tests_row] = fileResultsRow(obj, fullname);
  
  params(file_index, :) = params_row;
  tests(file_index, :) = [tests_row, file_index];
end
end_time = cputime;

db_obj = params_tests_db(params, param_names, tests, test_names, ...
			 obj.id, props);

disp(sprintf('Elapsed time took %.2f seconds.', end_time - start_time));

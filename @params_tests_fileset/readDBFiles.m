function [params, param_names, tests, test_names] = readDBFiles(obj)

% readDBFiles - Reads all files to generate a params_tests_db object.
%
% Usage:
% [params, param_names, tests, test_names] = readDBFiles(obj)
%
% Description:
%   This is a generic method to convert from params_tests_fileset to
% a params_tests_db, or a subclass. This method depends on the  
% paramNames, testNames, and fileResultsRow functions. Adds a FileIndex
% column to the DB to keep track of raw data files after shuffling.
% Outputs of this function can be directly fed to the constructor of
% a params_tests_db or a subclass.
%
%   Parameters:
%	obj: A params_tests_fileset object.
%		
%   Returns:
%	params, param_names, tests, test_names: See params_tests_db.
%
% See also: params_tests_db, params_tests_fileset, fileResultsRow
%	    testNames, paramNames
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/11/24

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

%#try
print(java.lang.System.out, 'Reading: ');

  for file_index=1:num_files
    %#disp(sprintf('File number: %d\r', file_index));
    print(java.lang.System.out, [ num2str(file_index) ', ' ]);
    if mod(file_index, 20) == 0
      disp(' ');
    end
    [params_row, tests_row] = fileResultsRow(obj, file_index);
  
    params(file_index, :) = params_row;
    tests(file_index, :) = [tests_row, file_index];
  end
%#catch
%#  disp(['Error during processing file number ' num2str(file_index) ]);
%#  rethrow(lasterror);
%#end

end_time = cputime;

disp(sprintf('Elapsed time took %.2f seconds.', end_time - start_time));



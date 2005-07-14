function [params, param_names, tests, test_names] = readDBItems(obj, items)

% readDBItems - Reads all items to generate a params_tests_db object.
%
% Usage:
% [params, param_names, tests, test_names] = readDBItems(obj, items)
%
% Description:
%   This is a generic method to convert from params_tests_fileset to
% a params_tests_db, or a subclass. This method depends on the  
% paramNames, testNames, and itemResultsRow functions. 
% Outputs of this function can be directly fed to the constructor of
% a params_tests_db or a subclass.
%
%   Parameters:
%	obj: A params_tests_fileset object.
%	items: (Optional) List of item indices to use to create the db.
%		
%   Returns:
%	params, param_names, tests, test_names: See params_tests_db.
%
% See also: params_tests_db, params_tests_fileset, itemResultsRow
%	    testNames, paramNames
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/11/24

if ~ exist('items')
  items = 1:length(obj.list);
end

%# Collect info for generating the DB
param_names = paramNames(obj);
test_names = testNames(obj);
num_items = length(items);

%# Preallocating matrices dramatically speeds up the filling process
params = repmat(0, num_items, length(param_names));
tests = repmat(0, num_items, length(test_names));

%# Batch process all items
start_time = cputime;

print(java.lang.System.out, 'Reading: ');

try 
  row_index = 1;
  for item_index=items
    %#disp(sprintf('File number: %d\r', item_index));
    print(java.lang.System.out, [ num2str(item_index) ', ' ]);
    if mod(row_index, 20) == 0
      disp(' ');
    end
    [params_row, tests_row] = itemResultsRow(obj, item_index);
    
    params(row_index, :) = params_row;
    tests(row_index, :) = tests_row;
    row_index = row_index + 1;
  end
catch
  err = lasterror;
  warning(['Error caught during database creation at item index ' ...
	   num2str(item_index) ': ' err.message '. Truncating database.']);
  params(row_index:size(params, 1), :) = [];
  tests(row_index:size(tests, 1), :) = [];
end

end_time = cputime;

disp(sprintf('Elapsed time took %.2f seconds.', end_time - start_time));

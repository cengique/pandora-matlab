function [params, param_names, tests, test_names] = readDBItems(obj)

% readDBItems - Reads all items to generate a params_tests_db object.
%
% Usage:
% [params, param_names, tests, test_names] = readDBItems(obj)
%
% Description:
%   This is a specific method to convert from physiol_cip_traceset_fileset to
% a params_tests_db, or a subclass. 
% Outputs of this function can be directly fed to the constructor of
% a params_tests_db or a subclass.
%
%   Parameters:
%	obj: A physiol_cip_traceset_fileset 
%		
%   Returns:
%	params, param_names, tests, test_names: See params_tests_db.
%
% See also: params_tests_db, params_tests_fileset, itemResultsRow
  %	    testNames, paramNames, physiol_cip_traceset_fileset
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/11/24

%# Collect info for generating the DB
num_items = length(get(obj, 'list'));
rows = 0;

%# For loop to figure out the number of rows in database
for item_num=1:num_items 
    item = getItem(obj, item_num);
    rows = rows+ length(get(item, 'list'));
end

%# Get generic fileset information from the first traceset item
first_item = getItem(obj, 1);
param_names = paramNames(first_item);
param_names = { param_names{:}, 'NeuronId' };
test_names = testNames(first_item);

%# Preallocating matrices dramatically speeds up the filling process
params = repmat(NaN, rows, length(param_names));
tests = repmat(NaN, rows, length(test_names));

%# Batch process all items
start_time = cputime;

print(java.lang.System.out, 'Reading: ');

rows = 1;
for item_num=1:num_items
  %print(java.lang.System.out, [ num2str(item_num) ', ' ]);
  %if mod(item_num, 20) == 0
  %  disp(' ');
  %end

  item = getItem(obj, item_num);

  disp(get(item , 'id'));

  [item_params, tmp_param_names, item_tests, tmp_test_names] = readDBItems(item);
  num_traces = length(get(item, 'list'))

  row_range = rows : (rows + num_traces - 1);
  params(row_range, :) = [item_params, repmat(item_num, num_traces,1) ];
  tests(row_range, :) = item_tests;
  rows = rows + num_traces;
end

end_time = cputime;

disp(sprintf('Elapsed time took %.2f seconds.', end_time - start_time));



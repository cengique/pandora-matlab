function [params, param_names, tests, test_names] = readDBItems(obj, items)

% readDBItems - Reads all items to generate a params_tests_db object.
%
% Usage:
% [params, param_names, tests, test_names] = readDBItems(obj, items)
%
% Description:
%   This is a specific method to convert from physiol_cip_traceset_fileset to
% a params_tests_db, or a subclass. 
% Outputs of this function can be directly fed to the constructor of
% a params_tests_db or a subclass.
%
%   Parameters:
%	obj: A physiol_cip_traceset_fileset 
%	items: (Optional) List of item indices to use to create the db.
%		
%   Returns:
%	params, param_names, tests, test_names: See params_tests_db.
%
% See also: params_tests_db, params_tests_fileset, itemResultsRow
  %	    testNames, paramNames, physiol_cip_traceset_fileset
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/11/24

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('items')
  items = 1:length(get(obj, 'list'));
end

% Collect info for generating the DB
num_items = length(items);
rows = 0;

% For loop to figure out the number of rows in database
for item_num=items 
    item = getItem(obj, item_num);
    rows = rows + length(get(item, 'list'));
end

% Get generic fileset information from the first traceset item
first_item = getItem(obj, 1);
param_names = paramNames(first_item);
param_names = { param_names{:}, 'NeuronId', 'TracesetIndex' };
test_names = testNames(first_item);

% Preallocating matrices dramatically speeds up the filling process
params = repmat(NaN, rows, length(param_names));
tests = repmat(NaN, rows, length(test_names));

% Batch process all items
start_time = cputime;

disp('Reading fileset: ');

rows = 1;
for item_num=items
  item = getItem(obj, item_num);

  disp(['Loading traceset ' get(item , 'id') ' on row ' num2str(item_num) ]);

  [item_params, tmp_param_names, item_tests, tmp_test_names] = readDBItems(item);
  %num_traces = length(get(item, 'list'));
  num_traces = size(item_tests, 1);

  % Read the neuron name from the id field of traceset 
  % and translate to NeuronId
  neuron_id = obj.neuron_idx.(get(item, 'id'));

  if num_traces > 0  % Unless reading traceset failed and truncated
    row_range = rows : (rows + num_traces - 1);
    params(row_range, :) = [item_params, repmat(neuron_id, num_traces,1), ...
			    repmat(item_num, num_traces,1) ];
    tests(row_range, :) = item_tests;
    rows = rows + num_traces;
  end

  % Reading traceset failed and sub-db was truncated
  if num_traces < length(get(item, 'list'))
    % Truncate database here
    params = params(1:rows, :);
    tests = tests(1:rows, :);
    break; % Out of for
  end
end

end_time = cputime;

disp(sprintf('Elapsed time took %.2f seconds.', end_time - start_time));



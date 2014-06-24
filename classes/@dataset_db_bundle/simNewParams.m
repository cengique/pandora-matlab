function [a_bundle, a_new_db, a_new_joined_db] = ...
    simNewParams(a_bundle, a_param_row_db, props)

% simNewParams - Simulates new parameter set and adds it to dataset and DB.
%
% Usage:
% a_prof = simNewParams(a_bundle, a_param_row_db, props)
%
% Parameters:
%   a_bundle: A dataset_db_bundle object.
%   a_db: Rows with new parameters.
%   props: A structure with any optional properties.
%     simFunc: Handle to function to call for simulating the parameter
%     		row db (e.g., @(row_db)).
%
% Returns:
%   a_bundle: The bundle with updated parameters and measures.
%   a_new_db: Newly created rows.
%   a_new_joined_db: Newly created rows joined.
%
% Description:
%
% See also: params_tests_dataset/loadItemProfile
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2014/06/23

% Copyright (c) 2014 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

props = ...
    mergeStructs(defaultValue('props', struct), ...
                 get(a_bundle, 'props'));

a_dataset = get(a_bundle, 'dataset');
dataset_db = get(a_bundle, 'db');
joined_db = get(a_bundle, 'joined_db');
col_names = getColNames(a_param_row_db);

% TODO: recurse for >1 rows
assert(dbsize(a_param_row_db, 1) == 1, 'Only 1 row is supported.');

new_trial = max(dataset_db(:, 'trial')).data + 1;

% add new params to param file
writeParFile(a_param_row_db, a_dataset.props.param_row_filename, ...
             struct('trialStart', new_trial));

% overwrite trial
if any(ismember(col_names, 'trial'))
  a_param_row_db(1, 'trial') = new_trial;
else
  a_param_row_db = ...
      addColumns(a_param_row_db, 'trial', new_trial);
end

% run sim
feval(props.simFunc, a_param_row_db);

% find files with the new trial number
files = dir([a_dataset.path filesep '*_' new_trial '_*' ]);
num_files = length(files);

% add filenames and new params to dataset
a_dataset.list = [ a_dataset.list {files.name} ];
a_dataset.props.param_rows = ...
    [ a_dataset.props.param_rows; ...
      a_param_row_db(1, 1:a_param_row_db.num_params) ];

% each file is an item, get profiles and update bundle
a_new_db = 
    params_tests_db(a_dataset, length(a_dataset.list) + (1:num_files));
a_new_joined_db = ...
    feval(a_bundle.props.joinDBfunc, a_new_db);
    
dataset_db = [ dataset_db; a_new_db ];
joined_db = [ joined_db; a_new_joined_db ];

a_bundle.dataset = a_dataset;
a_bundle.db = dataset_db;
a_bundle.joined_db = joined_db;

% TODO: how to update joined_db?
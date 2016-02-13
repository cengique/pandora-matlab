function [a_bundle, a_new_db, a_new_joined_db] = ...
    simNewParams(a_bundle, a_param_row_db, props)

% simNewParams - Simulates new parameter set and adds it to dataset and DB.
%
% Usage:
% [a_bundle, a_new_db, a_new_joined_db] = simNewParams(a_bundle, a_param_row_db, props)
%
% Parameters:
%   a_bundle: A dataset_db_bundle object.
%   a_db: Rows with new parameters.
%   props: A structure with any optional properties.
%     simFunc: Handle to function to call for simulating the parameter
%     		row db (e.g., @(row_db)).
%     trial: Trial number for new parameter set. It also indicates
%     		parallel mode, which does not alter existing files, but instead
%     		creates new files with this trial number suffix.
%     writePar: If 1, create a new par file (default=0).
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

precision = getFieldDefault(props, 'precision', 6);

% save precision in dataset
a_bundle.dataset.props.precision = precision;

a_dataset = get(a_bundle, 'dataset');
dataset_db = get(a_bundle, 'db');
joined_db = get(a_bundle, 'joined_db');
col_names = getColNames(a_param_row_db);

% TODO: recurse for >1 rows
assert(dbsize(a_param_row_db, 1) == 1, 'Only 1 row is supported.');

if ~ isempty(a_dataset.path)
  dataset_path = [ a_dataset.path ];
else
  dataset_path = '.';
end

ind_mode = false;
if isfield(props, 'trial')
  new_trial = props.trial;
  ind_mode = true;
  trial_name = [ dataset_path filesep 'trial_' num2str(new_trial, precision) '_' ];
  %trial_dir = [ a_bundle.dataset.path filesep 'trial_' new_trial filesep ];
else
  new_trial = get(max(dataset_db(:, 'trial')), 'data') + 1;
  trial_name = '';
  %trial_dir = '';
end

% make sure the dataset path exists before writing
if ~ exist(a_dataset.path, 'dir')
  [s, msg, msg_id] = mkdir(a_dataset.path);
  assert(s, [ 'Failed to create dataset path: ' msg ]);
end

% add new params to param file
if isfield(props, 'writePar') && props.writePar == 1

  % check if param_row_filename already has path. Otherwise path is
  % repeated.
  [path, name, ext] = fileparts(a_dataset.props.param_row_filename);
  if exist(path, 'dir')
    param_file = a_dataset.props.param_row_filename;
  else
    param_file = [ trial_name a_dataset.props.param_row_filename ];
  end
  writeParFile(a_param_row_db, param_file, ...
               struct('trialStart', new_trial));
end

% overwrite trial
if any(ismember(col_names, 'trial'))
  a_param_row_db(1, 'trial') = new_trial;
else
  a_param_row_db = ...
      addColumns(a_param_row_db, 'trial', new_trial);
end

% run sim, files are written under directory in .g file, hopefully that's
% the same as what's in the dataset
feval(props.simFunc, a_param_row_db);

% find files with the new trial number (use 6 digits to match with
% Genesis)
file_pattern = [dataset_path filesep '*_' num2str(new_trial, precision) '.genflac' ];
files = dir(file_pattern);
num_files = length(files);
assert(num_files > 0, ...
       [ 'Simulation resulted in no new files matching "' ...
         file_pattern '"! Aborting.' ]);

if ind_mode
  % only output the new trial data, erase previous items
  a_dataset.list = [ {files.name} ];
  a_dataset.props.param_names = ...
      getColNames(a_param_row_db);
  a_dataset.props.param_rows = ...
    [ get(a_param_row_db(1, 1:a_param_row_db.num_params), 'data') ];

  dataset_db = ...
      params_tests_db(a_dataset, 1:num_files);
  joined_db = ...
      feval(a_bundle.props.joinDBfunc, dataset_db);

else
  % add filenames and new params to dataset and update the bundle
  a_dataset.list = [ a_dataset.list {files.name} ];
  a_dataset.props.param_rows = ...
      [ a_dataset.props.param_rows; ...
        get(a_param_row_db(1, 1:a_param_row_db.num_params), 'data') ];
  
  % each file is an item, get profiles and update bundle
  a_new_db = ...
      params_tests_db(a_dataset, length(a_dataset.list) - num_files + (1:num_files));
  a_new_joined_db = ...
      feval(a_bundle.props.joinDBfunc, a_new_db);
    
  dataset_db = [ dataset_db; a_new_db ];
  joined_db = [ joined_db; a_new_joined_db ];
end
  
a_bundle.dataset = a_dataset;
a_bundle.db = dataset_db;
a_bundle.joined_db = joined_db;

% save bundle now if in independent mode
if ind_mode
  save([ trial_name 'bundle.mat' ], 'a_bundle');
end
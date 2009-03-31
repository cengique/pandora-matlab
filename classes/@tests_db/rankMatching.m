function a_ranked_db = rankMatching(db, crit_db, props)

% rankMatching - Create a ranking db of row distances of db to given criterion db.
%
% Usage:
% a_ranked_db = rankMatching(db, crit_db, props)
%
% Description:
%   crit_db can be created with the matchingRow method. TestWeights modify the importance 
% of each measure.
%
%   Parameters:
%	db: A tests_db to rank.
%	crit_db: A tests_db object holding the match criterion tests and stds.
%	props: A structure with any optional properties.
%	  limitSTD: limit any measure to this many STDs max.
%	  tolerateNaNs: If 0, rows with any NaN values are skipped
%	  	, if 1, NaN values are given a fixed 3xSTD penalty (default=1).
%	  testWeights: Structure array associating tests and multiplicative weights.
%	  restoreWeights: Reverse the testWeights application after
%	  		calculating distances.
%	  topRows: If given, only return this many of the top rows.
%	  useMahal: Use the Mahalonobis distance from the covariance
%	  	    matrix in crit_db.
%		
%   Returns:
%	a_ranked_db: A ranked_db object.
%
% See also: matchingRow, tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/08

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct([]);
end

% If not exists, add RowIndex column
if isfield(db.col_idx, 'RowIndex')
  row_db = onlyRowsTests(db, ':', 'RowIndex');
  row_index = row_db.data;
else
  row_index = (1:dbsize(db, 1))';
end

crit_tests = fieldnames(crit_db.col_idx);
if isa(crit_db, 'params_tests_db')
  % If params_tests_db ignore params
  crit_tests = {crit_tests{(get(crit_db, 'num_params') + 1):dbsize(crit_db, 2)}};
end

itemIndices = strmatch('ItemIndex', crit_tests);

% Strip out the NeuronId, RowIndex, and ItemIndex columns from criterion db
crit_tests = setdiff(crit_tests, {'NeuronId', 'RowIndex', crit_tests{itemIndices}});

% Use only non-NaN values available in the criterion
crit_row_db = onlyRowsTests(crit_db, 1, crit_tests);
nonnans = ~ isnan(crit_row_db.data);
crit_tests = crit_tests(nonnans);

% Vectorize diff over cols and do the diff^2
%####

% Replicate 1st row of crit_db
first_row = onlyRowsTests(crit_db, 1, crit_tests);

% Weigh according to 2nd row of crit_db
second_row = onlyRowsTests(crit_db, 2, crit_tests);
second_row_data = second_row.data;

if isfield(props, 'testWeights')
  tests_weights = props.testWeights;
elseif isfield(crit_db.props, 'testWeights')
  tests_weights = crit_db.props.testWeights;
end

if exist('tests_weights', 'var')
  [weighted_tests_names weights_order] = ...
      intersect(fieldnames(tests_weights), crit_tests);
  if ~ isempty(weighted_tests_names)
    weights_cell = struct2cell(tests_weights);
    weights_tests = tests2cols(second_row, weighted_tests_names);
    second_row_data(weights_tests) = ...
        second_row_data(weights_tests) ./ cell2mat(weights_cell(weights_order)');
  end
end

% Filter relevant columns, subtract from db and weight
% (do all at once without using temporary variables to save memory)

% Measure differences
wghd_data = get(onlyRowsTests(db, ':', crit_tests), 'data') - (ones(dbsize(db, 1), 1) * first_row.data);

% Replicate STD row for all
second_row_matx = ones(dbsize(db, 1), 1) * second_row_data;

% Look for NaN & Inf values
nans = isnan(wghd_data) | isinf(wghd_data);
% default is to penalize for NaNs
if ~ isfield(props, 'tolerateNaNs') || props.tolerateNaNs == 1
  % penalize NaNs by replacing NaNs with 3 for 3 STDs difference 
  wghd_data(nans) = 3 * second_row_matx(nans); 
else
  % ignore NaNs by skipping them and count the non-NaN values to normalize the SS
  wghd_data(nans) = 0; % Replace NaNs with 0s
end


if isfield(props, 'useMahal')
  % Use Mahalonobis distance that factors in the covariations between measures
  wghd_data = wghd_data * inv(get(onlyRowsTests(crit_db.props.cov, crit_tests, crit_tests), 'data'));
else
  % normalized scale-invariant distance by dividing with STDs
  % (equivalent to Mahalonobis distance if measures were independent)
  wghd_data = wghd_data ./ second_row_matx;
end

if isfield(props, 'limitSTD') 
  % limit any measure to this many STDs max
  exceedingSTDs = wghd_data > props.limitSTD;
  wghd_data(exceedingSTDs) = props.limitSTD;
end

% Sum of absolute error: distance measure
ss_data = abs(wghd_data);

if ~ isfield(props, 'tolerateNaNs') || props.tolerateNaNs == 1
  ss_data = sum(ss_data, 2) ./ size(ss_data, 2); 
else
  ss_data = sum(ss_data, 2) ./ sum(~nans, 2); % Sum distances and take average of non-NaNs
end

% clear those no longer needed
clear second_row_matx;

% restore original measure errors before weighting
if isfield(props, 'restoreWeights') && exist('tests_weights', 'var')
  if ~ isempty(weighted_tests_names)
    wghd_data(:, weights_tests) = ...
        wghd_data(:, weights_tests) ./ (ones(size(wghd_data, 1), 1) * ...
                                        cell2mat(weights_cell(weights_order)'));
  end
end


% Ignore NaN rows (note: there must be non NaN rows after the above anyway!)
nans = isnan(ss_data) | isinf(ss_data);
ss_data = ss_data(~nans);
row_index = row_index(~nans);
wghd_data = wghd_data(~nans, :);

% put all into one variable to free the memory for the next step
% Sort increasing with distances
wghd_data = sortrows([wghd_data, ss_data, row_index], size(wghd_data, 2) + 1);

% Prune rest, if requested
if isfield(props, 'topRows')
  wghd_data = wghd_data(1:props.topRows, :);
end

% Create a ranked_db with distances and row indices, sorted with distances
a_ranked_db = ranked_db(wghd_data, ...
			{crit_tests{:}, 'Distance', 'RowIndex'}, db, crit_db, ...
			[ lower(get(db, 'id')) ' ranked to ' ...
			 lower(get(crit_db, 'id')) ], props);

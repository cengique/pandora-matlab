function a_params_db = getBlockedParamRows(a_db, rows, param_indices, num_levels, cip_levels)

% getBlockedParamRows - Blocks given parameters and creates parameter rows in a new db.
%
% Usage:
% a_params_db = getBlockedParamRows(a_db, rows, param_indices, num_levels, cip_levels)
%
% Description:
%   For the given a_db row, reduces each param_indices for num_levels and 
% also adds each value of cip_levels element in a separate row.
%
%   Parameters:
%	a_db: A params_tests_db object.
%	rows: Row indices in a_db from which to take the parameters. 
%	param_indices: Parameter column indices to be varied.
%	num_levels: The number of different parameter levels to be created 
%		    (not including 0 level)
%	cip_levels: The pAcip parameter values to be added to each new parameter row.
%
%   Returns:
%	a_params_db: A db only with params.
%
%   Example:
%	First get ranked_db:
%	>> ranked_for_gps0501a_db = joinOriginal(rankMatching(sdball, matchingRow(mini_ttx_control_rsrdb, 1)))
%	Then, get blocked parameters for the first (best-matching) row
%	>> blocked_rows_db = getBlockedParamRows(ranked_for_gps0501a_db, 1, [1, 2], 10, [-100 100]);
%
% See also: ranked_db/blockedDistances, params_tests_db/getParamRowIndices
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/01/14

%# TODO: Change its name to blocked_param_db

%# Add a new cip column if doesn't exist
if ismember(fieldnames(get(a_db, 'col_idx')), 'pAcip')
  cip = true(1);
  ifpAcip = {}; %# No new column
elseif exist('cip_levels')
  cip = true(1);
  ifpAcip = { 'pAcip' }; %# Add a new column
else
  cip = false(1);
  cip_levels = NaN;
  ifpAcip = {}; %# No new column
end

total_rows = length(rows) * (num_levels + 1) * length(cip_levels);
num_params = get(a_db, 'num_params');

out_data = repmat(NaN, total_rows, num_params + length(ifpAcip));

out_row = 1;
for row_num=1:length(rows)
  for level_num=0:num_levels
    for cip_level=1:length(cip_levels)
      dbdata = get(a_db, 'data');
      row_contents = dbdata(rows(row_num), 1:num_params);
      row_contents(param_indices) = row_contents(param_indices) * level_num / num_levels;
      if cip
	if isempty(ifpAcip)
	  row_contents(end) = cip_levels(cip_level);
	else
	  row_contents(end + 1) = cip_levels(cip_level);
	end
      end
      out_data(out_row, 1:(num_params + length(ifpAcip))) = row_contents;
      out_row = out_row + 1;
    end
  end
end

test_names = fieldnames(get(a_db, 'col_idx'));
a_params_db = params_tests_db(out_data, {test_names{1:a_db.num_params}, ...
					 ifpAcip{:}}, [], {}, ...
			      [ get(a_db, 'id') ' blocked parameters' ], ...
			      get(a_db, 'props'));
function a_db = blockedDistances(a_ranked_db, rows, blocked_db, blocked_param_indices, ...
				 block_levels, crit_db)

% blockedDistances - Creates a db of distances to blocked versions of top ranks.
%
% Usage:
% a_db = blockedDistances(a_ranked_db, rows, blocked_db, blocked_param_indices, 
%			  block_levels, crit_db)
%
% Description:
%
%   Parameters:
%	a_ranked_db: A ranked_db object.
%	rows: Use the given row rankings.
%	blocked_db: db with blocked versions of original ranks.
%	blocked_param_indices: Indices of parameters to be blocked.
%	block_levels: Number of parameter levels for blocking.
%	crit_db: Calculate distance from this criterion.
%		
%   Returns:
%	a_db: A tests_db object with the matrix of distances.
%
% See also: getBlockedParamRows, getParamRowIndices
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/01/14

if ~exist('rows')
  rows = 1:5;
end

%# First joinOriginal
joined_db = joinOriginal(a_ranked_db);

data = repmat(NaN, length(rows), block_levels + 1);

out_row = 1;
for row_num=rows
  %# Get blocked parameter scan
  blocked_rows_db = getBlockedParamRows(joined_db, row_num, blocked_param_indices, ...
					block_levels)

  displayRow(blocked_rows_db)

  %# Find matching indices
  row_indices = getParamRowIndices(blocked_rows_db, ':', blocked_db)

  %# Get matching rows in a new db
  this_blocked = onlyRowsTests(blocked_db, row_indices(~isnan(row_indices)), ':');

  %# rank it
  this_ranked = rankMatching(this_blocked, crit_db);

  %# reorder with RowIndex
  this_ranked = sortrows(this_ranked, 'RowIndex');

  %# Get the distances
  this_dists = onlyRowsTests(this_ranked, ':', 'Distance');

  size(data(out_row, ~isnan(row_indices)))
  dbsize(this_dists)

  data(out_row, ~isnan(row_indices)) = get(this_dists, 'data')';
  out_row = out_row + 1;
end

%# Test names not necessary?
%#names(1:block_levels) = num2cell(1:block_levels);

a_db = tests_db(data, {}, {}, ['Distance matrix for blockers on rankings in ' ...
			       get(a_ranked_db, 'id') ] );
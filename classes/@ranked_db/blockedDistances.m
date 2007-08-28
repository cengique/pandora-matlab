function [a_db, ranked_dbs] = ...
      blockedDistances(a_ranked_db, rows, blocked_db, blocked_param_indices, ...
		       block_levels, crit_db)

% blockedDistances - Creates a db of distances to blocked versions of top ranks.
%
% Usage:
% [a_db, ranked_dbs] = 
%   blockedDistances(a_ranked_db, rows, blocked_db, blocked_param_indices, 
%	  	     block_levels, crit_db)
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
%	ranked_dbs: A cell array of ranked_dbs for each row.
%
%   Example:
%	>> dist_matx_db = blockedDistances(rankMatching(super_db, matchingRow(rsuper_phys_db, 20)), 1:5, super_blocker_db, [1 2], 10, matchingRow(rsuper_phys_db, 21))
%
%       where super_db is a simulation dual-cip database and rsuper_phys_db is a physiology dual-cip database.
%
% See also: makeModifiedParamDB, getParamRowIndices
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/01/14

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~exist('rows')
  rows = 1:5;
end

%# First joinOriginal
joined_db = joinOriginal(a_ranked_db);

data = repmat(NaN, length(rows), block_levels + 1);
row_names = cell(1, length(rows));
ranked_dbs = cell(1, length(rows));

%# For each of the rows from a_ranked_db
out_row = 1;
for row_num=rows
  %# Get blocked parameter scan
  blocked_rows_db = makeModifiedParamDB(joined_db, row_num, blocked_param_indices, ...
					block_levels);
  %#displayRows(blocked_rows_db)

  %# Find matching indices
  row_indices = getParamRowIndices(blocked_rows_db, ':', blocked_db);

  %# Get matching rows in a new db
  this_blocked = onlyRowsTests(blocked_db, row_indices(~isnan(row_indices)), ':');

  %# rank it
  this_ranked = rankMatching(this_blocked, crit_db); %#, a_ranked_db.props

  %# reorder with RowIndex
  this_ranked = sortrows(this_ranked, 'RowIndex');
  ranked_dbs{out_row} = this_ranked;

  %# Get the distances
  this_dists = onlyRowsTests(this_ranked, ':', 'Distance');
  %#displayRows(this_dists)

  %#size(data(out_row, ~isnan(row_indices)))
  %#dbsize(this_dists)

  data(out_row, ~isnan(row_indices)) = get(this_dists, 'data')';

  %# Decoration
  row_names{out_row} = [ 'Rank_' num2str(row_num) ];

  out_row = out_row + 1;
end

%# Test names not necessary?
%#names(1:block_levels) = num2cell(1:block_levels);

%# Column names
col_names = cell(1, block_levels + 1);
orig_names = fieldnames(joined_db.col_idx);
for block=0:block_levels
  col_names{block + 1} = [ sprintf('%s_%d_Percent', ...
				   orig_names{blocked_param_indices(1)}, ...
				   block * 100 / block_levels)  ];
end

a_db = tests_db(data, col_names, row_names, ...
		['Distance matrix for blockers of rankings in ' ...
		 get(a_ranked_db, 'id') ] );
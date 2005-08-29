function a_ranked_db = rankVsDB(a_db, crit_db)

% rankVsDB - Generates a ranking DB by comparing rows of this db with the given test criteria.
%
% Usage:
% a_ranked_db = rankVsDB(a_db, crit_db)
%
% Description:
%   Distance is each measure difference divided by the STD in to_db, squared and
% summed. Returned DB contains only the selected tests from crit_db and the parameters
% from initial a_db.
%
%   Parameters:
%	a_db: A params_tests_db object to compare rows from.
%	crit_db: A tests_db object holding the match criterion tests and STDs
%		 which can be created with matchingRow.
%
%   Returns:
%	a_ranked_db: The created DB with original rows and a distance measure, 
%		   in ascending order. 
%
% See also: matchingRow, rankMatching, joinRows
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/20

%# Generate a criterion DB
%# to_tests: [2, 5:12, 14:23, 28, 30:31, 37:38]

%# TODO: take crit_db as parameter in this func, then compute match to avg neuron
%#crit_db = matchingRow(to_db, to_row, to_tests);

%# Get rankings from criterion
dist_db = rankMatching(a_db, crit_db);

min_distance = min(dist_db(:, 'Distance').data);
avg_distance = mean(dist_db(:, 'Distance'));
max_distance = max(dist_db(:, 'Distance').data);

%# Take all criterion columns and parameter columns from original db
%# TODO: that may need to be instructed to joinOriginal from here.
a_ranked_db = joinOriginal(dist_db);

%# a=displayRows(a_ranked_db, 1:10)
%# s = cell2TeX(a)

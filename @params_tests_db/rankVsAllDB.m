function tex_string = rankVsAllDB(a_db, to_db, a_dataset, to_dataset)

% rankVsAllDB - Generates a ranking DBs by comparing rows of this db with all rows of given DB.
%
% Usage:
% tex_string = rankVsAllDB(a_db, to_db, a_dataset, to_dataset)
%
% Description:
%   Distance is each measure difference divided by the STD in to_db, squared and
% summed. Returned DB contains only the selected to_tests and the parameters
% from initial DB.
%
%   Parameters:
%	a_db: A params_tests_db object to compare rows from.
%	to_db: A tests_db object to compare it with.
%	a_dataset: Dataset for a_db.
%	to_dataset: Dataset for crit_db.
%
%   Returns:
%	ranked_dbs: Array of created DBs with original rows and a distance 
%		   measure, in ascending order. 
%	tex_string: A LaTeX string for all tables created.
%
% See also: rankVsDB, matchingRow, rankMatching, joinRows
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/10

tex_string = '';

%# Generate a tests list without the ItemIndex column (why??)
tests_wo_index(1:dbsize(to_db, 2)) = true(1);
%#tests_wo_index(tests2cols(to_db, {'ItemIndex'})) = false(1);

%# List all target db rows in a table
for row_num=1:10:dbsize(to_db, 1)
  tex_string = [ tex_string ...
		displayRowsTeX(onlyRowsTests(to_db, ...
					     row_num:min((row_num + 9), ...
							 dbsize(to_db, 1)), ':')) ];
end

%# List target db mean and std
stats_db = statsMeanStd(to_db, tests_wo_index);
tex_string = [ tex_string displayRowsTeX(stats_db, '', struct('height', '!')) ];

%# Show 10 best matches to average neuron
%# Stats DB contains means and STDs in first and second row like crit_db
tex_string = [tex_string displayRankingsTeX(a_db, stats_db)];

%# Show best 10 matches from this db for each row of target db
[ ranked_dbs(1:dbsize(to_db, 1)) ] = deal(params_tests_db); %# preallocate
for row_num=1:dbsize(to_db, 1)
  crit_db = matchingRow(to_db, row_num, tests_wo_index);

  if exist('a_dataset') && exist('to_dataset')
    tex_string = [tex_string ...
		  displayRankingsTeX(a_db, crit_db, ...
				     struct('a_dataset', a_dataset, ...
					    'crit_dataset', to_dataset))];
  else 
    tex_string = [tex_string displayRankingsTeX(a_db, crit_db)];
  end
end

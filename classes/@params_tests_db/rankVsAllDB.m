function tex_string = rankVsAllDB(a_db, to_db, a_dataset, to_dataset)

% rankVsAllDB - Generates ranking DBs by comparing rows of a_db with each row of to_db.
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
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/10

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

tex_string = '';

% Generate a tests list without the ItemIndex column (why??)
tests_wo_index(1:dbsize(to_db, 2)) = true(1);
%tests_wo_index(tests2cols(to_db, {'ItemIndex'})) = false(1);

% List all target db rows in a table
rows_per_page = 10;
for row_num=1:rows_per_page:dbsize(to_db, 1)
  rows = row_num:min((row_num + 9), dbsize(to_db, 1));
  if length(rows) < rows_per_page
    page_props = struct('height', '!');
  else
    page_props = struct;
  end

  tex_string = [ tex_string ...
		displayRowsTeX(onlyRowsTests(to_db, rows, ':'), '', page_props) ];
end

% List target db mean and std
stats_db = statsMeanStd(to_db, tests_wo_index);
tex_string = [ tex_string displayRowsTeX(stats_db, '', struct('height', '!')) ];

% Show 10 best matches to average neuron
% Stats DB contains means and STDs in first and second row like crit_db
tex_string = [tex_string displayRankingsTeX(a_db, stats_db)];

% Show best 10 matches from this db for each row of target db
[ ranked_dbs(1:dbsize(to_db, 1)) ] = deal(params_tests_db); % preallocate
for row_num=1:dbsize(to_db, 1)
  crit_db = matchingRow(to_db, row_num, tests_wo_index);

  if exist('a_dataset', 'var') && exist('to_dataset', 'var')
    tex_string = [tex_string ...
		  displayRankingsTeX(a_db, crit_db, ...
				     struct('a_dataset', a_dataset, ...
					    'crit_dataset', to_dataset))];
  else 
    tex_string = [tex_string displayRankingsTeX(a_db, crit_db)];
  end
end

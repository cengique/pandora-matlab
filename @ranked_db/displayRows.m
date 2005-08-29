function s = displayRows(db, rows)

% displayRows - Displays a row of data with associated column labels.
%
% Usage:
% s = displayRows(db, rows)
%
% Description:
%
%   Parameters:
%	db: A tests_db object.
%	rows: Indices of rows in db.
%		
%   Returns:
%	s: A structure of column name and value pairs.
%
% See also: tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/15

if ~ exist('rows')
  rows = ':';
end

%# Join with original here. Only joins the requested rows.
joined_db = joinOriginal(db, rows);
joined_data = joined_db.data;

%# Ignore NeuronId?
crit_cols = fieldnames(db.crit_db.col_idx);
all_test_cols(1:length(crit_cols)) = true(1);
if any(ismember(crit_cols, 'NeuronId'))
  all_test_cols(tests2cols(db.crit_db, 'NeuronId')) = false(1);
end
crit_cols = {crit_cols{all_test_cols}};

%# Insert crit_db's values in proper columns
cols = tests2cols(joined_db, crit_cols);
[critcol{1:dbsize(joined_db, 2), 1}] = deal(''); %# value doesn't exist
cells = num2cell(db.crit_db.data(1, tests2cols(db.crit_db, crit_cols)));
[critcol{cols}] = deal(cells{:}); %# Fill available values from crit_db

%# Make a cell array out of db contents
s = cat(2, fieldnames(get(joined_db, 'col_idx')), critcol);
names = {'', 'Criterion'};

%# The distance values for each individual measure has the same names in ranked_db
%# Find columns in ranked_db that are also in joined_db except 'Distance'
common_cols = setdiff(intersect(fieldnames(joined_db.col_idx), ...
				fieldnames(get(db, 'col_idx'))), ...
		      {'Distance', 'RowIndex'});

%# Go through all rows and generate cell array
for row_num = 1:dbsize(joined_db, 1)
  [distcol{1:dbsize(joined_db, 2), 1}] = deal(''); %# value doesn't exist
  for dist_num = 1:length(common_cols)
    %# Create (+00.00) formatted contents for distance values
    col = tests2cols(joined_db, common_cols{dist_num});
    distcol{col, 1} = sprintf('(%+2.2f)', ...
			      get(onlyRowsTests(db, row_num, common_cols(dist_num)), 'data'));
  end
  s = cat(2, s, num2cell(joined_data(row_num, :)'), distcol);
  names = {names{:}, ['Rank ' num2str(row_num) ], ''};
end

%# Add row names
s = cat(1, names, s);

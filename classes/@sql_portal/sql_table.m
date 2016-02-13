function sql_table(a_sql_portal, a_tests_db, table_label, props)

% sql_table - Create an SQL table from the contents of a tests_db object.
%
% Usage:
% sql_table(a_sql_portal, a_tests_db, table_label, props)
%
% Description:
%   Converter function to get a tests_db object properly annotated with
% the metadata obtained from the results of the executed SQL
% query. Currently this function is limited to importing numeric data only.
%
%   Parameters:
%	a_sql_portal: A sql_portal object.
%	a_tests_db: A tests_db object.
%	table_label: Name of the newly created table.
%	props: A structure with any optional properties.
%		
%   Returns:
%
% See also: tests_db/tests_db, database, sql_portal/tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2008/12/17

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% TODO: put warning if table exists, make it an option to drop it

% verbose warnings
vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

if ~exist('props', 'var')
  props = struct;
end

% create the table
col_names = getColNames(a_tests_db);

% make a query
query_string = ...
    ['Create table ' table_label ' ('];

comma_str = '';
for col_name = col_names
  col_name = col_name{1};
  % double-precision columns by default
  query_string = ...
      [ query_string comma_str sprintf('\n') col_name ' double' ];
  comma_str = ', ';
end

query_string = [ query_string ');' ];

% run query
if verbose
  disp(['SQL query: "' query_string '"']);
end

% execute
a_cursor = exec(a_sql_portal.db_conn, query_string);
if ~isempty(strfind(lower(a_cursor.Message), 'error')) && ...
    isempty(strfind(lower(a_cursor.Message), 'commit/rollback'))
  disp(['SQL Query: "' query_string '"']);
  a_cursor
  error(['Error in SQL query:' sprintf('\n') a_cursor.Message]);
end

% write data
insert(a_sql_portal.db_conn, table_label, col_names, ...
       get(a_tests_db, 'data'));

% how to check for error??
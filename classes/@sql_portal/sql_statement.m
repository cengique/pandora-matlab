function response_str = sql_statement(a_sql_portal, statement_string, props)

% sql_statement - Run an SQL statement and discard its results.
%
% Usage:
% response_str = sql_statement(a_sql_portal, statement_string, props)
%
% Parameters:
%	a_sql_portal: A sql_portal object.
%	statement_string: An SQL statement that does not return data.
%	props: A structure with any optional properties.
%		
% Returns:
%	response_str: Response string from the SQL engine.
%
% Description:
%   This function is for sending SQL statements that do not return any data,
% for such functions as inserting data into a database, creating views, and
% running administration commands. See sql_portal/tests_db to import select
% query results into Pandora.
%
% See also: sql_portal/tests_db, database
%
% $Id: sql_statement.m 818 2007-08-28 20:28:51Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2008/04/18

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% verbose warnings
vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

if ~exist('props', 'var')
  props = struct;
end

% run query
if verbose
  disp(['SQL query: "' statement_string '"']);
end

a_cursor = exec(a_sql_portal.db_conn, statement_string);

if verbose
  a_cursor
end

response_str = a_cursor.Message;

% check for errors, but ignore spurious (?) rollback/commit problems
if ~isempty(strfind(lower(response_str), 'error')) && ...
    isempty(strfind(lower(response_str), 'rollback'))
  disp(['SQL Query: "' statement_string '"']);
  a_cursor
  error(['Error in SQL query:' sprintf('\n') a_cursor.Message]);
end

if ~isnumeric(a_cursor.Cursor)
  close(a_cursor);
end

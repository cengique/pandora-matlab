function a_db = tests_db(a_sql_portal, query_string, query_id, props)

% tests_db - Create a tests_db object from the results of a SQL query.
%
% Usage:
% a_db = tests_db(a_sql_portal, query_string, props)
%
% Description:
%   Converter function to get a tests_db object properly annotated with
% the metadata obtained from the results of the executed SQL
% query. Currently this function is limited to importing numeric data only.
%
%   Parameters:
%	a_sql_portal: A sql_portal object.
%	query_string: An SQL query returning numeric results.
%	query_id: Identifier associated witht the query, to be passed
%		  into the tests_db object.
%	props: A structure with any optional properties passed to tests_db.
%		
%   Returns:
%	a_db: A tests_db object.
%
% See also: tests_db, database
%
% $Id: tests_db.m 818 2007-08-28 20:28:51Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2007/11/29

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~exist('props', 'var')
  props = struct;
end

% only numeric data
setdbprefs('DataReturnFormat','numeric');

% run query
a_cursor = cursor(a_sql_portal.db_conn, query_string);

if strfind(lower(a_cursor.Message), 'error')
  error(['Error in SQL query:' sprintf('\n') a_cursor.Message]);
end

% get the data
a_cursor = fetch(a_cursor);

% get names (only after fetching)
attrs = attr(a_cursor);
col_names = { attrs.fieldName };

% create the tests_db object
a_db = tests_db(a_cursor.Data, col_names, {}, query_id, props);

close(a_cursor);
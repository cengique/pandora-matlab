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

% verbose warnings
vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

if ~exist('props', 'var')
  props = struct;
end

% only numeric data
setdbprefs('DataReturnFormat','numeric');

% run query
if verbose
  disp(['SQL query: "' query_string '"']);
end

conn = a_sql_portal.db_conn.Handle;
use_java_direct = false;

if use_java_direct
  % use java directly
  stmt = ...
      conn.createStatement(java.sql.ResultSet.TYPE_SCROLL_INSENSITIVE, ...
                           java.sql.ResultSet.CONCUR_READ_ONLY);
  stmt.setFetchSize(10);                  % test/debug
                                          % stmt.setMaxRows(10);
                                          %% test/debug
  stmt.setQueryTimeout(24 * 3600);        % 24 hours
  rs = stmt.executeQuery(query_string);
  
  % go to last row
  if last(rs) ~= true 
    error('Cannot move cursor to end of query result set.');
  end

  num_rows = getRow(rs);
  rsm = getMetaData(rs);
  num_cols = getColumnCount(rsm);

  if verbose
    num_cols, num_rows
  end

  % go back to beginning
  beforeFirst(rs);

  % allocate space for incoming data
  new_data = repmat(NaN, num_rows, num_cols);

  % read in parts
  max_read = 256 * 1024 * 1024; % bytes
  max_rows = floor(max_read / 8 / num_cols); % for double precision

  if verbose
    max_rows
  end

else
  a_cursor = cursor(a_sql_portal.db_conn, query_string);

  if strfind(lower(a_cursor.Message), 'error')
    disp(['SQL Query: "' query_string '"']);
    a_cursor
    error(['Error in SQL query:' sprintf('\n') a_cursor.Message]);
  end
end


if use_java_direct
  % TODO: go back to original! this is ten times slower!
  % need to write native java code to make it faster
  
  % read all rows in resultset
  row_num = 1;
  while next(rs)
    for col_num = 1:num_cols
      new_data(row_num, col_num) = rs.getDouble(col_num);
    end
    row_num = row_num + 1;
  end

  col_names = {};
  rsm = getMetaData(rs);
  for col_num = 1:num_cols
    col_names{col_num} = char(rsm.getColumnName(col_num));
  end

  % clean up database objects
  rs.close();
  stmt.close();

else

  % analyze the output
  % get the Java object directly, Database Toolbox sucks
  %rs = a_cursor.ResultSet;
  
  % how to get num_rows before executing query??
  
  % do in a single batch for now
  % get the data
  a_cursor = fetch(a_cursor);
  new_data = a_cursor.Data;
  
% $$$   for batch_num = 1:ceil(num_rows / max_rows)
% $$$     % get the data
% $$$     a_cursor = fetch(a_cursor, max_rows);
% $$$     
% $$$     start_row = (batch_num - 1) * max_rows + 1;
% $$$     if verbose
% $$$       start_row
% $$$     end
% $$$     new_data(start_row:(start_row + min(max_rows, size(a_cursor.Data, 1)) - 1), :) = ...
% $$$         a_cursor.Data;
% $$$   end

  % get names (only after fetching)
  attrs = attr(a_cursor);
  col_names = { attrs.fieldName };

  % free resources. important! otherwise java runs out of memory very quickly.
  close(a_cursor);
end 

% create the tests_db object
a_db = tests_db(new_data, col_names, {}, query_id, props);



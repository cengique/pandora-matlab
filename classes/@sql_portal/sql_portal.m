function obj = sql_portal(db_conn, id, props)

% sql_portal - For import and export to external SQL engines using the Matlab Database Toolbox.
%
% Usage:
% obj = sql_portal(db_conn, id, props)
%
% Description:
%   Uses the Database (DB) Toolbox's connection object to read and write to
% external SQL engines.
%
%   Parameters:
%	db_conn: An object of the database class of the DB Toolbox.
%	id: An identifying string.
%	props: A structure with any optional properties.
%		
%   Returns a structure object with the following fields:
%	db_conn: The DB Toolbox connection object.
%	id, props.
%
% General operations on sql_portal objects:
%   sql_portal	- Construct a new sql_portal object.
%   tests_db	- Create a tests_db object from the result of an SQL query.
%
% Additional methods:
%	See methods('sql_portal')
%
% See also: tests_db, database
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2007/11/29

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 % Called with no params
   obj.db_conn = [];
   obj.id = '';
   obj.props = struct([]);
   obj = class(obj, 'sql_portal');
 elseif isa(db_conn, 'sql_portal') % copy constructor?
   obj = db_conn;
 else

   % set some db parameters
   logintimeout(5);
  
   % ping the connection to see if it's alive
   ping(db_conn);
   
   if ~ exist('props', 'var')
     props = struct([]);
   end

   obj.db_conn = db_conn;
   obj.id = id;
   obj.props = props;

   obj = class(obj, 'sql_portal');
end


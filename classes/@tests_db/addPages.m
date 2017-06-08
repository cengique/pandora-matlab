function obj = addPages(obj, page_names, page_data)

% addPages - Inserts new pages (third dimension) to a tests_db object.
%
% Usage 1:
% obj = addPages(obj, page_names, page_data)
%
% Usage 2:
% obj = addPages(obj, b_obj)
%
% Parameters:
%   obj, b_obj: A tests_db object.
%   page_names: A single string or a cell array of page names to be
%   		added. IGNORED in tests_db.
%   page_data: Data matrix of pages to be added.
%		
% Returns:
%   obj: The tests_db object that includes the new columns.
%
% Description:
%   Adds new third dimension pages to the database and returns the new
% DB. Page names are not maintained in tests_db; use tests_3D_db instead.
% Usage 2 concatanates two DBs pagewise. This operation is expensive in the
% sense that the whole database matrix needs to be enlarged just to add a
% single new page. The method of allocating a matrix, filling it up, and
% then providing it to the tests_db constructor is the preferred method of
% creating tests_db objects.  This method may be used for measures obtained
% by operating on raw measures.
%
% See also: tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cengique@users.sf.net>, 2017/06/08

% Copyright (c) 2017 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if isa(page_names, 'tests_db')
  to_db = page_names;
  if dbsize(to_db, 1) == 0
    warning('tests_db/addPages: Ignoring empty db');
    return;
  end
  page_data = get(to_db, 'data');
elseif ischar(page_names)
  % if it's a string, just encapsulate in cell array
  page_names = { page_names };
end

if (dbsize(obj, 1) > 0 && size(page_data, 1) ~= dbsize(obj, 1))
  error(['Number of rows in column (' num2str(size(page_data, 1)) ') ', ...
	 'does not match rows in DB (' num2str(dbsize(obj, 1)) ').']);
end

if (dbsize(obj, 2) > 0 && size(page_data, 2) ~= dbsize(obj, 2))
  error(['Number of rows in column (' num2str(size(page_data, 1)) ') ', ...
	 'does not match rows in DB (' num2str(dbsize(obj, 1)) ').']);
end

% check for column consistency
if exist('to_db', 'var')
  [col_names, wcol_names] = checkConsistentCols(obj, to_db);
end

% Add the page(s)
obj.data = cat(3, obj.data, page_data);

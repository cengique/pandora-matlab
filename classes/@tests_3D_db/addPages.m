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
%   page_names: A single string or a cell array of page names to be added.
%   page_data: Data matrix of pages to be added.
%		
% Returns:
%   obj: The tests_db object that includes the new columns.
%
% Description:
%   Adds new third dimension pages to the database and returns the new DB.
% Usage 2 concatanates two DBs pagewise. This operation is 
% expensive in the sense that the whole database matrix needs to be 
% enlarged just to add a single new page. The method of allocating
% a matrix, filling it up, and then providing it to the tests_db 
% constructor is the preferred method of creating tests_db objects. 
% This method may be used for measures obtained by operating on raw measures.
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

if isa(page_names, 'tests_3D_db')
  to_db = page_names;
  if dbsize(to_db, 1) == 0
    warning('tests_3D_db/addPages: Ignoring empty db');
    return;
  end
  page_names = fieldnames(get(to_db, 'page_idx'));
  if ( length(page_names) < dbsize(to_db, 3) )
    page_names = [ page_names, ...
                   cellfun( @(x)['page' num2str(x) ], ...
                            num2cell((dbsize(obj, 3) + length(page_names) + 1):...
                                     (dbsize(obj, 3) + dbsize(to_db, 3))), ...
                            'UniformOutput', false )];
  end
  page_data = get(to_db, 'data');
elseif isa(page_names, 'tests_db')
  to_db = page_names;
  if dbsize(to_db, 1) == 0
    warning('tests_3D_db/addPages: Ignoring empty db');
    return;
  end
  % No page names maintained in tests_db
  page_names = cellfun( @(x)['page' num2str(x) ], ...
                        num2cell((dbsize(obj, 3) + 1):(dbsize(obj, 3) + dbsize(to_db, 3))), ...
                        'UniformOutput', false );
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

if length(page_names) ~= size(page_data, 3)
  error(['Number of page names (' num2str(length(page_names)) ') ', ...
	 'does not match pages in matrix (' num2str(size(page_data, 3)) ').']);
end

existing_cols = ismember(page_names, fieldnames(get(obj, 'col_idx')));
if any(existing_cols)
  error('tests_db:col_exists', ...
	['Column(s) ' page_names{existing_cols} ' already exist in DB.']);
end

% Add the page(s)
new_page_id = dbsize(obj, 3) + 1;
obj = set(obj, 'data', cat(3, get(obj, 'data'), page_data));

% Update the meta-data
new_page_idx = get(obj, 'page_idx');
if isempty(new_page_idx)
  new_page_idx = struct;
end
for page_num = 1:length(page_names)
  new_page_idx.(page_names{page_num}) = new_page_id + page_num - 1;
end

obj = set(obj, 'page_idx', new_page_idx);

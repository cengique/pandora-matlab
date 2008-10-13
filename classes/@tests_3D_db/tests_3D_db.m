function a_3D_db = tests_3D_db(data, col_names, row_names, ...
			       page_names, id, props)

% tests_3D_db - A database multiple pages with rows of test columns. 
%		Each page may represent aspects of the data that are
%		different, but not defined in this object.
%
% Usage:
% a_3D_db = tests_3D_db(data, col_names, row_names, page_names, id, props)
%
% Description:
%   This is a subclass of tests_db. Usually it contains a RowIndex
% column that points to an original db from which this data originated. 
% The row indices can be used to reach the values associated with different
% pages of information contained in this object.
%
%   Parameters:
%	data: The 3-d vector of rows, columns, and pages.
%	col_names: Colun names of the database.
%	id: An identifying string.
%	props: A structure with any optional properties.
%		invarName: Name of the invariant parameter for this db.
%		
%   Returns a structure object with the following fields:
%	tests_db, page_idx.
%
% General operations on tests_3D_db objects:
%   tests_3D_db		- Construct a new tests_3D_db object.
%
% Additional methods:
%	See methods('tests_3D_db')
%
% See also: tests_db, tests_db/invarValues
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/30

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% TODO: merge this class into tests_db. There's no reason to restrict one
% to 2D.

if nargin == 0 % Called with no params
  a_3D_db.page_idx = struct([]);
  a_3D_db = class(a_3D_db, 'tests_3D_db', tests_db);
elseif isa(data, 'tests_3D_db') % copy constructor?
  a_3D_db = data;
elseif isa(data, 'tests_db') % upgrade from tests_db
  a_3D_db.page_idx = struct;
  a_3D_db = class(a_3D_db, 'tests_3D_db', data);
else

   if ~ exist('props', 'var')
     props = struct([]);
   end

   row_names = defaultValue('row_names', {});
   col_names = defaultValue('col_names', {});
   page_names = defaultValue('page_names', {});
   id = defaultValue('id', '');
   
   a_3D_db.page_idx = makeIdx(page_names);

   a_3D_db = class(a_3D_db, 'tests_3D_db', ...
                   tests_db(data, col_names, row_names, id, props));
end


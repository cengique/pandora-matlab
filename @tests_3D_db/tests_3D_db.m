function a_3D_db = tests_3D_db(data, col_names, id, props)

% tests_3D_db - A database multiple pages with rows of test columns. 
%		Each page may represent aspects of the data that are
%		different, but not defined in this object.
%
% Usage:
% a_3D_db = tests_3D_db(data, bins, hist_results, id, props)
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
%	props: A structure any optional properties.
%		
%   Returns a structure object with the following fields:
%	tests_db, props.
%
% General operations on tests_3D_db objects:
%   tests_3D_db		- Construct a new tests_3D_db object.
%   corrCoefs		- Calculate a database of correlation coefficients
%			  between two columns for each page in this db.
%   plotPair		- Create a plot of variation of col1 vs. col2,
%			  superposing each page of data as a separate line.
%
% Additional methods:
%	See methods('tests_3D_db')
%
% See also: tests_db, tests_db/invarValues
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/30

if nargin == 0 %# Called with no params
   a_3D_db.props = struct([]);
   a_3D_db = class(a_3D_db, 'tests_3D_db', tests_db);
 elseif isa(data, 'tests_3D_db') %# copy constructor?
   a_3D_db = data;
 else

   if ~ exist('props')
     props = struct([]);
   end

   a_3D_db.props = props;

   a_3D_db = class(a_3D_db, 'tests_3D_db', ...
		     tests_db(data, col_names, id, props));
end


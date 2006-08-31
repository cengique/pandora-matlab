function obj = assignRowsTests(obj, val, rows, tests, pages)

% assignRowsTests - Assign the values to the tests and rows (and pages) of the tests_db.
%
% Usage:
% obj = assignRowsTests(obj, val, rows, tests, pages)
%
% Description:
% Selects the given dimensions and returns in a new tests_db object.
%
%   Parameters:
%	obj: A tests_db object.
%	val: DB object or data matrix to be assigned to the addressed indices.
%	rows: A logical or index vector of rows. If ':', all rows.
%	tests: Cell array of test names or column indices. If ':', all tests.
%	pages: (Optional) A logical or index vector of pages. ':' for all pages.
%		
%   Returns:
%	obj: The new tests_db object.
%
% See also: subsref, tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/02/08

%# Pages
if ~ exist('tests')
  tests = ':';
end

%# translate tests spec to array form
cols = tests2cols(obj, tests);

%# Pages
if ~ exist('pages')
  pages = ':';
end

%# Accept val as tests_db
if isa(val, 'tests_db')
  val = val.data;
end

%# Check dimensions
val_size = size(val);
num_dims = length(val_size);
addr_size = [length(rows) length(cols) length(pages)];
if addr_size(1:num_dims) ~= val_size
  error(['Dimension mismatch in assignment to tests_db. Addressed size is [' ...
         sprintf('%d ', addr_size) '] != [' sprintf('%d ', val_size) '].' ]);
end

%# Do not allow expansion of original DB
db_size = dbsize(obj);
if ~ ischar(rows) && max(rows) > db_size(1)
  error(['Requested row limit ' num2str(max(rows)) ' exceeds ' num2str(db_size(1)) ...
	 ' rows in DB.']);
end

if max(cols) > db_size(2)
  error(['Requested column limit ' num2str(max(cols)) ' exceeds ' num2str(db_size(2)) ...
	 ' columns in DB.']);
end

if ~ ischar(pages) && (length(db_size) < 3 || max(pages) > db_size(3))
  error(['Requested page limit ' num2str(max(rows)) ' exceeds ' num2str(db_size(3)) ...
	 ' rows in DB.']);
end

%# Do it
obj.data(rows, cols, pages) = val;


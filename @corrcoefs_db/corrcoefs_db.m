function a_coef_db = ...
      corrcoefs_db(col_name, coefs, coef_names, pages, id, props)

% corrcoefs_db - A database of correlation coefficients generated from 
%		a column of another database.
%
% Usage:
% a_coef_db = corrcoefs_db(col_name, bins, hist_results, id, props)
%
% Description:
%   This is a subclass of tests_db. Allows generating a plot, etc.
%
%   Parameters:
%	col_name: The column with which the others are correlated.
%	coefs: Matrix where each column has another coefficient.
%	coef_names: Cell array of column names corresponding to coefficients.
%	pages: Column vector of page indices pointing to the tests_3d_db.
%	id: An identifying string.
%	props: A structure with any optional properties.
%		
%   Returns a structure object with the following fields:
%	tests_db, props.
%
% General operations on corrcoefs_db objects:
%   corrcoefs_db		- Construct a new corrcoefs_db object.
%   plot_abstract		- Create a simple plot object
%
% Additional methods:
%	See methods('corrcoefs_db')
%
% See also: tests_db, plot_simple, tests_db/histogram
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/06

if nargin == 0 %# Called with no params
  a_coef_db.col_name = '';
  a_coef_db.props = struct([]);
  a_coef_db = class(a_coef_db, 'corrcoefs_db', tests_3D_db);
elseif isa(col_name, 'corrcoefs_db') %# copy constructor?
  a_coef_db = col_name;
else
  
  if ~ exist('props')
    props = struct([]);
  end

  %# Add a column for bin numbers
  test_results = cat(2, coefs, pages);
  col_names = { coef_names{:}, 'PageIndex' };
  page_names = { 'Coefs', 'Rlo', 'Rup' };

  a_coef_db.col_name = col_name;
  a_coef_db.props = props;

  a_coef_db = class(a_coef_db, 'corrcoefs_db', ...
		    tests_3D_db(test_results, col_names, {}, page_names, id, props));
end


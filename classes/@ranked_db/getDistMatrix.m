function [distmatx joined_db] = getDistMatrix(db, rows, col_size, props)

% getDistMatrix - Create a matrix of total errors from the ranked DB.
%
% Usage:
% distmatx = getDistMatrix(db, rows, col_size, props)
%
% Description:
%   The col_size parameter is used to find the number of rows that make up the 
% x-dimension of the matrix.
%
%   Parameters:
%	db: A tests_db object.
%	rows: Indices of rows in db after joining (and sorting).
%	col_size: Number of rows to take from DB to form the columns of matrix plot.
%	props: A structure with any optional properties.
%	  sortBy: If specified, db is sorted after being joined with original using this column.
%		
%   Returns:
%	a_plot: A plot_abstract object.
%
% See also: tests_db, plot_abstract
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/12/12

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props')
  props = struct;
end

% Join with original here. Only joins the requested rows.
joined_db = joinOriginal(db);

if isfield(props, 'sortBy')
  joined_db = sortrows(joined_db, props.sortBy);
end

joined_db = joined_db(rows, :);

%displayRows(joined_db(1:10, 'Distance'))

num_rows = dbsize(joined_db, 1);

% Get matrix of desired rows and columns
num_plot_rows = (num_rows / col_size);
distmatx = reshape(joined_db(:, 'Distance').data, col_size, num_plot_rows)';

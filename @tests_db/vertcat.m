function a_db = vertcat(db, varargin)

% vertcat - Vertical concatanation [db;with_db;...] operator.
%
% Usage:
% a_db = vertcat(db, with_db, ...)
%
% Description:
%   Concatanates rows of with_db to rows of db. Overrides the built-in
% vertcat function that is called when [db;with_db] is executed.
%
%   Parameters:
%	db: A tests_db object.
%	with_db: A tests_db object whose rows are concatanated to db.
%		
%   Returns:
%	a_db: A tests_db that contains rows of db and with_db.
%
% See also: vertcat, tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/01/25

%# Recurse to support variable number of inputs
if length(varargin) > 1
  with_db = vertcat(varargin{1}, varargin{2:end});
else
  with_db = varargin{1};
end

col_names = fieldnames(get(db, 'col_idx'));
wcol_names = fieldnames(get(with_db, 'col_idx'));

%# Check if they have same columns
if dbsize(db, 2) ~= dbsize(with_db, 2) || ... %# Same number of columns
  ((~ isempty(col_names) || ~ isempty(wcol_names)) && ... %# If any names are specified,
   ~ all(ismember(col_names, wcol_names))) 	          %# make sure they're same 
  error('Need to have same number of columns with same names in db and with_db.');
end

a_db = set(db, 'data', [ get(db, 'data'); get(with_db, 'data') ] );

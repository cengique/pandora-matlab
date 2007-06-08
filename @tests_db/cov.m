function a_cov_db = cov(db, props)

% cov - Generates a database of the covariance of given DB.
%
% Usage:
% a_cov_db = cov(db, props)
%
% Description:
%
%   Parameters:
%	db: A tests_db object.
%	props: A structure with any optional properties.
%	  keepOrigDB: Keep db as origDB in the props.
%	  (others passed to tests_db)
%		
%   Returns:
%	a_cov_db: A tests_db which contains the covariance matrix.
%
% See also: cov
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2007/05/25

if ~ exist('props')
  props = struct([]);
end

if isfield(props, 'keepOrigDB')
  props.origDB = db;
end

col_names = fieldnames(get(db, 'col_idx'));

a_cov_db = ...
    tests_db(cov(get(db, 'data')), col_names, col_names, [ 'covariance of ' get(db, 'id') ], props);



function a_factors_db = factoran(db, num_factors, props)

% factoran - Generates a database of factor loadings obtained from the 
%		factor analysis of db with factoran. Each row corresponds
%		to a rotated factor and columns represent observed variables.
%
% Usage:
% a_factors_db = factoran(db, num_factors, props)
%
% Description:
%  Uses the promax method to rotate common factors.
%
%   Parameters:
%	db: A tests_db object.
%	num_factors: Number of common factors to look for.
%	props: A structure with any optional properties.
%		
%   Returns:
%	a_factors_db: A corrcoefs_db of the coefficients and page indices.
%
% See also: tests_db, corrcoefs_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/11/08

if ~ exist('props')
  props = struct([]);
end

[LoadingsPM, specVarPM, T, stats] = ...
    factoran(get(db, 'data'), num_factors, 'rotate', 'promax' );


a_factors_db = tests_db(LoadingsPM', fieldnames(get(db, 'col_idx')), {}, ...
			[ 'Common factors of ' get(db, 'id') ], props);


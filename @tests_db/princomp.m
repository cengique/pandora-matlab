function a_pca_db = princomp(db, props)

% princomp - Generates a database of the principal components of given DB.
%
% Usage:
% a_pca_db = princomp(db, props)
%
% Description:
%
%   Parameters:
%	db: A tests_db object.
%	props: A structure with any optional properties.
%	  normalized: If specified zscore is used before princomp.
%		
%   Returns:
%	a_pca_db: A tests_db where each row is a principal component.
%
% See also: princomp, zscore
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/09/21

if ~ exist('props')
  props = struct([]);
end

if isfield(props, 'normalized')
  data = zscore(get(db, 'data'));
else
  data = get(db, 'data');
end

[coeff, score, latent, tsquared] = princomp(data);

a_pca_db = cluster_db(coeff, fieldnames(get(db, 'col_idx')), db, score, ...
		      [ 'principal components of ' get(db, 'id') ], ...
		      mergeStructs(props, struct('latent', latent)));



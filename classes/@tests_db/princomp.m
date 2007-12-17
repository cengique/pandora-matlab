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
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/09/21

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props')
  props = struct([]);
end

nanrows = isnanrows(db);
if any(any(nanrows))
  warning(['NaN containing rows in db, stripping before sending to ' ...
           'princomp.']);
  db = onlyRowsTests(db, ~nanrows, ':');
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



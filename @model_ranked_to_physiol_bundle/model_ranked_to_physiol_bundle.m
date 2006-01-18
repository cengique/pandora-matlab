function a_bundle = model_ranked_to_physiol_bundle(a_dataset, a_db, a_ranked_db, a_crit_bundle, props)

% model_ranked_to_physiol_bundle - A DB bundled with its dataset, ranked to a physiology DB bundle.
%
% Usage:
% a_bundle = model_ranked_to_physiol_bundle(a_dataset, a_db, a_ranked_db, a_crit_bundle, props)
%
%   Parameters:
%	a_dataset: A params_cip_trace_fileset object.
%	a_db: The raw params_tests_db object created from the dataset. It only needs
%		to have the pAcip, trial, and ItemIndex columns.
%	a_ranked_db: The one-model-per-line DB created from the raw DB.
%	a_crit_bundle: The bundle object associated with crit_db that caused the ranking in a_ranked_db.
%	props: A structure with any optional properties.
%		
% Description:
%   This is a subclass of model_ct_bundle, specialized for model datasets. 
%
% Returns a structure object with the following fields:
%	crit_bundle, model_ct_bundle.
%
% General operations on model_ranked_to_physiol_bundle objects:
%   model_ranked_to_physiol_bundle 	- Construct a new model_ranked_to_physiol_bundle object.
%   display		- Returns and displays the identification string.
%   get			- Gets attributes of this object and parents.
%   subsref		- Allows usage of . operator.
%
% Additional methods:
%	See methods('model_ranked_to_physiol_bundle')
%
% See also: model_ct_bundle, ranked_db, params_tests_dataset
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/12/13

if nargin == 0 %# Called with no params
  a_bundle.crit_bundle = dataset_db_bundle;
  a_bundle = class(a_bundle, 'model_ranked_to_physiol_bundle', model_ct_bundle);
elseif isa(a_dataset, 'model_ranked_to_physiol_bundle') %# copy constructor?
  a_bundle = a_dataset;
else
  if ~ exist('props')
    props = struct([]);
  end

  a_bundle.crit_bundle = a_crit_bundle;
  a_bundle = class(a_bundle, 'model_ranked_to_physiol_bundle', ...
		   model_ct_bundle(a_dataset, a_db(:, {'pAcip', 'trial', 'ItemIndex'}), ...
				   a_ranked_db, props));
end


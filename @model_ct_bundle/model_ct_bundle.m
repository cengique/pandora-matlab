function a_bundle = model_ct_bundle(a_dataset, a_db, a_joined_db, props)

% model_ct_bundle - The model dataset and the DB created from it bundled together.
%
% Usage:
% a_bundle = model_ct_bundle(a_dataset, a_db, a_joined_db, props)
%
%   Parameters:
%	a_dataset: A params_cip_trace_fileset object.
%	a_db: The raw params_tests_db object created from the dataset. It only needs
%		to have the pAcip, trial, and ItemIndex columns.
%	a_joined_db: The one-model-per-line DB created from the raw DB.
%	props: A structure with any optional properties.
%		
% Description:
%   This is a subclass of dataset_db_bundle, specialized for model datasets. 
%
% Returns a structure object with the following fields:
%	dataset_db_bundle.
%
% General operations on model_ct_bundle objects:
%   model_ct_bundle 	- Construct a new model_ct_bundle object.
%   display		- Returns and displays the identification string.
%   get			- Gets attributes of this object and parents.
%   subsref		- Allows usage of . operator.
%
% Additional methods:
%	See methods('model_ct_bundle')
%
% See also: dataset_db_bundle, tests_db, params_tests_dataset
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/12/13

if nargin == 0 %# Called with no params
  a_bundle = struct;
  a_bundle = class(a_bundle, 'model_ct_bundle', dataset_db_bundle);
elseif isa(a_dataset, 'model_ct_bundle') %# copy constructor?
  a_bundle = a_dataset;
else
  if ~ exist('props')
    props = struct([]);
  end

  a_bundle = struct;
  a_bundle = class(a_bundle, 'model_ct_bundle', ...
		   dataset_db_bundle(a_dataset, a_db(:, {'pAcip', 'trial', 'ItemIndex'}), ...
				     a_joined_db, props));
end


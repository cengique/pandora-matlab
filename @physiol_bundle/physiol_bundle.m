function a_bundle = physiol_bundle(a_dataset, a_db, a_joined_db, props)

% physiol_bundle - The physiology dataset and the DB created from it bundled together.
%
% Usage:
% a_bundle = physiol_bundle(a_dataset, a_db, a_joined_db, props)
%
%   Parameters:
%	a_dataset: A physiol_cip_traceset_fileset object.
%	a_db: The raw params_tests_db object created from the dataset. 
%		It only needs to have the pAcip, pAbias, TracesetIndex, and ItemIndex columns.
%	a_joined_db: The one-treatment-per-line DB created from the raw DB.
%	props: A structure with any optional properties.
%		
% Description:
%   This is a subclass of dataset_db_bundle, specialized for physiology datasets. 
%
% Returns a structure object with the following fields:
%	dataset_db_bundle.
%
% General operations on physiol_bundle objects:
%   physiol_bundle 	- Construct a new physiol_bundle object.
%   display		- Returns and displays the identification string.
%   get			- Gets attributes of this object and parents.
%   subsref		- Allows usage of . operator.
%
% Additional methods:
%	See methods('physiol_bundle')
%
% See also: dataset_db_bundle, tests_db, params_tests_dataset
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/12/13

if nargin == 0 %# Called with no params
  a_bundle.joined_control_db = params_tests_db;
  a_bundle = class(a_bundle, 'physiol_bundle', dataset_db_bundle);
elseif isa(a_dataset, 'physiol_bundle') %# copy constructor?
  a_bundle = a_dataset;
else
  if ~ exist('props')
    props = struct([]);
  end

  a_bundle.joined_control_db = ...
      a_joined_db(a_joined_db(:, {'TTX', 'Apamin', 'EBIO', ...
				  'XE991', 'Cadmium', 'drug_4AP'}) == zeros(1, 6), :);
  a_bundle = ...
      class(a_bundle, 'physiol_bundle', ...
	    dataset_db_bundle(a_dataset, ...
			      a_db(:, {'pAcip', 'pAbias', 'TracesetIndex', 'ItemIndex'}), ...
			      a_joined_db, props));
end


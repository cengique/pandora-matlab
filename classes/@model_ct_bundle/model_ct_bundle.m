function a_bundle = model_ct_bundle(a_dataset, a_db, a_joined_db, props)

% model_ct_bundle - The model cip_trace dataset and the DB created from it bundled together.
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
% Example:
% >> a_joined_db = mergeMultipleCIPsInOne(a_db, ...)
% >> a_bundle = model_ct_bundle(a_params_cip_trace_fileset, a_db, a_joined_db)
%
% See also: dataset_db_bundle, tests_db, params_tests_dataset, params_tests_db/mergeMultipleCIPsInOne
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/12/13

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 % Called with no params
  a_bundle = struct;
  a_bundle = class(a_bundle, 'model_ct_bundle', dataset_db_bundle);
elseif isa(a_dataset, 'model_ct_bundle') % copy constructor?
  a_bundle = a_dataset;
else
  if ~ exist('props')
    props = struct([]);
  end

  % columns to keep in dball
  col_names = {'ItemIndex'};

  all_names = getColNames(a_db);
  if ismember(all_names, 'trial')
    col_names = {'pAcip', 'trial', col_names{:}};
  else
    % if no trial identifier, we have to keep parameter columns (pAcip already there)
    col_names = {all_names{1:a_db.num_params}, col_names{:}};
  end

  a_bundle = struct;
  a_bundle = class(a_bundle, 'model_ct_bundle', ...
		   dataset_db_bundle(a_dataset, a_db(:, col_names), ...
				     a_joined_db, props));
end


function trial_num = getTrialNum(a_bundle, a_db, props)

% getTrialNum - Extracts identifying neuron trial number from DB.
%
% Usage:
% trial_num = getTrialNum(a_bundle, a_db|trial_num, props)
%
% Description:
%
%   Parameters:
%	a_bundle: A physiol_cip_traceset_fileset object.
%	a_db: DB rows representing deisred model neuron(s).
%	trial_num: Trial numbers. If specified, this function does nothing but return them.
%	props: A structure with any optional properties.
%		
%   Returns:
%	trial_num: The trial number(s) identifying selected neuron(s) in bundle.
%
% See also: dataset_db_bundle
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/05/26

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

  if ~exist('props')
    props = struct;
  end  

  if isa(a_db, 'tests_db')
    dataset_props = get(get(a_bundle, 'dataset'), 'props');
    if isfield(dataset_props, 'param_trial_name')
      trial_name = dataset_props.param_trial_name;
    else 
      trial_name = 'trial';
    end
    if ~isempty(trial_name)
      trial_num = get(onlyRowsTests(a_db, 1, 'trial'), 'data');
    else
      j_db = get(a_bundle, 'joined_db');
      % if no trial information, need to match parameters to joined_db
      param_names = getColNames(j_db(1, 1:get(j_db, 'num_params')));
      trial_num = find(transpose(j_db(:, param_names) == a_db(:, param_names)));
    end
  else
    trial_num = a_db;
  end

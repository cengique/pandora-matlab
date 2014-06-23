function a_prof = profileFromRows(a_bundle, a_db, props)

% profileFromRows - Loads a cip_trace object from a raw data file in the a_bundle.
%
% Usage:
% a_prof = profileFromRows(a_bundle, a_db, props)
%
% Parameters:
%   a_bundle: A dataset_db_bundle object.
%   a_db: Contains rows that contain trial/ItemIndex numbers.
%   props: A structure with any optional properties.
%	indexName: Column to take the ItemIndex from.
%  	(passed to params_tests_dataset/loadItemProfile)
%
% Returns:
%   a_prof: One or more results_profile objects.
%
% Description:
%
% See also: params_tests_dataset/loadItemProfile
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2014/06/19

% Copyright (c) 2014 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

props = defaultValue('props', struct);

fs_db = get(a_bundle, 'db');
col_names = getColNames(a_db);
index_col = getFieldDefault(props, 'indexName', 'ItemIndex')

% look for a trial column
if any(ismember(col_names, 'trial'))
  indices = ...
      get(fs_db(anyRows(fs_db(:, 'trial'), a_db(:, 'trial')), ...
                index_col), 'data');
elseif any(ismember(col_names, index_col))
  % otherwise use ItemIndex directly
  indices = get(a_db(:, index_col), 'data');
else
  col_names
  error(['Cannot find either trial or ItemIndex column in a_db']);
end

a_prof = loadItemProfile(get(a_bundle, 'dataset'), ...
                         indices, props);


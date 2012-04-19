function a_profile = loadItemProfile(dataset, item_index)

% loadItemProfile - Generates a results_profile object from a dataset item.
%
% Usage:
% a_profile = loadItemProfile(dataset, item_index)
%
% Parameters:
%   dataset: A params_tests_dataset object.
%   item_index: Index of item in dataset.
%		
% Returns:
%   a_profile: A profile object that implements the getResults method.
%
% Description:
%   If getResults returns a params_results_profile, then implementing
% paramNames and getItemParams become unecessary.
%
% See also: itemResultsRow, params_tests_fileset, paramNames, testNames
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/07/05

% Copyright (c) 2011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% TODO: 
% - make this a general method of params_tests_dataset
% - make 'getResults' a prop

% get the results
[a_profile] = getResults(getItem(dataset, item_index), get(dataset, 'props'));

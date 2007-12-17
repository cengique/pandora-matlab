function a_pt_profile = params_tests_profile(results, a_db, props)

% params_tests_profile - Holds the results profile from a params_tests_db.
%
% Usage:
% a_pt_profile = params_tests_profile(results, a_db, props)
%
%   Parameters:
%	a_db: A params_tests_db object.
%	results: A structure containing test results.
%	props: A structure with any optional properties.
%
% Description:
%		
%   Returns a structure object with the following fields:
%	results_profile: Contains results of tests.
%	db: The params_tests_db.
%	props.
%
% General methods of params_tests_profile objects:
%   params_tests_profile- Construct a new params_tests_profile object.
%   plot		- Graph the params_tests_profile.
%   display		- Returns and displays the identification string.
%   get			- Gets attributes of this object and parents.
%   subsref		- Allows usage of . operator.
%
% Additional methods:
%   See methods('params_tests_profile')
%
% See also: results_profile, params_tests_db/params_tests_profile
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/13

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 % Called with no params, creates empty object
  a_pt_profile.db = params_tests_db;
  a_pt_profile.props = struct([]);
  a_pt_profile = class(a_pt_profile, 'params_tests_profile', results_profile);
elseif isa(results, 'params_tests_profile') % copy constructor?
  a_pt_profile = results;
else 
  if ~ exist('props')
    props = struct([]);
  end

  a_pt_profile.db = a_db;
  a_pt_profile.props = props;

  % Create the object
  a_pt_profile = class(a_pt_profile, 'params_tests_profile', ...
		       results_profile(results, a_db.id));
end

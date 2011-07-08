function obj = params_results_profile(params, results, id, props)

% params_results_profile - Profile with parameters and results together.
%
% Usage 1:
% obj = params_results_profile(params, results, id, props)
%
% Usage 2:
% obj = params_results_profile(params, results_obj)
%
% Parameters:
%   params: Structure with parameter names and values.
%   results: Structure with result names and values (Usage 1).
%   results_obj: A results_profile object with test results.
%   id: Identification string (Usage 1).
%   props: A structure with any optional properties (Usage 1).
%
% Returns a structure object with the following fields:
%   params, results (results_obj above)
%
% Description:
%   This is a subclass of results_profile, improved by including
% parameter names and values. Should make it easier to code dataset
% classes. Usage 1 is for convenience, same information is contained in
% results_obj in Usage 2.
%		
% General methods of params_results_profile objects:
%   params_results_profile - Construct a new object.
%
% Additional methods:
%   See methods('params_results_profile')
%
% See also: results_profile, params_tests_dataset
%
% $Id: params_results_profile.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/07/05

% Copyright (c) 2011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 % Called with no params, creates empty object
  obj.params = struct;
  obj = class(obj, 'params_results_profile', results_profile);
elseif isa(params, 'params_results_profile') % copy constructor?
  obj = params;
else 
  % Create new object
  props = defaultValue('props', struct);

  obj = struct;
  obj.params = params;
  
  if ~ isa(results, 'results_profile')
    results = ...
        results_profile(results, id, props);
  end

  % Create the object
  obj = class(obj, 'params_results_profile', results);
end



function obj = params_tests_db(params, param_names, ...
			       a_test_results, test_names, id, props)

% params_tests_db - A generic database of test results varying with parameter values, organized in a matrix format.
%
% Usage 1:
% obj = params_tests_db(params, param_names, a_test_results, 
%			test_names, id, props)
%
%
%   Parameters:
%	params, a_test_results: Matrices that contain columns associated with
%		values and rows for separate observations.
%	param_names, test_names: Cell arrays of column names of params, 
%			and a_test_results, respectively.
%	id: An identifying string.
%	props: A structure with any optional properties.
%		
% Usage 2:
% obj = params_tests_db(num_params, a_tests_db, props)
%
%   Parameters:
%	num_params: Number of parameters.
%	a_tests_db: A tests_db upon which to build the params_tests_db.
%	props: A structure with any optional properties.
%
% Description:
%   This is a subclass of tests_db. Defines all operations on this
% structure so that subclasses can use them.
%
% Returns a structure object with the following fields:
%	tests_db
%	num_params: Number of variable parameters in simulations.
%
% General operations on params_tests_db objects:
%   params_tests_db		- Construct a new params_tests_db object.
%   display		- Returns and displays the identification string.
%   get			- Gets attributes of this object and parents.
%   subsref		- Allows usage of . operator.
%
% Additional methods:
%	See methods('params_tests_db') and methods('tests_db')
%
% See also: tests_db, test_variable_db (N/I)
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/08

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 % Called with no params
  obj.num_params=0;
  obj = class(obj, 'params_tests_db', tests_db);
elseif isa(params, 'params_tests_db') % copy constructor?
  obj = params;
elseif isa(param_names, 'tests_db')
  % Usage 2
  obj.num_params = params;
  if exist('a_test_results')
    props = a_test_results;
  else
    props = struct([]);
  end
  %obj.props = props; % this usage loses props
  obj = class(obj, 'params_tests_db', param_names);
else
  % Usage 1
  if ~ exist('props')
    props = struct([]);
  end

  % Only allow numeric arrays as params & a_test_results
  % TODO: add cell arrays?
  if ~ isnumeric(a_test_results) || ~ isnumeric(params)
    error('Only numeric arrays allowed as params or a_test_results.');
  end

  if ~ iscell(test_names) || ~ iscell(param_names)
    error('Only cell arrays of strings allowed as param_names or test_names.');
  end
  
  if ((size(a_test_results, 1) == 0 && size(params, 1) == 0) || ...
      size(a_test_results, 2) ~= length(test_names) || ...
	size(params, 2) ~= length(param_names))
    disp(['size of a_test_results: ' num2str(size(a_test_results))]);
    disp(['size of test_names: ' num2str(size(test_names))]);
    disp(['size of params: ' num2str(size(params))]);
    disp(['size of param_names: ' num2str(size(param_names))]);
    error(['Number of columns in params or a_test_results ', ...
	   'and items in param_names or test_names must match. ' ...
	   'And there should be some data to create the db.']);
  end
  
  data = [params, a_test_results];
  col_names = [param_names, test_names];
  
  obj.num_params = length(param_names);
  obj = class(obj, 'params_tests_db', tests_db(data, col_names, {}, id, props));
end


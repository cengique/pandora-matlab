function obj = params_tests_db(params, param_names, ...
			       test_results, test_names, id, props)

% params_tests_db - A generic database of test results varying with 
%		parameter values, organized in a matrix format.
%
% Usage:
% obj = params_tests_db(params, param_names, test_results, 
%			test_names, id, props)
%
% Description:
%   This is a subclass of tests_db. Defines all operations on this
% structure so that subclasses can use them.
%
%   Parameters:
%	params, test_results: Matrices that contain columns associated with
%		values and rows for separate observations.
%	param_names, test_names: Cell arrays of column names of params, 
%			and test_results, respectively.
%	id: An identifying string.
%	props: A structure any needed properties.
%		
%   Returns a structure object with the following fields:
%	tests_db
%	num_params: Number of variable parameters in simulations.
%	props.
%
% General operations on params_tests_db objects:
%   params_tests_db		- Construct a new params_tests_db object.
%
% Additional methods:
%	See methods('params_tests_db') and methods('tests_db')
%
% See also: tests_db, test_variable_db (N/I)
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/08

if nargin == 0 %# Called with no params
  obj.num_params=0;
  obj.props = struct([]);
  obj = class(obj, 'params_tests_db', tests_db);
elseif isa(params, 'params_tests_db') %# copy constructor?
  obj = params;
else

   if ~ exist('props')
     props = struct([]);
   end

   %# Only allow numeric arrays as params & test_results
   %# TODO: add cell arrays?
   if ~ isnumeric(test_results) || ~ isnumeric(params)
     error('Only numeric arrays allowed as params or test_results.');
   end

   if (size(test_results, 1) > 0 && ...
       size(test_results, 2) ~= length(test_names)) || ...
	 (size(params, 1) > 0 && ...
       size(params, 2) ~= length(param_names))
     error(['Number of columns in params or test_results ', ...
	    'and items in param_names or test_names must match.']);
   end

   data = [params, test_results];
   col_names = [param_names, test_names];

   obj.num_params = length(param_names);
   obj.props = props;
   obj = class(obj, 'params_tests_db', tests_db(data, col_names, id, props));
end


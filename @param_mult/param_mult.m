function a_pm = ...
      param_mult(var_names, param_init_vals, param_names, param_funcs, ...
                 func_handle, id, props)
  
% param_mult - Defines a function based on multiple param_func objects.
%
% Usage:
%   a_pm = ...
%     param_mult(var_names, param_init_vals, param_names, param_funcs, ...
%                func_handle, id, props)
%
% Parameters:
%   var_names: Cell array of names for input and output variables, resp.
%   param_init_vals: Initial values of function parameters.
%   param_names: Cell array of parameter names.
%   param_funcs: Structure of param_func or subclass objects.
%   func_handle: Function name or handle that takes funcs, params 
%   		 and variable (fs,p,x) to produce output.
%   id: An identifying string for this function.
%   props: A structure with any optional properties.
% 	   (Rest passed to param_func)
%		
% Returns a structure object with the following fields:
%	f: param_funcs from above,
%	param_func.
%
% Description:  
%   Specialized version (subclass) of param_func for combining multiple
% param_func objects in one function. Retains the ability to define its
% own parameters.
%
% Additional methods:
%	See methods('param_mult') and methods('param_func')
%
% Example:
%   f_Itot = ...
%      param_mult(...
%        {'mV', 'nA'}, struct('ENa', 45), [], 
%        struct('gNaP', f_gNaP), ...
%        @(fs, p, x) deal( f(fs.gNaP, x) * ( x - p.ENa), NaN), ...
%        'INaP', struct('xMin', -90, 'xMax', 30));
%
% See also: param_func, tests_db, plot_abstract
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2009/12/09
  
% TODO: make this not a subclass of param_func? [no, loses advantage of
% polymorphism]
  if ~ exist('props', 'var')
    props = struct;
  end

  props = mergeStructs(props, struct('xMin', -100, 'xMax', 100));

  if nargin == 0 % Called with no params
    a_pm = struct;
    a_pm.f = struct;
    a_pm = class(a_pm, 'param_mult', ...
                 param_func({}, [], {}, [], '', props));
  elseif isa(param_funcs, 'param_mult') % copy constructor?
    a_pm = param_funcs;
  else
    a_pm = struct;
    a_pm.f = param_funcs;
    
    % pass param and var names to param_func for display purposes only
    % (remove if leads to confusion)
    a_pm = class(a_pm, 'param_mult', ...
                 param_func(var_names, param_init_vals, param_names, ...
                            func_handle, id, props));
  end

  % TODO: doesn't work
    %var_names = ...
    %   cellfun(@(c) c.var_names{:}, param_func_cell, ...
    %            'UniformOutput', true)

    % OBSOLETE:
% $$$     var_names = {};
% $$$     param_names = {};
% $$$     param_func_cell = struct2cell(param_funcs)';
% $$$     for a_f = param_func_cell
% $$$       a_f = a_f{1};
% $$$       vn = a_f.var_names;
% $$$       var_names = [ var_names, vn{:} ];
% $$$       pn = getParamNames(a_f);
% $$$       % TODO: add sub-func name to param name
% $$$       param_names = [ param_names, pn{:} ];
% $$$     end

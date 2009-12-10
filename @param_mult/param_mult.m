function a_ps = param_mult(param_funcs, func_handle, id, props)
  
% param_mult - Defines a function based on multiple param_func objects.
%
% Usage:
%   a_ps = param_mult(param_funcs, func_handle, id, props)
%
% Parameters:
%   param_funcs: Structure of param_func or subclass objects.
%   func_handle: Function name or handle that takes object, params 
%   		 and variable (o,p,x) to produce output.
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
% param_func objects in one function.
%
% Additional methods:
%	See methods('param_mult') and methods('param_func')
%
% Example:
%   f_Itot = ...
%      param_mult(...
%        struct('INaP', f_INaP, 'IClCa', f_IClCa), ...
%        @(fs, x) deal( f(fs.INaP, x) + f(fs.IClCa, x), NaN), ...
%        'steady-state I_{total}', ...
%        struct('xMin', -90, 'xMax', 30));
%
% See also: param_func, tests_db, plot_abstract
%
% $Id: param_mult.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2009/12/09
  
% TODO: make this not a subclass of param_func? [no, loses advantage of
% polymorphism]
  if ~ exist('props', 'var')
    props = struct;
  end

  props = mergeStructs(props, struct('xMin', -100, 'xMax', 100));

  if nargin == 0 % Called with no params
    a_ps = struct;
    a_ps = class(a_ps, 'param_mult', ...
                 param_func(var_names, [], param_names, func_handle, '', props));
  elseif isa(param_funcs, 'param_mult') % copy constructor?
    a_ps = param_funcs;
  else
    % TODO: doesn't work
    %var_names = ...
    %   cellfun(@(c) c.var_names{:}, param_func_cell, ...
    %            'UniformOutput', true)

    var_names = {};
    param_names = {};
    param_func_cell = struct2cell(param_funcs)';
    for a_f = param_func_cell
      a_f = a_f{1};
      vn = a_f.var_names;
      var_names = [ var_names, vn{:} ];
      pn = getParamNames(a_f);
      % TODO: add sub-func name to param name
      param_names = [ param_names, pn{:} ];
    end
    
    param_init_vals = [];
    
    a_ps = struct;
    a_ps.f = param_funcs;
    
    % pass param and var names to param_func for display purposes only
    % (remove if leads to confusion)
    a_ps = class(a_ps, 'param_mult', ...
                 param_func({}, [], [], ...
                            func_handle, id, props));
  end

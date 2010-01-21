function ps = param_func(var_names, param_init_vals, param_names, func_handle, ...
                        id, props)
  
% param_func - Holds parameters of a function, y = f(x).
%
% Usage:
%   ps = param_func(var_names, param_init_vals, param_names, func_handle, id, props)
%
% Parameters:
%   var_names: Cell array of names for input and output variables, resp.
%   param_init_vals: Initial values of function parameters.
%   param_names: Cell array of parameter names.
%   func_handle: Function name or handle that takes params and variable
%   		 to produce output.
%   id: An identifying string for this function.
%   props: A structure with any optional properties.
%     xMin, xMax: Minimal and maximal values for input variable, x.
%     paramRanges: 2xn matrix of min and max values of each parameter.
%		If a non-NaN range is specified for a parameter
%		its parameters automatically become a ratio between [0,1]
%		that point inside this range.
%     rangeFunc: Function that translates range ratios into parameter
%     		values. Options are 'satlin' for saturated linear and
%     		'logsig' for logistic sigmoid (default='satlin'). 
%     selectParams: Cell of param names that can be selected by g/setParams.
%		
% Returns a structure object with the following fields:
%	var_names, func, tests_db.
%
% Description:  
%   Base class for a minimal set of parameters that stand for a single
% function of a single variable, y = f(x). This is intended for describing
% functions like m_inf and tau_inf curves. Uses tests_db to store
% parameter name and values.
%
% General operations on param_func objects:
%   param_func		- Construct a new param_func object.
%   func		- Evaluate function at value x.
%   plot_make		- Returns a plot_abstract object.
%   plot		- Plots function in new figure.
%   getParams, setParams - Parameter get/set.
%
% Additional methods:
%	See methods('param_func')
%
% Example:
%   f_INaP = ...
%      param_func(...
%        {'voltage [mV]', 'current [nA]'}, ...
%        [-40 -4.5, 1], ...
%        {'V_half', 'k', 'gmax'}, ...
%        @(p,x) deal(((p.gmax ./ (1 + exp((x(1, :) - p.V_half) ./ p.k))) ...
%                       .* (x - ENa)), NaN), ...
%        'steady-state I_{NaP}(V_{step})', ...
%        struct('xMin', -90, 'xMax', 30));
%
% See also: param_act, tests_db, plot_abstract
%
% $Id: param_func.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2009/05/28

  if nargin == 0 % Called with no params
    ps = struct;
    ps.var_names = {};
    ps.func = @(x) 0;
    ps = class(ps, 'param_func', ...
               tests_db([], {}, {}, ''));
  elseif isa(var_names, 'param_func') % copy constructor?
    ps = var_names;
  else
    if ~ exist('props', 'var')
      props = struct;
    end
    
    if ~isfield(props, 'rangeFunc')
      props.rangeFunc = @ldsatlins;
    end

    param_init_vals = param_init_vals(:)'; % row vector only
    
    ps = struct;
    ps.var_names = var_names;
    ps.func = func_handle;
    ps = class(ps, 'param_func', ...
               tests_db(convertParams2Ratios(param_init_vals, props), ...
                        param_names, {}, id, props));
  end


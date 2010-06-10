function ps = param_func_compiled(func_handle, id, props)
  
% param_func_compiled - Holds a function, y = f(x), without any parameters.
%
% Usage:
%   ps = param_func_compiled(var_names, param_init_vals, param_names, func_handle, id, props)
%
% Parameters:
%   func_handle: Function handle that takes a variable to produce output.
%   id: An identifying string for this function.
%   props: A structure with any optional properties.
%		
% Returns a structure object with the following fields:
%	func, id.
%
% Description:  
%   Obtained using param_func/fHandle for faster running functions
% without gatehering parameter values.
%
% Additional methods:
%	See methods('param_func_compiled')
%
% Example:
%   f_INaP = ...
%      fHandle(param_func(...
%        {'voltage [mV]', 'current [nA]'}, ...
%        [-40 -4.5, 1], ...
%        {'V_half', 'k', 'gmax'}, ...
%        @(p,x) ((p.gmax ./ (1 + exp((x(1, :) - p.V_half) ./ p.k))) ...
%                       .* (x - ENa)), ...
%        'steady-state I_{NaP}(V_{step})', ...
%        struct('xMin', -90, 'xMax', 30)));
%
% See also: param_func/fHandle, param_func
%
% $Id: param_func_compiled.m 128 2010-06-07 21:36:08Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/06/07

  if nargin == 0 % Called with no params
    ps = struct;
    ps.func = @(x) 0;
    ps.id = '';
    ps = class(ps, 'param_func_compiled');
  elseif isa(func_handle, 'param_func_compiled') % copy constructor?
    ps = func_handle;
  else
    if ~ exist('props', 'var')
      props = struct;
    end
        
    ps = struct;
    ps.func = func_handle;
    ps.id = id;
    ps = class(ps, 'param_func_compiled');
  end


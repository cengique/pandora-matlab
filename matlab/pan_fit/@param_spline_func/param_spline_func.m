function a_ps = param_spline_func(x_vals, init_vals, var_names, id, props)
  
% param_spline_func - Parameterized spline function to match an arbitrary shape.
%
% Usage:
%   a_ps = param_spline_func(x_vals, init_vals, id, props)
%
% Parameters:
%   x_vals: X values where to put spline breaks. If has two points,
%     it is interpreted as [min max] bounds and is divided into equal
%     number of breaks as given in init_vals.
%   init_vals: Initial values of y values at the spline breaks.
%   var_names: Cell string with the names and units of x and y variables.
%   id: An identifying string for this function.
%   props: A structure with any optional properties.
%     paramRanges: [min max] of y axis to be expanded and passed to param_func.
%     (Rest passed to param_func)
%		
% Returns a structure object with the following fields:
%	x_vals,
%	param_func.  
%
% Description:
%   fHandle executes much faster when parameters are fixed.
%
% See also: param_func, param_act, param_tau_v
%
% $Id: param_spline_func.m 128 2010-06-07 21:36:08Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/09/16

% TODO: measure time, improve eval functions by using interpolation
% table?
% - allow changing prefix on param names and use voltage values
  
  props = defaultValue('props', struct);
  
  if nargin == 0 % Called with no params
    a_ps = struct;
    a_ps.x_vals = [];
    a_ps = class(a_ps, 'param_spline_func', ...
                 param_func({'x', 'spline'}, [], ...
                            {}, @spline_val, '', props));
  elseif isa(x_vals, 'param_spline_func') % copy constructor?
    a_ps = x_vals;
  else
    num_breaks = length(init_vals);
    num_v = length(x_vals);
  
    if num_v == 2 && num_breaks > 0
      % so that truncation errors don't accummulate:
      x_vals = x_vals(1) + (0:(num_breaks - 1)) * diff(x_vals) / (num_breaks - 1);
    elseif num_v ~= num_breaks
      error(['x_vals and init_vals must have same number of values except when x_vals ' ...
             '= [min max].']);
    end

    a_ps = struct;
    a_ps.x_vals = x_vals;

    if isfield(props, 'paramRanges')
      props.paramRanges = ...
          repmat(props.paramRanges(:), 1, num_breaks);
    end
  
    param_names = arrayfun(@(x) [ 'p' num2str(x) ], 1:num_breaks, 'UniformOutput', false);
    props = mergeStructs(props, ...
                         struct('xMin', min(x_vals), 'xMax', max(x_vals)));

    a_ps = ...
        class(a_ps, 'param_spline_func', ...
              param_func(var_names, init_vals, param_names, ...
                         @spline_val, id, props));
  end
  
  function val = spline_val(p, x)
  % In handle version,  spline is made only once 
    pp = pchip(x_vals, cell2mat(struct2cell(p)));
    % return interpolated value
    val = ppval(pp, x);
  end
  
end


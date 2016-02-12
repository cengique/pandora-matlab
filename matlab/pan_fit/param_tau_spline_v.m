function a_ps = param_tau_spline_v(v_vals, init_vals, id, props)
  
% param_tau_spline_v - Parameterized time constant function represented by arbitrary spline function.
%
% Usage:
%   a_ps = a_ps = param_tau_spline_v(v_vals, init_vals, id, props)
%
% Parameters:
%   v_vals: Voltage values where to put spline breaks. If has two points,
%     it is interpreted as [min max] bounds and is divided into equal
%     number of breaks as given in init_vals.
%   init_vals: Initial values of tau values at the spline breaks.
%   id: An identifying string for this function.
%   props: A structure with any optional properties.
% 	   (Rest passed to param_func)
%		
% Returns:
%	a_ps: A param_func object.
%
% Description:
%   Uses a spline function so that the form of tau is more flexible
% during fits.
%
% See also: param_func, param_act, param_tau_v
%
% $Id: param_tau_spline_v.m 128 2010-06-07 21:36:08Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/09/14

% TODO: make splines a general class first
  num_breaks = length(init_vals);
  num_v = length(v_vals);
  
  if num_v == 2 && num_breaks > 0
    % so that truncation errors don't accummulate:
    v_vals = v_vals(1) + (0:(num_breaks - 1)) * diff(v_vals) / (num_breaks - 1);
  elseif num_v ~= num_breaks
    error(['v_vals and init_vals must have same number of values except when v_vals ' ...
           '= [min max].']);
  end

  % save the v_vals in props; when making this a class, save it in object
  props = defaultValue('props', struct);
  props.vVals = v_vals;

  param_names = arrayfun(@(x) [ 'p' num2str(x) ], 1:num_breaks, 'UniformOutput', false);
  props = mergeStructs(props, ...
                       struct('xMin', min(v_vals), 'xMax', max(v_vals), ...
                              'paramRanges', ...
                              repmat([eps 1e3]', 1, num_breaks)));

  a_ps = ...
      param_func({'voltage [mV]', 'time constant [ms]'}, init_vals, param_names, ...
                 @spline_val, id, props);
  
  function val = spline_val(p, x)
  % TODO: when making this class, only make spline once in handle version
  % make spline interpolation
    pp = pchip(v_vals, cell2mat(struct2cell(p)));
    % return interpolated value (never negative!)
    val = max(ppval(pp, x), eps);
  end

  end


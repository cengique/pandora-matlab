function a_ps = optimize(a_ps, inp_data, out_data, props)

% optimize - Gets the parameters of function.
%
% Usage:
%   a_ps = optimize(a_ps, inp_data, out_data, props)
%
% Parameters:
%   a_ps: A param_func object.
%   inp_data, out_data: Input data to feed into function and output data
%     to compare its output with, respectively.
%   props: A structure with any optional properties.
%     optimset: optimization toolbox parameters supercedes defaults.
%     optimmethod: Matlab optimizer to use: 'lsqcurvefit' (default), 'ktrlink'
%     fitOutRange: Two-element vector denoting the range to optimize [dt]. 
%
% Returns:
%   a_ps: param_func object with optimized parameters.
%
% Description:
%   Default optimizer is lsqcurvefit.
%
% Example:
%
% See also: param_func, lsqcurvefit, optimset
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/03/04

% Copyright (c) 2009-2010 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

props = mergeStructs(props, get(a_ps, 'props'));

out_size = prod(size(out_data));

if isfield(props, 'fitOutRange')
  % TODO: this is temporary, make a better one with a full trace template
  index = struct;
  index.type = '()';
  index.subs = {props.fitOutRange(1):props.fitOutRange(2), ':'};
  error_func_lsq = ...
      @(p, x) subsref(f(setParams(a_ps, p, struct('onlySelect', 1)), x), index);

  out_data = out_data(props.fitOutRange(1):props.fitOutRange(2), :);
else
  % do we call fHandle here to do it faster? [no, everything only called once]
  error_func_lsq = ...
      @(p, x) f(setParams(a_ps, p, struct('onlySelect', 1)), x);
end
error_func_sse = ...
    @(p) sum(sum((error_func_lsq(p, inp_data) - out_data).^2));

par = getParams(a_ps, struct('onlySelect', 1)); % initial params

param_ranges = getParamRanges(a_ps, struct('onlySelect', 1));

optimset_props = ...
    struct('MaxIter', 100, 'Display', 'iter', ...
           'MaxFunEvals', 1000, 'TolFun', 1e-6);
    
if isfield(props, 'optimset')
  optimset_props = mergeStructs(props.optimset, optimset_props);
end

props.optimmethod = ...
    getFieldDefault(props, 'optimmethod', 'lsqcurvefit');

tic;
  switch props.optimmethod
    case 'lsqcurvefit'
      [par, resnorm, residual, exitflag, output, lambda, jacobian] = ...
          lsqcurvefit(error_func_lsq, par', inp_data, ...
                      out_data, ...
                      param_ranges(1, :), param_ranges(2, :), ...
                      optimset_props);
    case 'ktrlink'
      [par, resnorm, exitflag, output, lambda] = ...
          ktrlink(error_func_sse, par', [], [], [], [], ...
                      param_ranges(1, :), param_ranges(2, :), ...
                      [], optimset_props);
  end

toc
disp([ 'Exit flag: ' num2str(exitflag) ])

disp('Output:')
output

disp('Resnorm:')
resnorm

% save resnorm in a_ps
a_ps = setProp(a_ps, 'resnorm', resnorm);

% $$$ disp('Residual:') % size as big as time points x num traces
% $$$ size(residual)

% $$$ disp('Lambda:') % got all zeros???
% $$$ lambda
% $$$ lambda.lower
% $$$ lambda.upper

% $$$ disp('Jacob:') % this is huge!!!
% $$$ jacobian

% set back fitted parameters
a_ps = setParams(a_ps, par, struct('onlySelect', 1));

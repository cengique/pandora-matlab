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
%     normalize: If 1, normalize out_data and function output before comparison.
%     optimset: optimization toolbox parameters supercedes defaults.
%     optimAeq,optimbeq: Matrix Aeq and vector beq for specifying
%     		equality constraints (see fmincon).
%     optimmethod: Matlab optimizer to use: 'lsqcurvefit' (default),
%     		   'ktrlink' (requires external libraries), 'fmincon'
%     		   (requires Optimization Toolbox).
%     fitOutRange: Two-element vector denoting the data range to optimize
%     		for[dt]. Multiple rows indicate different ranges to combine.
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
  fit_range = {};
  num_ranges = size(props.fitOutRange, 1);
  for range_num = 1:num_ranges
    fit_range{range_num} = ...
        props.fitOutRange(range_num, 1):props.fitOutRange(range_num, 2);
  end
  % cell to array
  fit_range = [ fit_range{:} ];
  % TODO: this is temporary, make a better one with a full trace template
  index = struct;
  index.type = '()';
  index.subs = {fit_range, ':'};
  error_func_lsq = ...
      @(p, x) subsref(f(setParams(a_ps, p, struct('onlySelect', 1)), x), index);

  out_data = out_data(fit_range, :);
else
  % do we call fHandle here to do it faster? [no, everything only called once]
  error_func_lsq = ...
      @(p, x) f(setParams(a_ps, p, struct('onlySelect', 1)), x);
end

if isfield(props, 'normalize')
  out_data = normdata(out_data);
  error_func_lsq = ...
      @(p, x) normdata(error_func_lsq(p, x));
end

error_func_sse = ...
    @(p) sum(sum((error_func_lsq(p, inp_data) - out_data).^2));

par = getParams(a_ps, struct('onlySelect', 1)); % initial params

param_ranges = getParamRanges(a_ps, struct('onlySelect', 1));

optimset_props = ...
    mergeStructs(struct('MaxIter', 100, 'Display', 'iter', ...
                        'MaxFunEvals', 1000, 'TolFun', 1e-6), optimset);
    
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
      jacobian = NaN;
      residual = NaN;
    case 'fmincon'
      % allows choosing different algorithms and equality constraints
      % TODO: function needs to return gradient and Hessian to take full
      % advantage of optimizer
      [par, resnorm, exitflag, output, lambda, grad, hessian] = ...
          fmincon(error_func_sse, par', [], [], ...
                  getFieldDefault(props, 'optimAeq', []), ...
                  getFieldDefault(props, 'optimbeq', []), ...
                      param_ranges(1, :), param_ranges(2, :), ...
                      [], optimset_props);
      jacobian = hessian;
      residual = NaN;
  end

toc
disp([ 'Exit flag: ' num2str(exitflag) ])

disp('Output:')
output


% normalized SSE
ssenorm = resnorm / (sum(sum(abs(out_data))) ^2);

disp(['resnorm: ' num2str(resnorm) ', ssenorm: ' num2str(ssenorm)]);

% save fit stats in a_ps
a_ps = setProp(a_ps, 'resnorm', resnorm, 'residual', residual, 'jacobian', ...
                     jacobian, 'ssenorm', ssenorm);

% calc confidence intervals
[a,R] = qr(full(jacobian),0);
Rinv = R \ eye(length(R));

% degrees of freedom:
if isstruct(inp_data)
  inp_points = length(inp_data.v);
else
  inp_points = length(inp_data);
end
dfe = inp_points - length(par);
sse = resnorm;
level = 0.95; % confidence level

% ripped from @cfit/confint
v = sum(Rinv.^2,2) * (sse / dfe);
b = par;
alpha = (1-level)/2;
t = -tinv(alpha,dfe); % switched cftinv to tinv from Stats toolbox
                       
% ignore bounds                      
% db = NaN*zeros(1,length(activebounds));
db = t * sqrt(v');
ci = [b-db', b+db'];

a_ps = setProp(a_ps, 'confInt', ci);
a_ps = setProp(a_ps, 'relConfInt', db');

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

end

% normalization function
function output_data = normdata(input_data)
max_data = max(max(abs(input_data)));
output_data = input_data ./ max_data;
end

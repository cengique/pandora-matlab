function [init_idx, a_plot] = ...
      calcInitVmSlopeThresholdSupsample(s, max_idx, min_idx, thr, plotit)

% calcInitVmSlopeThresholdSupsample - Estimates the AP threshold as the first slope threshold crossing by first supersampling the data using cubic spline interpolation.
%
% Usage:
% [init_idx, a_plot] = calcInitVmSlopeThresholdSupsample(s, max_idx, min_idx, thr, plotit)
%
% Description:
% 
%   Parameters:
%	s: A spike_shape object.
%	max_idx: The index of the maximal point of the spike_shape [dt].
%	min_idx: The index of the minimal point of the spike_shape [dt].
%	thr: Threshold for time derivative of voltage.
%	plotit: If non-zero, plot a graph annotating the test results 
%		(optional).
%
%   Returns:
%	init_idx: AP threshold index in the spike_shape [dt].
%	a_plot: plot_abstract, if requested.
%
% See also: calcInitVm
%
% $Id$
%
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2005/03/23

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('plotit', 'var')
  plotit = 0;
end
a_plot = [];

% Apply a median filter to reduce noise
smooth_data = medfilt1(s.trace.data, 5);
s = set(s, 'trace', set(s.trace, 'data', smooth_data));

if max_idx < 2
  error('calcInitVm:failed', 'Less than two v data points in the stem of %s.', ...
	get(s, 'id'));
end

% Supersampling factor (times as many new data points)
int_fac = 4; 

t_vals = 1 : (max_idx + 2);
int_vals = 1 : int_fac * (max_idx + 2);
interp = pchip(t_vals * s.trace.dt, s.trace.data(t_vals) * s.trace.dy, ...
	       int_vals * s.trace.dt / int_fac);

deriv = diffT(interp, s.trace.dt / int_fac);
deriv = deriv(3:(end-2));

deriv2 = diff2T_h4(interp, s.trace.dt / int_fac);
deriv2 = deriv2(3:(end-2));

if (plotit == 2)
  figure; plot(t_vals, s.trace.data(t_vals) * s.trace.dy /max(interp), ...
	       (1:length(interp))./int_fac, [interp/max(interp)], ...
	       (1:length(deriv))./int_fac, [thr*ones(1, length(deriv))/max(deriv); ...
					    deriv/max(deriv); deriv2/max(deriv2)]'); 
  legend(['v /' num2str(max(interp))], 'v (interp)', 'thr', ['v\prime /' num2str(max(deriv)) ], ['v\prime\prime / ' num2str(max(deriv2))]);
  grid on;
end

% Find all positive part in derivative until voltage peak
last_pos_d = find(deriv(1:end) > 0);
if length(last_pos_d) == 0
  error('calcInitVm:failed', 'No positive slope before peak of %s.', ...
	get(s, 'id'));
else
  last_pos_d_idx = last_pos_d(end);
end

last_neg_d = find(deriv(1:last_pos_d_idx) < -.1*max(abs(deriv)));
if length(last_neg_d) == 0
  last_neg_d_idx = 1;
elseif last_neg_d(end) == last_pos_d_idx  % can never happen?
  error('calcInitVm:failed', 'Negative slope right before peak of %s.', ...
	get(s, 'id'));
else
  last_neg_d_idx = last_neg_d(end);
end

start_idx = max(1, last_neg_d_idx - 1);

deriv = deriv(start_idx:end);
deriv2 = deriv2(start_idx:end);

% threshold voltage derivative
idx = find(deriv >= thr & deriv2 >= 0); % Slope of slope should be non-negative
if length(idx) == 0 
  % Raise error and catch it in the caller function
  error('calcInitVm:failed', ...
	['Derivative threshold ' num2str(s.trace.props.init_threshold) ...
	 ' failed to find spike initiation point. ' ]);
end

% Cannot be less than 1
init_idx = max((idx(1) + start_idx - 1 + 2 ) / int_fac, 1);

if plotit
  class_name = strrep(class(s), '_', ' ');
  t = (3 : (max_idx + 2)) * s.trace.dt * 1e3;
  t_data = s.trace.data(3 : (max_idx + 2));
    if floor(init_idx)==init_idx % edited by Li Su
        threshold_estimate = s.trace.data(init_idx);
    else
        threshold_estimate = interp1([floor(init_idx), ceil(init_idx)], ...
		   [s.trace.data(floor(init_idx)), s.trace.data(ceil(init_idx))], ...
		   init_idx);
    end

  a_plot = ...
      plot_abstract({int_vals(3:(end-2)) * s.trace.dt * 1e3 ./ int_fac, ...
		     deriv/max(abs(deriv)), ...
		     t, t_data/max(abs(t_data)), ...
		     init_idx * s.trace.dt * 1e3, threshold_estimate/max(abs(t_data)), '*'}, ...
		    {'time [ms]', 'normalized'}, ...
		    [class_name ': ' get(s, 'id') ...
		     ', Slope threshold method (interp), ' ...
		     ' v\prime > ' num2str(thr) ' crossing'], ...
		    {'v\prime', 'v', 'thr'}, 'plot');
end


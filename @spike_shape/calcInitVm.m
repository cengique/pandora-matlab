function [init_val, init_idx, rise_time, amplitude, ...
	  max_ahp, ahp_decay_constant, dahp_mag, dahp_idx, ...
	  peak_mag, peak_idx] = ...
      calcInitVm(s, max_idx, min_idx, plotit)

% calcInitVm - Calculates the spike initiation information of the 
%		spike_shape, s. 
%
% Usage:
% [init_val, init_idx, rise_time, amplitude, max_ahp, ahp_decay_constant,
%  dahp_mag, dahp_idx, peak_mag, peak_idx] = 
%	calcInitVm(s, max_idx, min_idx)
%
% Description:
%   Parameters:
%	s: A spike_shape object.
%	max_idx: The index of the maximal point of the spike_shape [dt].
%	min_idx: The index of the minimal point of the spike_shape [dt].
%	plotit: If non-zero, plot a graph annotating the test results 
%		(optional).
%
%   Returns:
%	init_val: The potential value [dy].
%	init_idx: Its index in the spike_shape [dt].
%	rise_time: Time from initiation to maximum [dt].
%	amplitude: Magnitude from initiation to max [dy].
%	max_ahp: Magnitude from initiation to minimum [dy].
%	ahp_decay_constant: Approximation to refractory decay after maxAHP [dt].
%	dahp_mag: Magnitude of the double AHP peak
%	dahp_mag: Index of the double AHP peak
%	peak_mag: Peak value [dy]
%	peak_idx: Extrapolated spike peak index [dt]
%
% See also: spike_shape
%
% $Id$
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2004/08/02
%   Based on @spike_trace/shapestats by Jeremy Edgerton.

if ~ exist('plotit')
  plotit = 0;
end

%# Constants
min_val = s.trace.data(min_idx);
max_val = s.trace.data(max_idx);

%# Find spike initial voltage
method = s.props.init_Vm_method;

switch method
  case 1
    deriv = diff(s.trace.data);
    accel = diff(deriv);
    %# peak of voltage acceleration.
    [val, idx] = max(accel(1 : max_idx)); 
  case 2
    deriv = diff(s.trace.data);
    accel = diff(deriv);
    %# threshold voltage acceleration.
    idx = find(accel(1 : max_idx) >= s.props.init_threshold); 
    if length(idx) == 0 
      error(sprintf(['Threshold %f failed to find ', ...
		     ' spike initiation acceleration.'], ...
		    s.props.init_threshold));
    end
    idx = idx(1);
  case 3
    deriv = diff(s.trace.data);
    %# threshold voltage derivative
    idx = find(deriv(1 : max_idx) >= ...
	       s.props.init_threshold * s.trace.dt / s.trace.dy); 
    if length(idx) == 0 
      warning('spike_shape:threshold_derivative', ...
	      ['Threshold ' num2str(s.props.init_threshold) ...
	       ' failed to find spike initiation point.']);
      %# Then, the first point of the trace is the spike initiation point.
      idx = 1;
    end
    idx = idx(1);
  case 4
    %# Sekerli's method: maximum second derivative in the phase space
    %#   Taken from Sekerli, Del Negro, Lee and Butera. IEEE Trans. Biomed. Eng.,
    %#	51(9): 1665-71, 2004.
    d3 = diff3T(s.trace.data(1 : (max_idx + 2)), s.trace.dt);
    d2 = diff2T(s.trace.data(1 : (max_idx + 2)), s.trace.dt);
    d1 = diffT(s.trace.data(1 : (max_idx + 2)), s.trace.dt);
    %# Remove boundary artifacts
    d3 = d3(4:(end - 3)); 
    d2 = d2(4:(end - 3));
    d1 = d1(4:(end - 3));
    h = (d3 .* d1 - d2 .* d2) ./ (d1 .* d1 .* d1);
    if plotit
      figure;
      t = (4 : (max_idx -1)) * s.trace.dt * 1e3;
      handles = semilogy(t, d1, t, d2, t, d3, t, h, '.-', ...
			 t, 100 + s.trace.data(4 : (max_idx -1)));
      legend(handles, {'d1', 'd2', 'd3', 'h', 'v'});
      title('Sekerli''s method, h = second derivative of dV/dt with V');
    end
    [val, idx] = max(h); 
    idx = idx + 3;
  case 5
    %# Point of maximum curvature: Kp = V''[1 + (V')^2]^(-3/2)
    %# Taken from Sekerli, Del Negro, Lee and Butera. 
    %# IEEE Trans. Biomed. Eng., 51(9): 1665-71, 2004.
    d2 = diff2T(s.trace.data(1 : (max_idx + 2)), s.trace.dt);
    d1 = diffT(s.trace.data(1 : (max_idx + 2)), s.trace.dt);
    d2 = d2(3:(end -2));
    d1 = d1(3:(end -2));
    k1 = 1 + d1 .* d1;
    k = d2 ./ sqrt(k1 .* k1 .* k1);
    %# Find first local maximum in k before spike peak
    dk = diff(k);
    dk2 = dk(2:end) .* dk(1:(end-1));
    zc = find(dk2 < 0);
    %#[val, idx] = max(k); 
    idx = zc(end) + 1; %# need to add 1 because of diff
    idx = idx + 2;
    if plotit
      figure;
      t = (3 : max_idx) * s.trace.dt * 1e3;
      handles = semilogy(t, d1, t, d2, t, k1, t, 100*k, '.-', ...
			 t, 100 + s.trace.data(3 : max_idx));
      legend(handles, {'d1', 'd2', 'k1', 'Kp', 'v'})
      title('Maximal curvature Kp');
    end
  otherwise
    error(sprintf('Incorrect spike initiation method: %f', method));
end

init_val = s.trace.data(idx);	%# Init Vm
init_idx = idx;

%# Find the REAL max_val
[peak_mag, peak_idx] = estimate_tip(s.trace.data, max_idx);

rise_time = peak_idx - init_idx;	%# Init-max Time
amplitude = peak_mag - init_val; %# Spike amplitude
max_ahp = max(0, init_val - min_val); 	%# maximal AHP amplitude

%# Calculate AHP decay time constant approx: 
%# min_val - max_ahp * (1 - exp(-t/decay_constant))

%# Don't wrap to the beginning of the trace, already done at creation time
after_ahp = [s.trace.data(min_idx:end)];

%# Find double AHP is it exists
[dahp_mag, dahp_idx] = find_double_ahp(after_ahp, min_idx, s.trace.dt);

%# Threshold set at one time constant
%#decay_constant_threshold = min_val + max_ahp * (1 - exp(-1))

%# Try from resting potential
decay_constant_threshold = min_val + ...
    (s.trace.data(1) - min_val) * (1 - exp(-1));

%# If double ahp exists
if ~isnan(dahp_mag)
  after_dahp = s.trace.data(dahp_idx:end);
  %# Find minimum after the double AHP
  [af_min_val, af_min_idx] = min(after_dahp);
  recover_times = ...
      find(after_dahp(af_min_idx:end) >= decay_constant_threshold) + ...
      af_min_idx + dahp_idx;
else
  recover_times = find(after_ahp >= decay_constant_threshold) + min_idx;
end

if length(recover_times) > 0 
  %# Take first point for fitting exponential decay
  ahp_decay_constant = recover_times(1) - max_idx;
else 
  ahp_decay_constant = NaN;
end

function [dahp_mag, dahp_idx] = find_double_ahp(after_ahp, ahp_idx, dt)
  %# No dahp by default  
  dahp_mag = NaN;
  dahp_idx = NaN;

  %# Check for a maximum point right after the max AHP
  %# The first 30 ms, or until the end of trace
  duration=after_ahp(1:min(floor(30e-3 / dt), length(after_ahp))); 

  [max_val, max_idx] = max(duration);

  %# Check if maximum point exists
  if max_idx == length(duration)   
    return
  end

  %# Make linear approximation to an ahp bump
  dahp_bump_rise = duration(1):(max_val - duration(1))/max_idx:max_val;
  dahp_bump_fall = max_val:(duration(end) - max_val)/(length(duration) - max_idx):duration(end);
  dahp_bump = [dahp_bump_rise(1:end-1), dahp_bump_fall(2:end)]';

  %# Make linear approximation to no double ahp case
  no_dahp = [duration(1) + ...
    (1:length(duration))*(duration(end) - duration(1))/length(duration)]';

  %# Calculate error of hypothesis to reality
  dahp_error = sum(abs(dahp_bump - duration));
  nodahp_error = sum(abs(no_dahp - duration));

  if dahp_error <= nodahp_error
    dahp_idx = ahp_idx + max_idx;
    dahp_mag = max_val - duration(1);
  end
  
  %# Doesn't work well, the spike tips are round, not sharp.
function [peak_mag, peak_idx] = estimate_tip(data, max_idx)

  %# Do cubic spline interpolation:
  times = max_idx - 3 : max_idx + 3;
  interp = spline(times, data(times), max_idx - 1:2/10:max_idx + 1);

  [peak_mag, peak_idx] = max(interp);

  peak_idx = max_idx - 1 + (peak_idx - 1) * 2/10;

  return
  %# Find the slopes:
  slopes = diff(data(max_idx - 3 : max_idx + 3))

  flips = slopes(1:end-2) .* slopes(3:end)

  %# Find the first reduction in slope 
  %#reduction = find(diff(slopes) < 0);

  %# Find the first sign flip in slope 
  flip = find(flips < 0);

  %# That's the left corner of the broken tip
  left_idx = max_idx - 2 + reduction(1)
  right_idx = left_idx + 1

  %# Find line coefficients
  left_slope = data(left_idx) - data(left_idx - 1)
  left_const = data(left_idx) - left_slope * left_idx

  right_slope = data(right_idx + 1) - data(right_idx)
  right_const = data(right_idx) - right_slope * right_idx

  %# Find intersection point
  peak_idx = (left_const - right_const) / (right_slope - left_slope)
  peak_mag = left_slope * peak_idx + left_const

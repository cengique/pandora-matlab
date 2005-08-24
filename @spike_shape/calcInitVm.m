function [init_val, init_idx, rise_time, amplitude, ...
	  peak_mag, peak_idx, max_d1o, a_plot] = ...
      calcInitVm(s, max_idx, min_idx, plotit)

% calcInitVm - Calculates spike threshold related measures of the spike_shape, s. 
%
% Usage:
% [init_val, init_idx, rise_time, amplitude,
%  peak_mag, peak_idx, max_d1o, a_plot] = 
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
%	peak_mag: Peak value [dy].
%	peak_idx: Extrapolated spike peak index [dt].
%	max_d1o: Maximal value of first voltage derivative [dy].
%	a_plot: plot_abstract, if requested.
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
a_plot = [];

%# Constants
min_val = s.trace.data(min_idx);
max_val = s.trace.data(max_idx);
max_d1o = NaN;			%# comes from calcInitVmMaxCurvPhasePlane

%# Find spike initial voltage
method = s.props.init_Vm_method;

vs = warning('query', 'verbose');
verbose = vs.state;

if strcmp(verbose, 'on')
  disp([get(s, 'id') ', max_idx=' num2str(max_idx) ])
end

%# Filter out some spikes

try
switch method

  %# peak of voltage acceleration.
  case 1
    deriv = diff(s.trace.data);
    accel = diff(deriv);
    [val, idx] = max(accel(1 : max_idx)); 

  %# threshold voltage acceleration.
  case 2
    deriv = diff(s.trace.data);
    accel = diff(deriv);
    idx = find(accel(1 : max_idx) >= s.props.init_threshold); 
    if length(idx) == 0 
      error('calcInitVm:failed', ...
	    sprintf(['Threshold %f failed to find ', ...
		     ' spike initiation acceleration.'], ...
		    s.props.init_threshold));
    end
    idx = idx(1);

  %# threshold voltage slope
  case 3
    [idx, a_plot] = ...
	calcInitVmSlopeThreshold(s, max_idx, min_idx, s.props.init_threshold, plotit);

  %# Sekerli's method: maximum second derivative in the phase space
  case 4
    [idx, a_plot] = calcInitVmSekerliV2(s, max_idx, min_idx, plotit);

  %# Point of maximum curvature: Kp = V''[1 + (V')^2]^(-3/2)
  case 5
    [idx, a_plot] = calcInitVmLtdMaxCurv(s, max_idx, min_idx, s.props.init_lo_thr, ...
					 s.props.init_hi_thr, plotit);

  %# Sekerli's method with a twist
  case 6
    [idx, a_plot] = calcInitVmV2PPLocal(s, max_idx, min_idx, ...
					s.props.init_threshold, plotit);

  %# threshold voltage derivative by first supersampling using interpolation
  case 7
    [idx, a_plot] = ...
	calcInitVmSlopeThresholdSupsample(s, max_idx, min_idx, s.props.init_threshold, plotit);

  %# Point of maximum curvature in phase-plane: Kp = V''[1 + (V')^2]^(-3/2)
  case 8
    try 
      [idx, max_d1o, a_plot, fail_cond] = ...
	  calcInitVmMaxCurvPhasePlane(s, max_idx, min_idx, plotit);

      if ~ fail_cond
	idx = idx(2);
      else
	[idx, a_plot] = ...
	    calcInitVmSlopeThresholdSupsample(s, max_idx, min_idx, ...
					      s.props.init_threshold, plotit);
      end

    catch
      err = lasterror;
      if strcmp(err.identifier, 'calcInitVm:failed')
	warning('calcInitVm:info', ...
		['Warning: ' err.message ...
		 ' Falling back to supersampled threshold method.']);
	[idx, a_plot] = ...
	    calcInitVmSlopeThresholdSupsample(s, max_idx, min_idx, ...
					      s.props.init_threshold, plotit);
      else
	warning('calcInitVm:info', ['Rethrowing: ']);
	rethrow(err);
      end
    end


  %# Combined methods for time-domain derivatives: h and Kp
  case 9
    [idx, a_plot] = calcInitVmV3hKpTinterp(s, max_idx, min_idx, ...
					   s.props.init_lo_thr, ...
					   s.props.init_hi_thr, plotit);
    idx = idx(1);

  otherwise
    error(sprintf('Incorrect spike initiation method: %f', method));
end
catch
  err = lasterror;
  if strcmp(err.identifier, 'calcInitVm:failed')
    warning('calcInitVm:info', ...
	    ['Warning: ' err.message ...
	     ' Taking the fist point in the trace as AP threshold.']);
    idx = 1;
  else
    rethrow(err);
  end
end

%# AP init. time
init_idx = idx;

%# AP init. Vm
init_val = interpValByIndex(init_idx, s.trace.data);

%# Find the REAL max_val
[peak_mag, peak_idx] = estimate_tip(s.trace.data, max_idx);

rise_time = peak_idx - init_idx;	%# Init-max Time
amplitude = peak_mag - init_val; %# Spike amplitude
  
%# Doesn't work well, the spike tips are round, not sharp.
function [peak_mag, peak_idx] = estimate_tip(data, max_idx)

  %# Do cubic spline interpolation:
  times = max_idx - 3 : max_idx + 3;
  interp = spline(times, data(times), max_idx - 1:2/10:max_idx + 1);

  [peak_mag, peak_idx] = max(interp);

  peak_idx = max_idx - 1 + (peak_idx - 1) * 2/10;

  return
  
  %# THE FOLLOWING IS NOT USED:
  
  %# Find the slopes
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


function [init_idx, max_d1o, a_plot, fail_cond] = ...
      calcInitVmMaxCurvPhasePlane(s, max_idx, min_idx, plotit)

% calcInitVmMaxCurvPhasePlane - Calculates the voltage at the maximum curvature in the phase plane as action potential threshold.
%
% Usage:
% [init_idx, max_d1o, a_plot, fail_cond] = 
%	calcInitVmMaxCurvPhasePlane(s, max_idx, min_idx, plotit)
%
% Description:
%   First take the phase-plane v'-v from the beginning to max(v'). Then regulate 
% intervals by interpolation. Point of maximum curvature: Kp = V''[1 + (V')^2]^(-3/2)
% Taken from Sekerli, Del Negro, Lee and Butera. 
% IEEE Trans. Biomed. Eng., 51(9): 1665-71, 2004.
% 
%   Parameters:
%	s: A spike_shape object.
%	max_idx: The index of the maximal point of the spike_shape [dt].
%	min_idx: The index of the minimal point of the spike_shape [dt].
%	plotit: If non-zero, plot a graph annotating the test results 
%		(optional).
%
%   Returns:
%	init_idx: AP threshold index in the spike_shape [dt].
%	max_d1o: Maximal value of first voltage derivative [dy].
%	a_plot: plot_abstract, if requested.
%	fail_cond: True if this algorithm fails to be trustable.
%
% See also: calcInitVm
%
% $Id$
%
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2005/04/12
%   Inspired by Sekerli, Del Negro, Lee and Butera. IEEE Trans. Biomed. Eng.,
%	51(9): 1665-71, 2004 and by personal communication with Murat Şekerli.

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('plotit')
  plotit = 0;
end
a_plot = [];

%# Apply a median filter to reduce noise
%#medfilt1(s.trace.data, windowsize);
windowsize = 6;
%#filter(ones(1, windowsize)/windowsize, 1, s.trace.data); 
smooth_data = medfilt1([s.trace.data(1); s.trace.data], windowsize);
smooth_data = smooth_data(2:end); %# drop first sample which has noise from medfilt1

%#end
%# Decimate using FIR low-pass filter (doesn't work: adds ringing artifact)
dec_factor = 1;
trace_data = smooth_data;
%#trace_data = decimate(smooth_data, dec_factor, min(floor(length(smooth_data)/3), 30), 'FIR');

%#d2 = diff2T(trace_data(1 : (max_idx + 2)) * s.trace.dy, s.trace.dt);
d1o = diffT(trace_data(1 : (floor(max_idx/dec_factor) + 2)) * s.trace.dy, ...
	    s.trace.dt * dec_factor);
%#d2 = d2(3:(end -2));
d1o = d1o(3:(end -2));

%# Find max in derivative
[max_d1o, max_d1o_idx] = max(d1o);

%# Find all positive part in derivative until voltage peak
last_pos_d = find(d1o >= 0);
if length(last_pos_d) == 0
  error('calcInitVm:failed', 'No positive slope before peak of %s.', ...
	get(s, 'id'));
else
  last_pos_d_idx = last_pos_d(end);
end

%# put arbitrary negativeness limit on slope
last_neg_d = find(d1o(1:last_pos_d_idx) < -1);
if length(last_neg_d) == 0
  last_neg_d_idx = 1;
elseif last_neg_d(end) == last_pos_d_idx   %# can never happen?
  error('calcInitVm:failed', 'Negative slope right before peak of %s.', ...
	get(s, 'id'));
else
  last_neg_d_idx = last_neg_d(end);
end

%# Find min in voltage before end
[min_v, min_v_idx] = min(trace_data(1 : max_d1o_idx));

%# Interpolate to find a regular intervalled phase-plane representation
%# Voltage range is from the dip in voltage point to the spike peak.
%# Tried both spline and pchip, spline overfits.
num_points = 200;
start_idx = max(1, last_neg_d_idx - 1);
dv = (trace_data(max_d1o_idx + 2) - trace_data(start_idx + 2))/num_points;
voltage_points = ...
    (trace_data(start_idx + 2):dv:trace_data(max_d1o_idx + 2)) * s.trace.dy;

%# Arbitrarily remove duplicate values from voltage values
trace_data((start_idx + 2) : (max_d1o_idx + 2));
[orig_v_points unique_idx] = ...
    unique(trace_data((start_idx + 2) : (max_d1o_idx + 2)) * s.trace.dy);
d1o_points = d1o(start_idx:max_d1o_idx);

%# Check if there are enough points to interpolate
if length(unique_idx) < 2
  error('calcInitVm:failed', 'Less than two vPP data points in the stem of %s.', ...
	get(s, 'id'));
end

if length(voltage_points) < 2
  error('calcInitVm:failed', 'Less than two v data points in the stem of %s.', ...
	get(s, 'id'));
end

interp_vpp = pchip(orig_v_points, d1o_points(unique_idx), voltage_points);

%# Put lower bound on vpp?
windowsize = 10;
filtered_vpp = filter(ones(1, windowsize)/windowsize, 1, interp_vpp);
low_bound = find(filtered_vpp >= 1); %# mV/ms crossing is the lower bound

%#figure; plot(orig_v_points * s.trace.dy, d1o_points(unique_idx), ...
%#	     voltage_points, [interp_vpp; filtered_vpp]'); 
%#legend('orig', 'interp', 'filtered');

if length(low_bound) > 0
  interp_vpp = interp_vpp(low_bound(1):end);
  voltage_points = voltage_points(low_bound(1):end);
end

if (1 == 1) 
  %# Estimations from Taylor series, error = O(dv^4)
  d1 = diffT(interp_vpp, dv);
  d2 = diff2T_h4(interp_vpp, dv);
  d3 = diff3T_h4(interp_vpp, dv);
  d1 = d1(3:(end -2));
  d2 = d2(3:(end)-2);
  d3 = d3(3:(end)-2);
else
  d1 = diff(interp_vpp);
  d2 = diff(d1);
  d3 = diff(d2);
  d1 = d1(2:(end -2));
  d2 = d2(2:(end)-1);
  d3 = d3(1:(end)-1);
end

%# Find max in derivative as upper limit of region of interest
[max_vpp, max_vpp_idx] = max(interp_vpp(3:(end-2)));

d3 = d3(1:max_vpp_idx);
d2 = d2(1:max_vpp_idx);
d1 = d1(1:max_vpp_idx);

%# Maximal d2vpp, one candidate for APthr
try 
  max_d2vpp_idx = findMax(d2, voltage_points);
  max_d2vpp_t_idx = transV2T(s, start_idx * dec_factor, max_idx, voltage_points, max_d2vpp_idx);

  %# Local maximum of d3vpp, closest to max_d2vpp_idx, candidate for APthr
  max_d3vpp_idx = maxima(d3);

  if length(max_d3vpp_idx) > 0
    [sorted, sorted_idx] = sort(abs(max_d3vpp_idx - max_d2vpp_idx));
    max_d3vpp_idx = max_d3vpp_idx(sorted_idx(1));
    max_d3vpp_t_idx = transV2T(s, start_idx * dec_factor, max_idx, voltage_points, max_d3vpp_idx);
  else
    warning('calcInitVm:info', 'Cannot find local maxima in d3vpp for %s', get(s, 'id'));
  end

catch %# If finding max_d2vpp_idx fails
  err = lasterror;
  if strcmp(err.identifier, 'calcInitVm:failed')
    warning('calcInitVm:info', sprintf('Error in %s: %s', get(s, 'id'), err.message));
    max_d2vpp_idx = 1;
    max_d2vpp_t_idx = 1;
    max_d3vpp_idx = 1;
    max_d3vpp_t_idx = 1;
  else
    disp(sprintf('Error in %s:', get(s, 'id')));
    rethrow(err);
  end
end

%# Curvature calculation
k1 = 1 + d1 .* d1;
k = d2 ./ sqrt(k1 .* k1 .* k1);

%# Maximal curvature
[max_k_idcs] = maxima(k);

%# Highest maximum
[sorted, sorted_idx] = sort(k(max_k_idcs));

%#sorted
%#voltage_points(max_k_idcs(sorted_idx) + 2)

if length(max_k_idcs) == 0 
  error('calcInitVm:failed', 'No local maxima found for %s!', get(s, 'id'));
else
  if max_k_idcs(sorted_idx(end)) == 1	%# If first point in trace is maximum
    if length(max_k_idcs) > 1
      idx = max_k_idcs(sorted_idx(end - 1));%# Take next nearest maxima
    else
      error('calcInitVm:failed', 'Too few local maxima!');
    end
  else
    idx = max_k_idcs(sorted_idx(end));	%# Otherwise highest maximum
  end
end

max_k_idx = idx;
max_k_t_idx = transV2T(s, start_idx * dec_factor, max_idx, voltage_points, max_k_idx);

thr_vol = voltage_points(max_k_idx + 2);

if ~ isnan(max_d2vpp_idx)

  %# Find highest local maximum of k closest to max_d2vpp_idx
  distance = max_k_idcs - max_d2vpp_idx;
  [sorted, sorted_idx] = sort(distance .* distance ./ sqrt(k(max_k_idcs)));

  %#sorted
  %#voltage_points(max_k_idcs(sorted_idx) + 2)

  %# Skip negative peaks
  max_k_near_d2vpp_idx = find(sorted >= 0);

  if length(max_k_near_d2vpp_idx) > 0
    max_k_near_d2vpp_idx = max_k_idcs(sorted_idx(max_k_near_d2vpp_idx(1)));
    max_k_near_d2vpp_t_idx = transV2T(s, start_idx * dec_factor, max_idx, voltage_points, max_k_near_d2vpp_idx);
  else
    warning('calcInitVm:info', sprintf('Cannot find nearby positive peak in d2vpp of %s. Using global max k idx instead.', get(s, 'id')));
    max_k_near_d2vpp_idx = max_k_idx;
    max_k_near_d2vpp_t_idx = max_k_t_idx;
  end
else
    max_k_near_d2vpp_idx = max_k_idx;
    max_k_near_d2vpp_t_idx = max_k_t_idx;
end

%# Return all candidates
init_idx = [max_k_t_idx, max_k_near_d2vpp_t_idx, max_d2vpp_t_idx, max_d3vpp_t_idx];

s_props = get(s, 'props');

if interp_vpp(max_k_near_d2vpp_idx + 2) > s_props.init_threshold
  warning('calcInitVm:info', ['vPP curvature ignored, v'' > ' num2str(s_props.init_threshold) ' for ' ...
	   get(s, 'id')]);
  fail_cond = true(1);
else
  fail_cond = false(1);
end

if plotit
  class_name = strrep(class(s), '_', ' ');
  v = voltage_points(3:(max_vpp_idx + 2)) * 1e3;
  t = (3 : max_idx) * s.trace.dt * 1e3;
  t_data = s.trace.data(3 : max_idx);
  if isfield(s_props, 'quiet') || isfield(s.trace.props, 'quiet')
    title_str = '';
  else
    title_str = [ strrep(class(s), '_', ' ') ': ' get(s, 'id') ', ' ];
  end
  a_plot = ...
      plot_abstract({s.trace.data((3 * dec_factor): dec_factor : max_idx) * s.trace.dy * 1e3, ...
		     d1o/max(abs(d1o)), ...
		     trace_data(3 : floor(max_idx / dec_factor)) * s.trace.dy * 1e3, ...
		     d1o/max(abs(d1o)), ...
		     v, interp_vpp(3:(max_vpp_idx + 2))/max(abs(interp_vpp)), ...
		     v, d1/max(abs(d1)), v, d2/max(abs(d2)), v, d3/max(abs(d3)),...
		     v, k/max(abs(k)), '.-', ...
		     v(max_k_idx), interp_vpp(max_k_idx + 2)/max(abs(interp_vpp)), 'xr' , ...
		     v(max_k_near_d2vpp_idx), interp_vpp(max_k_near_d2vpp_idx + 2)/max(abs(interp_vpp)), '+c' , ...
		     v(max_d2vpp_idx), interp_vpp(max_d2vpp_idx + 2)/max(abs(interp_vpp)), 'dm' , ...
		     v(max_d3vpp_idx), interp_vpp(max_d3vpp_idx + 2)/max(abs(interp_vpp)), '^' }, ...
		    {'voltage [mV]', 'normalized'}, ...
		    [ title_str 'phase-plane methods, max of derivatives and curvature ' ...
		     'K_p = d^2v\prime/dv^2[1 + dv\prime/dv^2]^{-3/2}, v\prime=dv/dt' ], ...
		    {['v\prime / ' sprintf('%.2f', max(abs(d1o)))], ...
		     ['v\prime / ' sprintf('%.2f', max(abs(d1o))) ' (smooth)' ], ...
		     ['v\prime / ' sprintf('%.2f', max(abs(interp_vpp))) ' (interp)' ], ...
		     ['dv\prime/dv / ' sprintf('%.2f', max(abs(d1))) ], ...
		     [ 'd^2v\prime/dv^2 / ' sprintf('%.2f', max(abs(d2)))], ...
		     [ 'd^3v\prime/dv^3 / ' sprintf('%.2f', max(abs(d3)))], ...
		     ['K_p / ' sprintf('%.2f', max(abs(k)))], ...
		     'max K_p(v)', 'nearest max K_p(v)', ...
		     'max d^2v\prime/dv^2', 'max d^3v\prime/dv^3'}, 'plot');
  a_plot = setProp(a_plot, 'axisLimits', [v(1) v(max_vpp_idx) NaN NaN]);
end
%#		     t, t_data/max(abs(t_data)), ...

%# Translate from voltage to time points
function t_idx = transV2T(s, start_idx, max_idx, voltage_points, idx)
  times = find((s.trace.data((start_idx + 2) : (max_idx + 2)) * s.trace.dy) > ...
	       voltage_points(idx + 2));
  denom = s.trace.data(times(1) + start_idx + 1) - ...
      s.trace.data(times(1) + start_idx);
  %# No slope? Just return the base value
  if denom == 0
    t_idx = start_idx + times(1);
  else %# Otherwise, calculate rational value using linear interpolation
    t_idx = start_idx + times(1) + ...
	(voltage_points(idx + 2) / s.trace.dy - ...
	 s.trace.data(times(1) + start_idx)) / denom;
  end

function idx = findMax(data, voltage_points)
  [max_idcs] = maxima(data);
  
  %# Highest maximum
  [sorted, sorted_idx] = sort(data(max_idcs));

  %#sorted
  %#voltage_points(max_idcs(sorted_idx) + 2)

  if length(max_idcs) == 0 
    error('calcInitVm:failed', 'No local maxima found!');
  else
    if max_idcs(sorted_idx(end)) == 1	%# If maximum is the first point in trace
      if length(max_idcs) > 1
        idx = max_idcs(sorted_idx(end - 1));%# Take next nearest maxima
      else
	error('calcInitVm:failed', 'Too few local maxima!');
      end
    else
      idx = max_idcs(sorted_idx(end));	%# Otherwise highest maximum
    end
  end
  

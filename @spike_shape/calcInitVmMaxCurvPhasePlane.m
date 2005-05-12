function [init_idx, a_plot, fail_cond] = ...
      calcInitVmMaxCurvPhasePlane(s, max_idx, min_idx, plotit)

% calcInitVmMaxCurvPhasePlane - Calculates the voltage at the maximum curvature in the phase plane as action potential threshold.
%
% Usage:
% [init_idx, a_plot] = calcInitVmMaxCurvPhasePlane(s, max_idx, min_idx, plotit)
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
%	a_plot: plot_abstract, if requested.
%
% See also: calcInitVm
%
% $Id$
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2005/04/12
%   Inspired by Sekerli, Del Negro, Lee and Butera. IEEE Trans. Biomed. Eng.,
%	51(9): 1665-71, 2004 and by personal communication with Murat Şekerli.

if ~ exist('plotit')
  plotit = 0;
end
a_plot = [];

%#d2 = diff2T(s.trace.data(1 : (max_idx + 2)) * s.trace.dy, s.trace.dt);
d1o = diffT(s.trace.data(1 : (max_idx + 2)) * s.trace.dy, s.trace.dt);
%#d2 = d2(3:(end -2));
d1o = d1o(3:(end -2));

%# Find max in derivative
[max_d1o, max_d1o_idx] = max(d1o);

%# Find min in voltage before end
[min_v, min_v_idx] = min(s.trace.data(1 : max_d1o_idx));

%# Interpolate to find a regular intervalled phase-plane representation
%# Voltage range is from the intial resting point to the spike peak.
%# Tried both spline and pchip, spline overfits.
num_points = 200;
start_idx = max(1, min_v_idx - 1);
dv = (s.trace.data(max_d1o_idx + 2) - s.trace.data(start_idx + 2))/num_points;
voltage_points = ...
    (s.trace.data(start_idx + 2):dv:s.trace.data(max_d1o_idx + 2)) * s.trace.dy;

%# arbitrarily remove duplicate values from voltage values
[orig_v_points unique_idx] = unique(s.trace.data((start_idx + 2) : (max_d1o_idx + 2)));
d1o_points = d1o(start_idx:max_d1o_idx);

%# Check if there are enough points to interpolate
if length(d1o_points) < 2
  error('calcInitVm:failed', 'Less than two vPP data points in the stem of %s.', ...
	get(s, 'id'));
end

interp_vpp = ...
    pchip(orig_v_points * s.trace.dy, ...
	  d1o_points(unique_idx), voltage_points);

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
  max_d2vpp_t_idx = transV2T(s, start_idx, max_idx, voltage_points, max_d2vpp_idx);

  %# Local maximum of d3vpp, closest to max_d2vpp_idx, candidate for APthr
  max_d3vpp_idx = maxima(d3);

  if length(max_d3vpp_idx) > 0
    [sorted, sorted_idx] = sort(abs(max_d3vpp_idx - max_d2vpp_idx));
    max_d3vpp_idx = max_d3vpp_idx(sorted_idx(1));
    max_d3vpp_t_idx = transV2T(s, start_idx, max_idx, voltage_points, max_d3vpp_idx);
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
max_k_t_idx = transV2T(s, start_idx, max_idx, voltage_points, max_k_idx);

thr_vol = voltage_points(max_k_idx + 2);

if ~ isnan(max_d2vpp_idx)

  %# Find highest local maximum of k closest to max_d2vpp_idx
  distance = max_k_idcs - max_d2vpp_idx;
  [sorted, sorted_idx] = sort(distance .* distance ./ k(max_k_idcs));

  %#sorted
  %#voltage_points(max_k_idcs(sorted_idx) + 2)

  %# Skip negative peaks
  max_k_near_d2vpp_idx = find(sorted >= 0);

  if length(max_k_near_d2vpp_idx) > 0
    max_k_near_d2vpp_idx = max_k_idcs(sorted_idx(max_k_near_d2vpp_idx(1)));
    max_k_near_d2vpp_t_idx = transV2T(s, start_idx, max_idx, voltage_points, max_k_near_d2vpp_idx);
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

if interp_vpp(max_k_near_d2vpp_idx + 2) > s.props.init_threshold
  warning('calcInitVm:info', ['vPP curvature ignored, v'' > ' num2str(s.props.init_threshold) ' for ' ...
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
  if isfield(s.props, 'quiet') || isfield(s.trace.props, 'quiet')
    title_str = '';
  else
    title_str = [ strrep(class(s), '_', ' ') ': ' get(s, 'id') ', ' ];
  end
  a_plot = ...
      plot_abstract({s.trace.data(3 : max_idx) * s.trace.dy * 1e3, ...
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
  t_idx = start_idx + times(1) + ...
      (voltage_points(idx + 2) / s.trace.dy - s.trace.data(times(1) + start_idx)) / ...
      (s.trace.data(times(1) + start_idx + 1) - s.trace.data(times(1) + start_idx));

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
  

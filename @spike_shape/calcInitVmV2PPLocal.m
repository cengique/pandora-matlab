function [init_idx, a_plot] = calcInitVmV2PPLocal(s, max_idx, min_idx, lo_thr, plotit)

% calcInitVmV2PPLocal - Calculates the action potential threshold by finding 
%			the local second derivative maximum in voltage-time slope 
%			versus voltage phase plane, nearest a slope threshold
%			crossing.
%
% Usage:
% [init_idx, a_plot] = calcInitVmV2PPLocal(s, max_idx, min_idx, lo_thr, plotit)
%
% Description:
%   Parameters:
%	s: A spike_shape object.
%	max_idx: The index of the maximal point of the spike_shape [dt].
%	min_idx: The index of the minimal point of the spike_shape [dt].
%	lo_thr: Lower threshold for time voltage slope.
%	plotit: If non-zero, plot a graph annotating the test results 
%		(optional).
%
%   Returns:
%	init_idx: Its index in the spike_shape [dt].
%	a_plot: plot_abstract, if requested.
%
% See also: calcInitVm
%
% $Id$
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2004/11/18
%   Taken from Sekerli, Del Negro, Lee and Butera. IEEE Trans. Biomed. Eng.,
%	51(9): 1665-71, 2004.

if ~ exist('plotit')
  plotit = 0;
end
a_plot = [];

d3 = diff3T(s.trace.data(1 : (max_idx + 2)) * s.trace.dy, s.trace.dt);
d2 = diff2T(s.trace.data(1 : (max_idx + 2)) * s.trace.dy, s.trace.dt);
d1 = diffT(s.trace.data(1 : (max_idx + 2)) * s.trace.dy, s.trace.dt);
%# Remove boundary artifacts
d3 = d3(4:(end - 3)); 
d2 = d2(4:(end - 3));
d1 = d1(4:(end - 3));
h = (d3 .* d1 - d2 .* d2) ./ (d1 .* d1 .* d1);

%# Find  local maxima in h 
dh = diffT(h, 1);
dh2 = dh(2:end) .* dh(1:(end-1));
hd2 = diff2T(h, 1); %# 2nd deriv
zc = find(dh2 < 0 & dh(1:(end-1)) > 0);
if length(zc) == 0 
  %# TODO: this should throw an error that can be caught and handled
  %# then another method can be tried.
  warning('spike_shape:sekerli:no_local_maximum', ...
	  ['Failed to find local maximum of phase place acceleration '...
	   ' during rising edge of spike shape. ' ...
	   'Taking the first point in the trace as threshold instead.']);
  %#'near voltage slope threshold crossing at ' ...
  %#   num2str(lo_thr) '. ', ...
  idx = 1;
else
  %# find slope threshold crossing point
  cross_idx = find(d1 >= lo_thr); 
  if length(cross_idx) == 0 
    warning('spike_shape:sekerli:threshold_derivative', ...
	    ['Derivative threshold ' num2str(lo_thr) ...
	     ' failed to find spike initiation point. '...
	     'Taking the first point in the trace as threshold instead.']);
    %# Then, the first point of the trace is the spike initiation point.
    idx = 1;
  else
    cross_idx = cross_idx(1);

    %# choose maximum nearest to crossing point
    [nearest, nearest_idx] = min(abs(zc - cross_idx));
    idx = zc(nearest_idx) + 3;
  end
end
if plotit
  t = (4 : (max_idx -1)) * s.trace.dt * 1e3;
  class_name = strrep(class(s), '_', ' ');
  t_data = s.trace.data(4 : (max_idx -1));
  a_plot = ...
      plot_abstract({t, d1/max(abs(d1)), t, d2/max(abs(d2)), ...
		     t, d3/max(abs(d3)), t, h/max(abs(h)), '.-', ...
		     t, t_data/max(abs(t_data)), ...
		     idx * s.trace.dt * 1e3, s.trace.data(idx)/max(abs(t_data)), '*'}, ...
		    {'time [ms]', 'normalized'}, ...
		    [class_name ': ' get(s, 'id') ', Sekerli''s method, ' ...
		     'local max of h = d^2v\prime/dv^2 nearest to v\prime > ' ...
		     num2str(lo_thr) ' crossing'], ...
		    {'v\prime', 'v\prime\prime', 'v\prime\prime\prime', 'h', ...
		     'v', 'thr'}, 'plot');
end
init_idx = idx;
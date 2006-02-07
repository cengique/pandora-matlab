function [init_idx, a_plot] = calcInitVmSekerliV2(s, max_idx, min_idx, plotit)

% calcInitVmSekerliV2 - Calculates the action potential threshold using the maximum second derivative of the phase space of voltage-time slope versus voltage.
%
% Usage:
% [init_idx, a_plot] = calcInitVmSekerliV2(s, max_idx, min_idx, plotit)
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
s_props = get(s, 'props');

d3 = diff3T_h4(s.trace.data(1 : (max_idx + 2)) * s.trace.dy, s.trace.dt);
d2 = diff2T_h4(s.trace.data(1 : (max_idx + 2)) * s.trace.dy, s.trace.dt);
d1 = diffT(s.trace.data(1 : (max_idx + 2)) * s.trace.dy, s.trace.dt);
%# Remove boundary artifacts
d3 = d3(4:(end - 3)); 
d2 = d2(4:(end - 3));
d1 = d1(4:(end - 3));
h = (d3 .* d1 - d2 .* d2) ./ (d1 .* d1 .* d1);
if isfield(s_props, 'init_threshold')
  add_title = [', while v\prime < ' num2str(s_props.init_threshold)];
  constrained_idx = find(d1 < s_props.init_threshold);
  if length(constrained_idx) == 0 
    error('calcInitVm:failed', ...
	    ['Failed to find any points below derivative threshold ' ...
	     num2str(s_props.init_threshold) ]);
  else    
    [val, idx] = max(h(constrained_idx)); 
    idx = constrained_idx(idx);
  end
else
  add_title = '';
  [val, idx] = max(h); 
end
idx = idx + 3;
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
		     'max of h = d^2v\prime/dv^2' add_title], ...
		    {'v\prime', 'v\prime\prime', 'v\prime\prime\prime', 'h', ...
		     'v', 'thr'}, 'plot');
end
init_idx = idx;

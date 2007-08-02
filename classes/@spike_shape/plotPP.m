function a_plot = plotPP(s)

% plotPP - Plots the dV/dt vs. V phase-plane representation of the spike shape.
%
% Usage:
% a_plot = plotPP(s)
%
% Description:
%
%   Parameters:
%	s: A spike_shape object.
%
%   Returns:
%	a_plot: A plot_abstract object that can be visualized.
%
% See also: spike_shape, plot_abstract
%
% $Id$
%
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2004/11/16

data = s.trace.data * s.trace.dy * 1e3;
deriv = diff(data) / (s.trace.dt * 1e3); %# mV/ms

%# Derivative doesn't really match the voltage points here!
%# Diff finds derivatives between points not on points!
a_plot = plot_abstract({data(2:end), deriv, '.-'}, ...
		       {'voltage [mV]', '~dV/dt [mV/ms]'}, ...
		       ['Spike shape in phase-plane of ' get(s, 'id') ], ...
		       {'dV/dt (diff)'}, 'plot', struct('grid', 1));

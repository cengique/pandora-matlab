function a_plot = plotTPP(s)

% plotTPP - Plots the dV/dt vs. V phase-plane representation of the spike shape.
%
% Usage:
% a_plot = plotTPP(s)
%
% Description:
%   Uses the Taylor series estimation for finding the derivative dV/dt.
%
%   Parameters:
%	s: A spike_shape object.
%
%   Returns:
%	a_plot: A plot_abstract object that can be visualized.
%
% See also: spike_shape, plot_abstract, diffT
%
% $Id$
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2004/11/16

data = s.trace.data * s.trace.dy * 1e3;
deriv = diffT(data, s.trace.dt * 1e3); %# mV/ms

a_plot = plot_abstract({data(3:(end-2)), deriv(3:(end-2)), '.-'}, ...
		       {'voltage [mV]', '~dV/dt [mV/ms]'}, ...
		       ['Spike shape in phase-plane of ' get(s, 'id') ], ...
		       {'dV/dt (Taylor)'}, 'plot', struct('grid', 1));

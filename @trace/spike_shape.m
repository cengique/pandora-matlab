function obj = spike_shape(t, s)

% spike_shape - Convert averaged spikes in the trace to a spike_shape object.
%
% Usage:
% obj = spike_shape(trace, spikes)
%
%   Parameters:
%	trace: A trace object.
%	spikes: A spikes object on trace.
%
% Description:
%   Creates a spike_shape object.
%		
% See also: spike_shape
%
% $Id$
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2004/08/04

if nargin < 2 %# Called with insufficient params
  error('Need parameters.');
end


%# Find minimal ISI value for maximal range that can be acquired with
%# single spikes
min_isi = min(getISIs(s));

%# Points from left side of peak, depends on the half minimal isi
left = floor(min(5e-3 / t.dt, min_isi/2));

%# Calculate right side accordingly
%# Add some more on the right side
right = min_isi - left + floor(min(3e-3 / t.dt, left /2)); 

if length(s.times) > 0
  [allspikes, avgspikes] = collectspikes(t.data, s.times, left, right, 0);

  
  obj = spike_shape(avgspikes', t.dt, t.dy, t.id);
else
  %#error('spike_shape:no_spikes', 'No spikes exist!');
  %# Create empty object instead of error
  obj = spike_shape([], t.dt, t.dy, t.id);
end



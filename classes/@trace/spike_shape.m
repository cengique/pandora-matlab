function obj = spike_shape(t, s, props)

% spike_shape - Convert averaged spikes in the trace to a spike_shape object.
%
% Usage:
% obj = spike_shape(trace, spikes, props)
%
%   Parameters:
%	trace: A trace object.
%	spikes: A spikes object on trace.
%
% Description:
%   Creates a spike_shape object from averaged spikes. USE THIS ONLY IF
% YOU WANT TO USE AVERAGED SPIKE SHAPES.
%		
% See also: spike_shape
%
% $Id$
%
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2004/08/04

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin < 2 % Called with insufficient params
  error('Need parameters.');
end

if ~ exist('props', 'var')
  props = struct;
end

% Find minimal ISI value for maximal range that can be acquired with
% single spikes
min_isi = min(getISIs(s));

% Set min_isi to 0 if no ISI so that left, right don't become empty lists
if isempty(min_isi)
  if ~isempty(s.times)
    spike_time = s.times;
  else
    spike_time = NaN;
  end
  min_isi = 7e-3 / t.dt + length(t.data) - spike_time - floor(3e-3 / t.dt);
end

% Points from left side of peak, depends on the half minimal isi
left = floor(min(7e-3 / t.dt, min_isi/2));

% Calculate right side accordingly
% Add some more on the right side
right = min_isi - left + floor(min(3e-3 / t.dt, left /2));

if length(s.times) > 0
  [allspikes, avgspikes] = collectspikes(t.data, s.times, left, right, 0);
  
  obj = spike_shape(avgspikes', t.dt, t.dy, t.id, props);
else
  %error('spike_shape:no_spikes', 'No spikes exist!');
  % Create empty object instead of error
  obj = spike_shape([], t.dt, t.dy, t.id, props);
end



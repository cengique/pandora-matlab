function obj = songify(data, dy, dt, id, props)

% songify - Song data from trace.
%
% Usage:
% obj = sonfigy(times, num_samples, dt, id)
%
%   Parameters:
%	times: The spike times [dt].
%   dy: Amplitude resolution.
%	dt: Time resolution [s].
%	id: Identification string.
%
% Description:
%
%   Returns a structure object with the following fields:
%	times, dy, dt, id.
%
% General methods of spikes objects:
%   songify		- Construct a new songify object.
%   plot      - Graph the spikes.
%   display		- Returns and displays the identification string.
%
% Additional methods:
%   See methods('songify')
%
% See also: trace/songify, trace, spike_shape, period

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 % Empty constructor
  % obj.data = [];
  obj.dy = 1;
  obj.dt = 1;
  obj.id = '';
  sgram.data = [];
  sgram.freqrange = [0, 0];
  sgram.timerange = [0, 0];
  obj.sgram = sgram;
  obj.features = struct;
  obj = class(obj, 'songify');
elseif isa(data,'songify') % copy constructor
  obj = data;
else
  % These properties carry over from the trace object
  % obj.data = data;
  obj.dy = dy;
  obj.dt = dt;
  obj.id = id;
  
  % Add spectrogram
  sgram.data = [];
  sgram.freqrange = [0, 0];
  sgram.timerange = [0, 0];
  obj.sgram = sgram;
  
  % Get features from the data
  obj.features = struct;
  
  % Create the final object
  obj = class(obj, 'songify');
  
  obj.features = getFeatures(obj, data);
end

% Put start and end times in arrays in this class

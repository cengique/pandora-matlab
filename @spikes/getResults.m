function results = getResults(s, plotit)

% getResults - Runs all tests defined by this class and return them in a 
%		structure.
%
% Usage:
% results = getResults(s)
%
% Description:
%
%   Parameters:
%	s: A spikes object.
%
%   Returns:
%	results: A structure associating test names to values 
%		in ms and mV (or mA).
%
% See also: spikes
%
% $Id$
%
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2004/09/13

if ~ exist('plotit')
  plotit = 0;
end

%# Check for empty object first.
if isempty(s.trace.data) 
  results.spikeRate = 0;
  results.spikeRateISI = 0;
  results.ISICV = NaN;
  return;
end

%# convert all to ms/mV(mA)
ms_factor = 1e3 * s.trace.dt;
mV_factor = 1e3 * s.trace.dy;

%# Run tests
results.spikeRate = spikeRate(s);
results.spikeRateISI = spikeRateISI(s);
results.ISICV = ISICV(s);

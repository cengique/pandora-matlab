function results = getPotResults(a_trace)

% getResults - Runs test results for aggregate potential values (avg, min, and max)
%	       for the whole trace period and return them in a structure.
%
% Usage:
% results = getPotResults(t)
%
% Description:
%
%   Parameters:
%	t: A trace object.
%
%   Returns:
%	results: A structure associating potential info names to values in mV as
%		 follows:
%	   min - minimum potential for the whole trace.
%	   avg - average potential for the whole trace.
%	   max - maximum potential for the whole trace.
%
% See also: spike_shape
%
% $Id: getResults.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2004/09/13
%   Vladislav Sekulic <vlad.sekulic@utoronto.ca>, 2011/03/19

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('plotit', 'var')
  plotit = 0;
end

% Check for empty object first.
if isempty(a_trace.data) 
  results.min = NaN;
  results.avg = NaN;
  results.max = NaN;
  return;
end

% convert all to ms/mV(mA)
ms_factor = 1e3 * a_trace.dt;
mV_factor = 1e3 * a_trace.dy;

% Run tests
results.min = calcMin(a_trace) * mV_factor;
results.max = calcMax(a_trace) * mV_factor;
results.avg = calcAvg(a_trace) * mV_factor;

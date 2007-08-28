function a_spikes = vertcat(a_spikes, varargin)

% vertcat - Vertical concatanation [a_spikes;with_spikes;...] operator.
%
% Usage:
% a_spikes = vertcat(a_spikes, with_spikes, ...)
%
% Description:
%   Concatanates spike times of with_spikes with that of a_spikes. Overrides the built-in
% vertcat function that is called when [a_spikes;with_spikes] is executed.
%
%   Parameters:
%	a_spikes, with_spikes, ...: Spikes objects.
%		
%   Returns:
%	a_spikes: A tests_spikes that contains times of all given spikes objects.
%
% See also: vertcat, spikes
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/08/16

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

%# Recurse to support variable number of inputs
if length(varargin) > 1
  with_spikes = vertcat(varargin{1}, varargin{2:end});
else
  with_spikes = varargin{1};
end

a_spikes = addSpikes(a_spikes, with_spikes.times);
a_spikes = set(a_spikes, 'num_samples', a_spikes.num_samples + with_spikes.num_samples);

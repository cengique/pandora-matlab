function meanFreq = meanSpikeFreq( spike_train, dt, period )

% meanSpikeFreq - Returns the mean firing frequency in Hz according to mean \
%  	    inter-spike-interval of the given spike train and the 
%	    time resolution dt.
%
% Usage:
% meanFreq = meanSpikeFreq( spike_train, dt, period )
%
% Description:
% 	Parameters:
%		spike_train: Spike times returned by findspikes
%		dt: Time step size [s]
%		period: Duration of the total time period [dt]
%
% See also:
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/03/08

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ( length(spike_train) == 0 )
  meanFreq = 0;
elseif ( length(spike_train) == 1 )
  meanFreq = 1 / (dt * period);
else
  isi = diff(spike_train);
  meanFreq = 1 / (dt * mean(isi));
end

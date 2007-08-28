function [spikes, spksavg, timeidx]=collectspikes(trace,timeidx,left,right,plotit)

% [spikes, spksavg, timeidx] = collectspikes(trace, timeidx, left, right, plotit);
% 
% Gets and returns the spikes in trace indicated by the timeidx;
% left and right are how much (in samples) do you 
% want to sample "around" the spikes peaks. If plotit is 1, a figure
% with all spikes superimposed and averaged will be displayed.
%
% NOTE that spikes very near the edges of the trace will NOT be included in the
%	spikes matrix & average if they would be incomplete. When spikes are
%	excluded, the column numbers of the spikes matrix no longer match the original 
%	timeidx vector. For this reason, an updated version of timeidx is returned as 
%	an optional third output. Uncomment the warning line if you want to be
%	informed about spikes being excluded.
%
% Author: <adelgado@biology.emory.edu>
% Modified:
% - Bugfix for boundaries by Cengiz Gunay <cgunay@emory.edu>
% Modified: 10/2005 by J. Edgerton
% - Added optional return for timeidx, with excluded spike times removed so that
%		the columns in the spikes matrix match the index values in timeidx.
% - Added memory pre-allocation to enhance speed.
% - Fixed plotting orientation.

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

spikes = zeros(length(timeidx), left + right + 1);
spksavg = [];

chopped = [];

for i = 1: length(timeidx)
	
	tleft = timeidx(i) - left;
	tright = timeidx(i) + right;

	% Exclude chopped off spikes, keep record of where they occur.
	if tleft < 1 || tright > length(trace)
		chopped = [chopped, i];
	else
		spikes(i, :) = trace(tleft: tright);
	end		
end

if ~ isempty(chopped)
	% Uncomment following line to receive spike exclusion warnings
%	warning('One or more spikes have been excluded from the matrix & avg.');
	timeidx(chopped) = [];
	spikes(chopped, :) = [];
end

if isempty(spikes)
	spikes = [];
else
  spksavg = mean(spikes, 1);

  if plotit == 1
    figure;
    plot(spikes', 'k');
    hold on
    plot(spksavg, 'r', 'LineWidth', 2);
    hold off;
  end
end

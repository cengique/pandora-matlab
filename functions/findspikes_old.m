% [timeidx, peakval, n] = findspikes_old(trace, threshold, plotit)
% 
% Find and return: spike times (timeidx), spike peak amplitude (peakval) 
% and number of spikes (n) in the given trace above the given threshold.
% If plotit is 1, a figure is displayed for visual inspection.
% 
% NOTE: Only positive (up stroke) spike peaks are treated and are found
%       on the basis of a "three-point first derivative evaluation".
% 
% Author: <adelgado@biology.emory.edu>, 2003-03-31

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

function [timeidx, peakval, n] = findspikes_old(trace, thres, plotit)
    
    peakst = find(trace >= thres);
    
    peaksv = ones(size(trace)).*thres;
    
    peaksv(peakst) = trace(peakst);
    
    peaksdy = diff(peaksv)';
    
    timeidx = find(([peaksdy 0] < 0) & ([0 peaksdy] >= 0));
    
    if plotit == 1
      figure
      plot(trace,  'k'), hold on
      plot(peaksv, 'b');
      plot(timeidx, peaksv(timeidx), 'ro');
    end
    
    if nargout > 1
        peakval = peaksv(timeidx)';
        [m, n]  = size(peakval);
    end
    
    clear m peaks*;

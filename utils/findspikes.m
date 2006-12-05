% [timeidx, peakval, n] = findspikes(trace, threshold, plotit)
% 
% Find and return: spike times (timeidx), spike peak amplitude (peakval) 
% and number of spikes (n) in the given trace above the given threshold.
% If plotit is 1, a figure is displayed for visual inspection.
% 
% NOTE: Only positive (up stroke) spike peaks are treated and are found
%       on the basis of a "three-point first derivative evaluation".
% 
% Author: <adelgado@biology.emory.edu>, 2003-03-31

function [timeidx, peakval, n] = findspikes(trace, thres, plotit)
    
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

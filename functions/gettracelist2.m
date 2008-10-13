
% gettracelist2 - Gets a list of the form: '1 3 7-10' and returns a column vector with the traces numbers, and the number of traces.
%
% Usage: 
% [traces, ntraces] = gettracelist2('list');
%
% Description:
%  Please note the space between single traces and the dash for ranges of
%traces.
%
% Author: <adelgado@biology.emory.edu>

function [traces, ntraces] = gettracelist2(liststr)
if isnumeric(liststr) % add by Li Su. for compatibility just in case.
    traces=liststr;
else
	tidx = sscanf(liststr, '%i');
	
	rgs = find(tidx(:, 1) < 0);
	
	nrgs = size(rgs);
	
	if (nrgs(1, 1)) >= 1;
    	tidx(rgs(:, 1), 1) = tidx(rgs(:, 1), 1)*-1;
	end
	
	traces = zeros(max(tidx), 1);
	
	ntrs = size(tidx);
	
	for i = 1: ntrs(1, 1);
    	traces(tidx(i, 1), 1) = tidx(i, 1);
	end
	
	ridx = zeros(nrgs(1, 1), 1);
	
	if (nrgs(1, 1)) >= 1;
    	for i = 1: nrgs(1, 1);
        	ridx(i, 1) = tidx(rgs(i, 1), 1)-tidx(rgs(i, 1)-1, 1)+1;
    	end
    	for i = 1: nrgs(1, 1);
        	range = [tidx(rgs(i, 1)-1, 1): tidx(rgs(i, 1), 1)];
        	traces(tidx(rgs(i, 1)-1, 1): tidx(rgs(i, 1), 1), 1) = range';
    	end
	end
	
	traces = find(traces(:, 1) ~= 0);
	clear tidx ntrs ridx nrgs rgs range trls;
end	
ntrs = size(traces);
ntraces = ntrs(1, 1);

function [avg_tr sd_tr] = avgTraces(traces, props)

% avgTraces - Average multiple traces.
%
% Usage: 
% [avg_tr sd_tr] = avgTraces(traces, props)
%
% Parameters:
%	traces: A vector of trace objects.
%	props: A structure with any optional properties.
%     calcSE: If given, calculate standard error instead of deviation.
%
% Returns:
%	avg_tr: A trace object that holds the average.
%	sd_tr: A trace object that holds the standard deviation or error.
%
% Description:
%
% See also: trace
%
% $Id: avgTraces.m 1188 2010-04-09 19:56:27Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/11/09

% Copyright (c) 2010 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

% TODO: implement separately as the sum() function
num_traces = length(traces);
if num_traces > 1
  avg_tr = traces(1);  
  for trace_num = 2:num_traces
      avg_tr = avg_tr + traces(trace_num);
  end
  avg_tr = avg_tr ./ num_traces;
end

% SD/E
if num_traces > 1
  sd_tr = (traces(1) - avg_tr).^2;
  for trace_num = 2:num_traces
      sd_tr = sd_tr + (traces(trace_num) - avg_tr).^2;
  end
  sd_tr = sd_tr ./ num_traces;
  if isfield(props, 'calcSE')
      sd_tr = sd_tr ./ num_traces;
  end
  sd_tr = sqrt(sd_tr);
end
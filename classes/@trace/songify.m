function obj = songify(t)

% songify - Convert trace to songify object for spike timing calculations.
%
% Usage:
% obj = songify(trace)
%
%   Parameters:
%	trace: A trace object.
%
% Description:
%   Creates a songify object.
%
% See also: songify
%
% $Id$
%
% Author:
%   Benjamin Bolte <bkbolte18@gmail.com>, 29 Mar 2015

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 % Called with no params
    error('Need trace parameter.');
end

% if the trace object contains multiple traces, return array of songify
% objects

num_traces = size(t.data, 2);
if num_traces > 1
    obj = repmat(songify, 1, num_traces);
    
    for trace_num = 1:num_traces
        obj(trace_num) = songify(set(t, 'data', t.data(:, trace_num)), t.dy, t.dt, t.id);
    end
    
    return
else
    obj = songify(t.data, t.dy, t.dt, t.id);
end
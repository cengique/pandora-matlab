function [results profs] = getResults(a_cc, props)

% getResults - Extract measurement results.
%
% Usage:
% results = getResults(a_cc)
%
% Parameters:
%   a_cc: A cip_trace object.
%   props: A structure with any optional properties.
%     stepNum: Current step to get results for (default=2).
%
% Returns:
%   results: A structure associating test names with result values.
%
% Description:
%
% See also: cip_trace, trace, spike_shape
%
% $Id: getResults.m 818 2007-08-28 20:28:51Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/02/22

% Copyright (c) 20011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

props = ...
    mergeStructs(defaultValue('props', struct), ...
                 get(a_cc, 'props'));

step_num = getFieldDefault(props, 'stepNum', 2);

% go through i_steps and collect cip_trace results
a_vc = a_cc.voltage_clamp;

% make a cip_trace object
% use custom filter by default since most data won't be sampled at 10 kHz

% TODO: shouldn't istep value be a DB param?

num_isteps = size(a_vc.i_steps, 2);
profs = cell(1, num_isteps);
for istep_num = 1:num_isteps  
  a_results = struct;
  a_ct = ...
    cip_trace(a_vc.v.data, a_vc.v.dt, ...
              a_vc.v.dy, ...
              a_vc.time_steps(1), ...
              diff(a_vc.time_steps(1:2)), ...
              a_vc.id, ...
              mergeStructs(props, ...
                           struct('custom_filter', 1, ...
                                  'channel', istep_num)));

  % make current step a parameter
  a_results.cip_level_pA = ...
      1e3 * a_vc.i_steps(step_num, istep_num);
  profs{istep_num} = getProfileAllSpikes(a_ct);
  a_results = ...
      mergeStructs(a_results, ...
                   getResults(profs{istep_num}));
  results = defaultValue('results', repmat(a_results, 1, num_isteps));
  results(istep_num) = a_results;
end

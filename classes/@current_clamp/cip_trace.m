function [a_ct cip_level_pA] = cip_trace(a_cc, cip_num, props)

% cip_trace - Return a cip_trace object of the desired current step.
%
% Usage:
% a_ct = cip_trace(a_cc, cip_num, props)
%
% Parameters:
%   a_cc: A cip_trace object.
%   cip_num: Index of CIP level.
%   props: A structure with any optional properties.
%     stepNum: Current step to get results for (default=2).
%
% Returns:
%   a_ct: A cip_trace object with voltage.
%   cip_level_pA: applied current magnitude [pA].
%
% Description:
%
% See also: cip_trace, trace, spike_shape
%
% $Id$
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

a_vc = a_cc.voltage_clamp;

% make a cip_trace object
% use custom filter by default since most data won't be sampled at 10 kHz
istep_num = cip_num;
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
cip_level_pA = ...
      1e3 * a_vc.i_steps(step_num, istep_num);

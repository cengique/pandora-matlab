function [trace_v] = makeIdealClampV(t_vals, pre_v, pulse_v, post_v, dt, ...
                                     id, props)

% makeIdealClampV - Make voltage traces that mimic an ideal voltage clamp.
%
% Usage:
% [trace_v] = makeIdealClampV(t_vals, pre_v, pulse_v, post_v, dt, id, props)
%
% Parameters:
%   t_vals: Vector with times of pulse start, end and trace end [ms].
%   pre_v, post_v: Holding and final voltage values [mV].
%   pulse_v: Vector of variable voltage steps [mV].
%   dt: Resolution of time in trace produced [ms].
%   id: An identifying string.
%   props: A structure with any optional properties.
%     (Rest passed to trace)
%		
% Returns:
%   trace_v: A trace object with the voltage traces.
%
% Description:
%
% Example:
% >> tr_v = makeIdealClampV([10 100 110], -90, -80:10:60, -10, 1e-1, ...
%                           'Na chan voltage clamp protocol')
% >> plot(tr_v)
% >> vc_test = voltage_clamp(data_i, tr_v.data, tr_v.dt, 1e-9, 'sim Na data')
%
% See also: trace, voltage_clamp
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/07

props = defaultValue('props', struct);

pre_t = round(t_vals(1)/dt);
pulse_t = round(diff(t_vals(1:2))/dt);
post_t = round(diff(t_vals(2:3))/dt);
num_steps = length(pulse_v);

trace_v = ...
    trace([ repmat(pre_v, pre_t, num_steps); ...
            repmat(pulse_v, pulse_t, 1); ...
            repmat(post_v, post_t, num_steps) ], ...
          dt*1e-3, 1e-3, id, props);

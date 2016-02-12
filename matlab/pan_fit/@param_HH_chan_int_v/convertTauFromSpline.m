function tau_f = convertTauFromSpline(a_chan, m_h, props)

% convertTauFromSpline - Convert model m or h tau functions from spline to HH skewbell.
%
% Usage:
% tau_f = convertTauFromSpline(a_chan, m_h, props)
%
% Parameters:
%   a_chan: A param_HH_chan_int_v object.
%   m_h: String denoting 'm' or 'h' gate to convert.
%   props: A structure with any optional properties.
%     ifPlot: If 1, make a comparison plot (default=0).
%     vValues: Use these voltage values for fitting (default=-60:60).
% 
% Returns:
%   tau_f: Returned param_tau_skewbell_v function.
%
% Description:
%
% Example:
% >> a_chan = param_HH_chan_int_v(...)
% >> tau_m = convertTauFromSpline(a_chan, 'm')
%
% See also: param_act, param_tau_spline_v, param_tau_skewbell_v
%
% $Id: convertTauFromSpline.m 276 2010-11-09 23:30:35Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/05/12

props = defaultValue('props', struct);
title_str = defaultValue('title_str', '');

m_h_gate = get(a_chan, m_h);

tau_f = param_tau_skewbell_v([2 0.5 ...
                    m_h_gate.inf.V_half.data ...
                    m_h_gate.inf.k.data], ...
                             [ m_h_gate.tau.id ]);

tau_f = selectFitParams(tau_f, 'V_half', 0);
tau_f = selectFitParams(tau_f, 'k', 0);

%getParamsStruct(tau_f, struct('onlySelect', 1))

v_vals = getFieldDefault(props, 'vValues', -60:1:60);
tau_f = ...
    optimize(tau_f, v_vals, f(m_h_gate.tau, v_vals));
getParamsStruct(tau_f)

% TODO: update channel directly?

if getFieldDefault(props, 'ifPlot', 1) == 1
  plotFigure(plot_superpose({plot_abstract(m_h_gate.tau, 'spline'), ...
                      plot_abstract(tau_f, 'HH')}))
end

function a_pf = ...
      param_I_Neurofit(neurofit_params, id, props)
  
% param_I_Neurofit - Create I channel from Neurofit parameters using param_I_int_v.
%
% Usage:
%   a_pf = 
%     param_I_Neurofit(neurofit_params, id, props)
%
% Parameters:
%   neurofit_params: Structure coming from paramsNeurofit function.
%   id: An identifying string for this function.
%   props: A structure with any optional properties.
%     name: Short name to use in channel description
%     tauDt: Specify tau units [s] (default=1e-3=[ms])
%     gmaxDS: Specify gmax units [S] (default=1e-9=[nS])
%     (Rest passed to param_I_int_v)
%		
% Returns a structure object with the following fields:
%	a_pf: Holds the voltage->current function.
%
% Description:
%   Uses splines to make taus as continuous functions of voltage. Dummy
%   tau values are added at -100 and 100 mV using last known taus. WARNING:
% assumes units are in: gmax [nS], tau [ms] and V [mV].
%
% Example:
% >> f_Na_v = param_I_Neurofit(paramsNeurofit('Na_chan_fits_Report.txt'), 'I_Na');
%
% See also: param_I_int_v, param_func
%
% $Id: param_I_Neurofit.m 128 2010-06-07 21:36:08Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/13

props = defaultValue('props', struct);
name = getFieldDefault(props, 'name', '');
if ~ isempty(name)
  name_comma = [ name ', ' ];
else
  name_comma = '';
end

if isfield(props, 'tauDt')
    tau_dt = props.tauDt * 1e3;
else
    tau_dt = 1;
end

% convert gmax to uS
if isfield(props, 'gmaxDS')
    gmax_dS = props.gmaxDS * 1e6;
else
    gmax_dS = 1e-3;
end

minf_v = ...
    param_act([neurofit_params.V2m neurofit_params.sm], [ 'm_{' name_comma '\infty}' ]);

mtau_v = ...
    param_tau_spline_v([-100, neurofit_params.tau_m(1, :), 100], ...
                       [neurofit_params.tau_m(2, 1), neurofit_params.tau_m(2, :), neurofit_params.tau_m(2, end)] * tau_dt, ...
                       [ '\tau_{' name_comma 'm}' ]); 

m_d = param_act_deriv_v(minf_v, mtau_v, [ 'm_{' name '}' ], ...
                           struct('name', 'm'));

if neurofit_params.nh > 0
  
  hinf_v = ...
      param_act([neurofit_params.V2h neurofit_params.sh], [ 'h_{' name_comma '\infty}' ]);

  htau_v = ...
      param_tau_spline_v([-100, neurofit_params.tau_h1(1, :), 100], ...
                         [neurofit_params.tau_h1(2, 1), neurofit_params.tau_h1(2, :), neurofit_params.tau_h1(2, end)] * tau_dt, ...
                         [ '\tau_{' name_comma 'h}' ]); 

  h_d = param_act_deriv_v(hinf_v, htau_v, [ 'h_{' name '}' ], ...
                          struct('name', 'h'));
else
  h_d = param_func_nil(1);
end

% 2nd tauh?
if neurofit_params.nh > 1
  htau2_v = ...
      param_tau_spline_v([-100, neurofit_params.tau_h2(1, :), 100], ...
                         [neurofit_params.tau_h2(2, 1), neurofit_params.tau_h2(2, :), neurofit_params.tau_h2(2, end)] * tau_dt, ...
                         [ '\tau_{' name_comma 'h2}' ]); 
  h2_d = param_act_deriv_v(hinf_v, htau2_v, [ 'h2_{' name '}' ], ...
                           struct('name', 'h2'));

  a_pf = ...
      param_I_2tauh_int_v([neurofit_params.p neurofit_params.gmax*gmax_dS ...
                      neurofit_params.Erev neurofit_params.f1], m_d, h_d, h2_d, ...
                          ['I_{' name '}'], props);
else
  a_pf = ...
      param_I_int_v([neurofit_params.p 1 ...
                     neurofit_params.gmax*gmax_dS neurofit_params.Erev], m_d, h_d, ...
                    ['I_{' name '}'], props);
end

function [pas cap_f] = addCapTrans(pas, Cm_Re_est, props)

% addCapTrans - Add back previously subtracted transient capacitance currents 
%
% Usage:
% [pas] = addCapTrans(pas, Cm_est, Re_est, props)
%
% Parameters:
%   pas: A data_L1_passive object.
%   Cm_Re_est: 1 or 2 element array of capacitance [pF] (mandatory)
%   	and series resistence [MO] (optional).
%   props: Structure with optional properties.
%     delay: An estimate of voltage clamp delay [ms].
%
% Returns:
%   pas: data_L1_passive object with updated current.
%   cap_f: Model to add back subtracted currents. 
%
% Description:
% cap_f is a param_Re_Ce_cap_leak_act_int_t object if there is an
% estimate for Re,  and param_cap_leak_int_t object otherwise.
%
% See also: getResultsPassiveReCeElec, param_Re_Ce_cap_leak_act_int_t, param_cap_leak_int_t
%
% $Id: getResultsPassiveReCeElec.m 896 2007-12-17 18:48:55Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2015/04/10

% Copyright (c) 2011-2015 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

props = defaultValue('props', struct);
delay = getFieldDefault(props, 'delay', 0);

if length(Cm_Re_est) > 1 % with Re
  capleak_f = ...
      param_Re_Ce_cap_leak_act_int_t(struct('gL', 0, 'EL', 0, 'Ce', 1e-10, ...
                                            'Re', Cm_Re_est(2), ...
                                            'Cm', Cm_Re_est(1)*1e-3, ...
                                            'delay', delay, 'offset', 0), ...
                                     'amplifier Re-cap comp', ...
                                     struct);
  capleak_f.Vm = setProp(capleak_f.Vm, 'selectParams', {}); %'delay', 'Ce'
else
  mod_param_props = struct;
  mod_param_props.selectParams = {'delay'};
  capleak_f = ...
      param_cap_leak_int_t(struct('gL', 0, 'EL', 0, 'Cm', Cm_Re_est*1e-3, ...
                                  'delay', delay, 'offset', 0), ...
                           'amplifier cap comp', ...
                           mod_param_props);
end
Cm_Re_est = capleak_f;

% simulate model
cap_md = ...
    model_data_vcs(capleak_f, pas.data_vc, ...
                   [ pas.data_vc.id ': cap comp']);
% add to I
orig_i = pas.data_vc.i;
pas.data_vc.i = pas.data_vc.i + cap_md.model_vc.i;

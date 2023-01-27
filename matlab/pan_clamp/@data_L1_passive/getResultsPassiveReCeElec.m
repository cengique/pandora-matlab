function [results pas_md a_doc] = getResultsPassiveReCeElec(pas, props)

% getResultsPassiveReCeElec - Estimates passive cell params based on Re Ce electrode model.
%
% Usage:
% [results a_doc] = getResultsPassiveReCeElec(pas, props)
%
% Parameters:
%   pas: A data_L1_passive object.
%   props: Structure with optional properties.
%     stepNum: Pre-pulse voltage step to be considered (default=2, so as not to
%     start at the beginning of the trace; see getTimeRelStep). Post-pulse
%     	       step would be stepNum + 1.
%     traceNum: Trace number to be analyzed (default=1).
%     delay: Current response delay from voltage step (default=calculated).
%     gL: Leak conductance (default=calculated).
%     EL: Leak reversal (default=calculated).
%     minResnorm: Lowest resnorm to accept (default=0.004).
%     minRe: Lowest Re value accepted (default=50MO).
%     noReCmEst: If 1, don't use the Re and Ce estimates as seed.
%     noEst: If 1, don't use any estimates (only works when model_f
%     		is given).
%     compCap: Add back subtracted capacitance transients [pF]. If
%     	       there is a second index, it is series resistence [MO].
%     initCe: Initial value for Ce [pF].
%     unitCap: Units of capacitance, such as 'nF' and 'pF' (default).
%     unitCond: Units of conductance, such as 'uS' and 'nS' (default).
%     unitRes: Units of resistance, such as 'kO' and 'MO' (default).
%     passiveV: limit below which traces are only passive (default=-55mV)
%     model_f: Passive membrane and amplifier model to use for fits
%     		(Default=param_Re_Ce_cap_leak_act_int_t).
%     subname: Name of subfunction in model_f to get/set parameters from.
%     debug: If 1, print detailed information. Also enabled if
%     		'warning on verbose' is issued.
%
% Returns:
%   results: A structure with all fitted passive parameters.
%   pas_md: The model_data_vcs object that contains the model and
%   		the final fit.
%   a_doc: (Optional) A doc_plot object that contains the plot for the fit.
%
% Description:
%   Integrates current response and divides by voltage difference to
% get initial estimate for capacitance using the largest passive
% voltage command step. Membrane charge time constant is series
% resistance times capacitance. I=Cm*dV/dt+(V-EL)*gL. Initial
% estimates are prefixed with "int_" in the results. Then runs several
% least-squares optimization steps to fit output to desired voltage
% step response. Multiple stages of optimization will be run focusing
% at different regions in the current and adjusting select
% parameters. The final fine-tuned estimates are prefixed with "fit_"
% in the results. Run it after 'warning on verbose' to get detailed
% information.
%
% See also: param_Re_Ce_cap_leak_act_int_t, param_vc_Rs_comp_int_t_test
%
% $Id: getResultsPassiveReCeElec.m 896 2007-12-17 18:48:55Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/01/06

% Copyright (c) 2011-2013 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% TODO:
% - rename to w/o L1
% - place under pandora, and then move to pan_vc
% - why does int est look at largest voltage step?
% - return fitted models in doc.props?
% - break down to multiple functions. compcap should be done
% separately since it's just adding back the current. Also need to
% separate ReCe and amp models
% - add a debug prop; verbose warning is too general

  props = defaultValue('props', struct);

  vs = warning('query', 'verbose');
  verbose = getFieldDefault(props, 'debug', strcmp(vs.state, 'on'));
  
min_resnorm = getFieldDefault(props, 'minResnorm', 0.004);
min_Re = getFieldDefault(props, 'minRe', 50);
trace_num = getFieldDefault(props, 'traceNum', 1);
step_num = getFieldDefault(props, 'stepNum', 2);
subname = getFieldDefault(props, 'subname', 'Vm');

nA_scale = pas.data_vc.i.dy / 1e-9;

fig_handle = [];

results = struct;

if nargin == 0 % Called with no params or empty object
  results.Re = NaN;
  results.Cm = NaN;
  results.delay = NaN;
  results = mergeStructs(results, getParamsStruct(param_Re_Ce_cap_leak_act_int_t(nan(7,1))));
  results.resnorm=NaN;
  return;
end

% first find levels < -55 mV
pas_level = getFieldDefault(props, 'passiveV', -55);
pas_vsteps_idx = find(pas.data_vc.v_steps(step_num, :) < pas_level & pas.data_vc.v_steps(step_num + 1, :) < pas_level);
% discretize to 1 mV steps 
quant_steps = ...
    quant(pas.data_vc.v_steps([step_num step_num+1], pas_vsteps_idx)', ...
          1);
% eliminate no-change steps
diff_steps = diff(quant_steps, 1, 2);
yes_change_idx = abs(diff_steps) > 0;
quant_steps = quant_steps(yes_change_idx, :);
pas_vsteps_idx = pas_vsteps_idx(yes_change_idx);

% find distinct values (do not process multiple steps of same values)
[pas_vsteps pas_vsteps_uidx] = ...
    unique(quant_steps, 'rows', 'first');

if verbose
disp(['Found unique Vsteps [mV]: ', ...
      sprintf('%d to %d, ', reshape(pas_vsteps', prod(size(pas_vsteps)), 1))]);
end

[largest_step, largest_step_idx] = ...
    max(abs(diff(pas_vsteps, 1, 2)));
pas_vsteps_idx = pas_vsteps_idx(pas_vsteps_uidx);

assert(length(pas_vsteps_idx) > 0, ...
       'No passive steps were found with given parameters.');

if verbose
disp(['Using largest step [mV]: ', ...
      sprintf('%d to %d', pas_vsteps(largest_step_idx, ...
                                       :))]);
end

pas_res = calcSteadyLeak(pas, struct('stepNum', step_num, ...
                                     'traceNum', pas_vsteps_idx(largest_step_idx)));

if (pas_res.gL) > 0.025
  warning(['gL = ' num2str(pas_res.gL) ' uS is quite large. Expect estimation ' ...
                      'errors for gL and offset parameters.']);
end

delay = ...
    getFieldDefault(props, 'delay', ...
                           calcDelay(pas, struct('traceNum', ...
                                                 pas_vsteps_idx(largest_step_idx))));

if isfield(props, 'compCap')
  pas = addCapTrans(pas, props.compCap, struct('delay', delay));
  
  % remove compCap
  props = rmfield(props, 'compCap');
end

[Re Cm peak_mag] = ...
    calcReCm(pas, mergeStructs(props, ...
                               mergeStructs(struct('traceNum', ...
                                                  pas_vsteps_idx(largest_step_idx), ...
                                                  'delay', delay), pas_res))); 

% TODO: maybe allow small negative delays? Implement in param_Re_Ce_cap_leak_act_int_t
delay = max(0, delay);

if verbose
  pas_res, Re, Cm, delay
end

if Re < min_Re
    warning(['Re=' num2str(Re) ' MOhm too small, setting to minimum ' ...
             num2str(Re) ' MOhm.']);
    Re = max(Re, min_Re); % limit
end

% look at peak capacitive artifact to scale plot axis
if peak_mag < 0
  y_lims = [peak_mag * 1.1,  -0.1 * peak_mag];
else
  y_lims = [-0.1 * peak_mag, peak_mag * 1.1];
end

% TODO: 
% - iterate once more to find a new Re estimate afterwards

% select proper units
unit_cap = getFieldDefault(props, 'unitCap', 'pF');
if ~strcmp(unit_cap, 'nF') && ~strcmp(unit_cap, 'pF')
  error(['Capacitance unit ''' unit_cap ''' in ' ...
         'props.unitCap not recognized.']);
end

unit_res = getFieldDefault(props, 'unitRes', 'MO');
if ~strcmp(unit_res, 'MO') && ~strcmp(unit_res, 'kO')
    error(['Resistance unit ''' unit_res ''' in ' ...
           'props.unitRes not recognized.']);
end

unit_cond = getFieldDefault(props, 'unitCond', 'nS');
if ~strcmp(unit_cond, 'nS') && ~strcmp(unit_cond, 'uS')
  error(['Conductance unit ''' unit_cond ''' in ' ...
         'props.unitCond not recognized.']);
end

% save initial passive parameter estimates in results structure
switch (unit_res)
  case 'MO'
    results.int_Re_MO = Re;
  case 'kO'
    results.int_Re_kO = Re * 1e3;
end

switch (unit_cap)
  case 'pF'
    results.int_Cm_pF = Cm * 1e3;
  case 'nF'
    results.int_Cm_nF = Cm;
end

switch (unit_cond)
  case 'nS'
    results.int_gL_nS = pas_res.gL * 1e3;
  case 'uS'
    results.int_gL_uS = pas_res.gL;
end
results.int_EL_mV = pas_res.EL;
results.int_offset_pA = pas_res.offset * 1e3;
results.est_delay_ms = delay;

% make model for least-squares optimization
if isfield(props, 'model_f')
  capleakReCe_f = props.model_f;
  if ~ isfield(props, 'noEst') 
    % overwrite some parameters from initial estimates
    % TODO: make a new function param_func/setParamsStruct
    par_prefix = subname;
    if ~ isfield(props, 'noReCmEst')
      capleakReCe_f = setParam(capleakReCe_f, [ par_prefix 'Re'], Re);
      capleakReCe_f = setParam(capleakReCe_f, [ par_prefix 'Cm'], Cm);
    end
    capleakReCe_f = ...
        setParam(capleakReCe_f, [ par_prefix 'Ce'], ...
                               getFieldDefault(props, 'initCe', 1.2)*1e-3);
    capleakReCe_f = setParam(capleakReCe_f, [ par_prefix 'gL'], pas_res.gL);
    capleakReCe_f = setParam(capleakReCe_f, [ par_prefix 'EL'], pas_res.EL);
    capleakReCe_f = setParam(capleakReCe_f, [ par_prefix 'delay'], delay);
    capleakReCe_f = setParam(capleakReCe_f, [ par_prefix 'offset'], ...
                                           pas_res.offset);
  end
else
  capleakReCe_f = ...
      param_Re_Ce_cap_leak_act_int_t(...
          struct('Re', Re, 'Ce', getFieldDefault(props, 'initCe', 1.2)*1e-3, ...
                 'gL', pas_res.gL, 'EL', pas_res.EL, 'Cm', Cm, ...
                 'delay', delay, 'offset', pas_res.offset), ...
          ['cap, leak, Re and Ce (int)'], ...
          struct('parfor', 1));
end

% Removed because we're simply adding the compCap into the current above
% $$$ if isfield(props, 'compCap')
% $$$   capleakReCe_f = capleakReCe_f - capleak_f;
% $$$ end

a_md = ...
    model_data_vcs(capleakReCe_f, pas.data_vc, ...
                   [ pas.data_vc.id ': capleak, Re, Ce est']);
plotFigure(plotDataCompare(a_md, ' - analytic estimate', ...
                           struct('levels', pas_vsteps_idx, ...
                                  'zoom', 'act', ...
                                  'axisLimits', ...
                                  [getTimeRelStep(pas.data_vc, ...
                                                  1, -.1) ...
                    * pas.data_vc.dt  * 1e3 + [0 3*Re*Cm], ...
                    y_lims])));


% fit once to make a better Re estimate
narrowToWide();

% if fit not good, then fit more
if results.resnorm > min_resnorm
    warning(['fit failed, resnorm too large: ' num2str(results.resnorm) '. Doing a narrow fit...' ]);
    % fit very narrow range after step
    a_md.model_f.(subname) = setProp(a_md.model_f.(subname), 'selectParams', ...
                                            {'Re', 'Ce', 'Cm', 'delay'});
    runFit([(step_num+1) -.1 3*Re*Cm], '2nd fit (narrow)');
    if results.resnorm > min_resnorm
        error(['narrow fit failed, resnorm too large: ' num2str(results.resnorm) ]);
    else
        % do full fit again
        warning(['narrow fit improved, doing a full fit again.' ]);
        runFit([(step_num+1) -1 10], '3rd fit (full)');
        assert(results.resnorm < min_resnorm, ...
               ['Fit failed. Resnorm (' num2str(results.resnorm) ') > ' num2str(min_resnorm) ...
                ' after narrow and full fits.' ]);
    end
end

% rename all Vm_ columns
renameFields([ subname '_' ], 'fit_');

% add units to names
switch (unit_cap)
  case 'pF'
    renameFields('(fit_C.)', '$1_pF');
    results.fit_Ce_pF = results.fit_Ce_pF * 1e3;
    results.fit_Cm_pF = results.fit_Cm_pF * 1e3;
  case 'nF'
    renameFields('(fit_C.)', '$1_nF');
end

renameFields('(fit_EL)', '$1_mV');

switch (unit_cond)
  case 'nS'
    renameFields('(fit_gL)', '$1_nS');
    results.fit_gL_nS = results.fit_gL_nS * 1e3;
  case 'uS'
    renameFields('(fit_gL)', '$1_uS');
end

switch (unit_res)
  case 'MO'
    renameFields('(fit_Re)', '$1_MO');
  case 'kO'
    renameFields('(fit_Re)', '$1_kO');
    results.fit_Re_kO = results.fit_Re_kO * 1e3;
end
    
renameFields('(fit_delay)', '$1_ms');
renameFields('(fit_offset)', '$1_pA');
results.fit_offset_pA = results.fit_offset_pA * 1e3;

pas_md = a_md;

function narrowToWide()
  1;
  % new try:
  % 0- new estimates for gL, EL, and offset
  % 1- do narrow fit first
  % 2- then relax to larger range and more params

  % start w better gL, EL, & offset
  a_md.model_f.(subname) = ...
      setProp(a_md.model_f.(subname), 'selectParams', ...
                            {'gL', 'EL', 'offset'});
  runFit([(step_num+1) -10 40], 'only fit gL,EL and offset');

  
  % TODO: use new Re and Cm estimates at some point?
  % narrow fit: select parameters
  a_md.model_f.(subname) = setProp(a_md.model_f.(subname), 'selectParams', ...
                                        {'Re', 'Ce', 'Cm', 'delay'});

  runFit([(step_num+1) -.1 3*Re*Cm], 'Starting narrow fit');

  % do another fit with more params relaxed.
  % this also recalculates gL and EL based on the Re estimate.
  if isfield(props, 'compCap') && false
    a_md.model_f.left.(subname) = ...
        setProp(a_md.model_f.left.(subname), 'selectParams', ...
                              {'Re', 'Ce', 'Cm', 'gL', 'EL', 'offset'});
  else
    a_md.model_f.(subname) = ...
        setProp(a_md.model_f.(subname), 'selectParams', ...
                              {'Re', 'Ce', 'Cm', 'gL', 'EL', 'offset'});
  end
  runFit([(step_num+1) -1 40], 'fit w/ relaxed gL,EL and offset');

  % remove El, gL before narrow fit (added 2012/02/29)
  a_md.model_f.(subname) = ...
      setProp(a_md.model_f.(subname), 'selectParams', ...
                            {'Re', 'Ce', 'Cm', 'offset'});
  
  % last do narrower range
  runFit([(step_num+1) -1 10], 'fit 1-10ms');
end

function oneFitsAll()
% old method:
% 1- fit 1-10 ms
% 2- relax and fit to 30 ms
% 3- then same relaxed params, fit 1-10 ms
% 4- if resnorm fails, do another narrow and full fit

  runFit([(step_num+1) -1 10], 'fit 1-10ms');

% do another fit with more params relaxed.
% this also recalculates gL and EL based on the Re estimate.
if isfield(props, 'compCap') && false
  a_md.model_f.left.(subname) = ...
      setProp(a_md.model_f.left.(subname), 'selectParams', ...
                            {'Re', 'Ce', 'Cm', 'gL', 'EL', 'offset'});
else
  a_md.model_f.(subname) = ...
      setProp(a_md.model_f.(subname), 'selectParams', ...
                            {'Re', 'Ce', 'Cm', 'gL', 'EL', 'offset'});
end
runFit([(step_num+1) -1 30], 'fit w/ relaxed gL,EL and offset');

% repeat regular fit
% $$$ a_md.model_f.(subname) = setProp(a_md.model_f.(subname), 'selectParams', ...
% $$$                                         {'Re', 'Ce', 'Cm', 'delay'});

runFit([(step_num+1) -1 10], 'fit 1-10ms');
end

function renameFields(re_from, re_to)
  results = cell2struct(struct2cell(results), ...
                          regexprep(fieldnames(results), ...
                                    re_from, re_to));
  
end

function runFit(fitrange, str)
  disp([ pas.data_vc.id ', fitting range ' ...
         num2str(fitrange) ': ' str ])
  if isempty(fig_handle)
    fig_handle = figure;
  end
  a_md = fit(a_md, ...
             '', struct('fitRangeRel', fitrange, ...
                        'fitLevels', pas_vsteps_idx, ...
                        'dispParams', 5,  ...
                        'dispPlot', 0, ...
                        'optimset', ...
                        struct('Display', 'iter', 'MaxFunEvals', 200)));
  if isfield(props, 'compCap') && false
    results = mergeStructs(getParamsStruct(a_md.model_f.left), results);
  else
    results = mergeStructs(getParamsStruct(a_md.model_f), results);
  end
  % reveal fit results (use normalized SSE)
  results.resnorm = a_md.model_f.props.ssenorm / length(pas_vsteps_idx);
  % ('zoom', 'act')
  % final fit
  fit_plot = ...
      plotDataCompare(a_md, [ ' - ' str ], ...
                      struct('levels', pas_vsteps_idx, ...
                             'axisLimits', ...
                             [getTimeRelStep(pas.data_vc, ...
                                             fitrange(1), -.1) ...
                      * pas.data_vc.dt  * 1e3 + [0 3*Re*Cm], ...
                      y_lims]));
  plotFigure(fit_plot, '', struct('figureHandle', fig_handle));
  a_doc = doc_plot(fit_plot, [ 'Fitting passive parameters of ' pas.data_vc.id ', ' str '.' ], ...
                   [ get(pas.data_vc, 'id') '-passive-fits' ], struct, ...
                   pas.data_vc.id, props);

  disp('press enter to continue')
  pause

end


end

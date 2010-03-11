function params = ...
      scale_cap_leak_Ca_sub_cap_leak(filename, props)

% scale_cap_leak_Ca_sub_cap_leak - Scale capacitance and leak artifacts to subtract them.
%
% Usage:
% params = 
%   scale_cap_leak_Ca_sub_cap_leak(filename, props)
%
% Parameters:
%   filename: Full path to filename.
%   props: A structure with any optional properties.
%     saveData: If 1, save subtracted data into a new text file (default=0).
%		
% Returns:
%   params: Structure with tuned parameters.
%
% Description:
%
% Example:
% >> [time, dt, data_i, data_v, cell_name] = ...
%    scale_cap_leak_Ca_sub_cap_leak('data-dir/cell-A.abf')
% >> plotVclampStack(time, data_i, data_v, cell_name);
%
% See also: param_I_v, param_func
%
% $Id: scale_cap_leak_Ca_sub_cap_leak.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/01/17

% TODO: 
% - process 2nd step and write a 2nd data file for prepulse step
% - get lower/upper limits from param_func
% - prepare a doc_multi from this. Find a way to label figures but print later.
% - also plot IClCa m_infty curve?
% - have option to show no plots, to create database of params

global f_IClCa_minf_v f_IClCa_tau_v m_ClCa f_IClCa_v f_INaP_minf_v

if ~ exist('props', 'var')
  props = struct;
end

% load data from ABF file
[time, dt, data_i, data_v, cell_name] = ...
    loadVclampAbf(filename);
    
  % find step start
  t_step_start = find_change(data_v(:, 1), 1, 3);
  
  % find step ends
  t_step_end = find_change(data_v(:, 1), t_step_start + 20 / dt, 3);

  % calc prepulse steady-state values
  range_prepulse = (t_step_start - 10 / dt) : (t_step_start - 8 / dt);
  v_prepulse = ...
      mean(data_v( range_prepulse, : ));
  i_prepulse = ...
      mean(data_i( range_prepulse, : )); % Do for each current separately

  % calc step steady-state values
  range_steps = (t_step_end - 5 / dt) : (t_step_end - 1 / dt);
  v_steps = ...
      mean(data_v( range_steps, : ), 1);

  i_steps = ...
      mean(data_i( range_steps, : ), 1);
  
  % nicely plot current and voltage trace in separate axes  
  plotFigure(...
    plot_stack({...
      plot_abstract({time, data_i}, {'time [ms]', 'I [nA]'}, ...
                    'all currents', {}, 'plot', struct), ...
      plot_abstract({time, data_v}, {'time [ms]', 'V_m [mV]'}, ...
                    'all currents', {}, 'plot', struct)}, ...
               [t_step_start * dt - 10, t_step_end * dt + 10 NaN NaN], ...
               'y', [ cell_name ': Raw data' ], ...
               struct('titlesPos', 'none', 'xLabelsPos', 'bottom', ...
                      'fixedSize', [4 3], 'noTitle', 1)));

  % func of sum of NaP and ClCa

  f_capleak = ...
      param_cap_leak_int_t(struct('Ri', 100, 'gL', 3, ...
                                  'EL', -80, 'Cm', 1e-2), ...
                         ['Ca chan 3rd instar cap leak']);

  use_levels = 1:5;
  num_rows = size(data_v, 1) * length(use_levels);
  f_capleak = ...
      optimize(f_capleak, ...
               {reshape(data_v(:, use_levels), num_rows, 1), dt}, ...
               reshape(data_i(:, use_levels), num_rows, 1));

  if 1 == 0
  % let tune only some parameters first
  % Neuron multiple run fitter tutorial suggests to: 
  % "first optimize Rm only and then optimize Ri and Cm only."
  % (http://hines.med.yale.edu/neuron/static/docs/optimiz/model/optimize.html)
  %f_capleak = setProp(f_capleak, 'selectParams', {'V_half', 'k'}); 
                                                                
  error_func_lsq = ...
      @(p, x)f(setParams(f_capleak, p, struct('onlySelect', 1)), x);
  
  par = getParams(f_capleak, struct('onlySelect', 1)); % initial params
                                                      
  %[par, fval, exitflag, output] = ...
  %    fminsearch(error_func, par', optimset('MaxIter', 1000))
  [par, resnorm, residual, exitflag, output] = ...
      lsqcurvefit(error_func_lsq, par', {data_v(:, 2), dt}, data_i(:, 2), ...
                  [], [], ...
                  optimset('MaxIter', 1000, 'Display', 'notify', ...
                           'MaxFunEvals', 1000));

  % set back fitted parameters
  f_capleak = setParams(f_capleak, par, struct('onlySelect', 1));
  end
  
  % then, extract all parameters
  params = getParamsStruct(f_capleak)

  v_legend = ...
      cellfun(@(x)([ sprintf('%.0f', x) ' mV']), num2cell(v_steps'), ...
              'UniformOutput', false);

  % choose the range
  range_steps = (t_step_start - 1 / dt) : (t_step_end + 5 / dt);

  % simulate the membrane currents for each voltage step
  v_delay = 0; % ms
  for step_v = 1:length(v_steps)
    Im(1:length(range_steps), step_v) = ...
        f(f_capleak, { data_v(range_steps - v_delay/dt, step_v ), dt});
  end

  % subtract the cap+leak part
  data_sub_capleak = data_i;
  data_sub_capleak(range_steps, :) = data_sub_capleak(range_steps, :) - Im;
  
  % superpose over data
  line_colors = lines(length(v_steps)); %hsv(length(v_steps));
  plotFigure(...
    plot_stack({...
      plot_superpose({...
        plot_abstract({time, data_i}, {'time [ms]', 'I [nA]'}, ...
                      'data', v_legend, 'plot', ...
                      struct('ColorOrder', line_colors)), ...
        plot_abstract({time(range_steps), Im}, ...
                      {'time [ms]', 'I [nA]'}, ...
                      'est. I_{cap+leak}', {}, 'plot', ...
                      struct('plotProps', struct('LineWidth', 2), ...
                             'ColorOrder', line_colors))}, ...
                     {}, '', struct('axisProps', ...
                                    struct())), ...
      plot_abstract({time, data_sub_capleak}, ...
                    {'time [ms]', 'I [nA]'}, ...
                    'data - I_{cap+leak}', {}, 'plot', ...
                    struct('ColorOrder', line_colors, ...
                           'plotProps', struct('LineWidth', 1)))}, ...
               [t_step_start * dt - 10, t_step_end * dt + 10 NaN NaN], ...
               'y', [ cell_name ': Sim + sub data' ], ...
               struct('titlesPos', 'none', 'xLabelsPos', 'bottom', ...
                      'fixedSize', [4 3], 'noTitle', 1)));

if isfield(props, 'saveData')
  %%
  % write to text file for NeuroFit
  dlmwrite([ cell_name ' sub IClCa.txt' ], [time, data_sub_capleak], ' ' );
end

function t_change = find_change(data, idx_start, num_mV)
% find starting baseline
  first_ms = 2;
  t_begin = first_ms/dt;
  v_start = mean(data(idx_start:(idx_start + t_begin)));
  %v_start_sd = std(data(idx_start:(idx_start + t_begin)));
  
  % find beginning of step
  t_change = find(abs(data(idx_start:end) - v_start) > num_mV); %5*v_start_sd
  t_change = idx_start - 1 + t_change(1);
end

end

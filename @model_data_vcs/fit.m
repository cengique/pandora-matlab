function a_md = fit(a_md, title_str, props)

% fit - Fit model to data.
%
% Usage:
% a_md = fit(a_md, title_str, props)
%
% Parameters:
%   a_md: A model_data_vcs object.
%   props: A structure with any optional properties.
%     fitRange: Start and end times [ms] of simulated range used for
%     		optimization. Note that simulated range must include prior
%     		stimulation steps to set state of diff. eqs.
%     fitRangeRel: Like fitRange, but relative to first voltage step
%     		[ms]. Specify any other voltage step as the first element.
%     outRangeRel: Only use this range of the simulated data for
%     		fitting. Defined same as fitRangeRel. Multiple rows can contain
%     		separate ranges are patched together.
%     fitLevels: Indices of voltage/current levels to use from clamp
%     		data. If empty, not fit is done.
%     dispParams: If non-zero, display params every once this many iterations.
%     dispPlot: If non-zero, update a plot of the fit at end of this many
%     	        iterations. A zero means no plot will be produced at the end.
%     saveModelFile: If given, save the model every dispParams iteration.
%     saveModelAutoNum: Use this as a base number and use saveModelFile as sprintf formatted
%     		string that includes a number string (e.g., '%d') and increment it
%     		until a non-existing file name is found.
%     savePlotFile: If given, save the plot to this file every dispPlot iteration.
%     plotMd: model_data_vcs or subclass object to be used for plots.
%     quiet: If 1, do not include cell name on title.
% 
% Returns:
%   a_md: Updated model_data_vcs object with fit.
%
% Description:
%
% Example:
% >> a_md = ...
%    fit(a_md, '', ...
%      struct('fitRangeRel', [-.2 165], 'fitLevels', 1:5, ...
%             'dispParams', 5, ...
%             'optimset', struct('Display', 'iter')));
%
% See also: param_I_v, param_func
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/12

% TODO: 
% - remove title_str parameter
% - process 2nd step and write a 2nd data file for prepulse step
% - prepare a doc_multi from this. Find a way to label figures but print later.
% - also plot IClCa m_infty curve?
% - have option to show no plots, to create database of params
% - extract fitting to a separate function that returns the optimized _f

props = defaultValue('props', struct);
title_str = defaultValue('title_str', '');

data_vc = a_md.data_vc;
dt = get(data_vc, 'dt') * 1e3;             % convert to ms
cell_name = get(a_md, 'id');

time = (0:(size(a_md.data_vc.v.data, 1) - 1)) * dt;

% select the initial part before v-dep currents get activated
range_rel = getFieldDefault(props, 'fitRangeRel', []); % [ms]

if ~ isempty(range_rel)
  if length(range_rel) > 2
    step_num = range_rel(1);
    range_rel = range_rel(2:end);
  else
    step_num = 1;
  end
  % if relative, calc from step times
  range_maxima = ...
      period(getTimeRelStep(data_vc, step_num, range_rel));
else
  % take the whole range
  range_maxima = periodWhole(data_vc);
end

% overwrite if...
if isfield(props, 'fitRange')
  range_maxima = period(round(props.fitRange / dt));
end

range_cap_resp = round(range_maxima.start_time):round(range_maxima.end_time);

% TODO: temporary fix!
if isfield(props, 'outRangeRel')
  % adjust relative to simulated part
  for range_num = 1:size(props.outRangeRel, 1)
    props.fitOutRange(range_num, :) = ...
        getTimeRelStep(data_vc, props.outRangeRel(range_num, 1), props.outRangeRel(range_num, 2:3)) ...
        - range_maxima.start_time;
  end
  plot_zoom = [min(props.fitOutRange(:, 1), [], 1) ...
               max(props.fitOutRange(:, 2), [], 1)] * dt;
else
  plot_zoom = [range_maxima.start_time range_maxima.end_time] * dt;
end

if isfield(props, 'saveModelFile')
  if ~ isfield(props, 'saveModelAutoNum')
    save_model_file = props.saveModelFile;
    num_iter_label = '';
  else
    num_iter = props.saveModelAutoNum;
    % skip existing files
    while exist(sprintf(props.saveModelFile, num_iter), 'file')
      num_iter = num_iter + 1;
    end
    save_model_file = sprintf(props.saveModelFile, num_iter);
    disp(['Found non-existing file name ''' ...
          save_model_file, ...
          ''' for saving model.']);
    num_iter_label = [ ' #' num2str(num_iter) ' ' ];
  end
end

% use all voltage levels by default
use_levels = getFieldDefault(props, 'fitLevels', 1:size(data_vc.v.data, 2));

% func
f_model = a_md.model_f;

out_fcns = {};
if isfield(props, 'dispParams')
  out_fcns = [ out_fcns, { @disp_out } ];
end

if isfield(props, 'dispPlot') && props.dispPlot > 0
  out_fcns = [ out_fcns, { @plot_out } ];
end

props = ...
    mergeStructsRecursive(...
      props, ...
      struct('optimset', optimset('OutputFcn', out_fcns)));

% need to run optimset at least once to get all the fields
props = ...
    mergeStructsRecursive(props, struct('optimset', optimset));      

if ~ isfield(props, 'plotMd')
  props.plotMd = a_md;
end

  function stop = disp_out(x, optimValues, state)
    if mod(optimValues.iteration, props.dispParams) == 0 && ...
          strcmp(state, 'iter')
      f_model = setParams(f_model, x, struct('onlySelect', 1));
      dispParams(f_model);
    end
    stop = false;
  end
  
  function dispParams(a_model, a_props)
    a_props = defaultValue('a_props', struct);
    disp(displayParams(a_model, ...
                       mergeStructs(a_props, struct('lastParamsF', f_model_orig, ...
                                                   'onlySelect', 1))));
    if isfield(props, 'saveModelFile')
      save(save_model_file, 'a_model');
    end
  end

  function stop = plot_out(p, optimValues, state)
  % TODO: make this refresh by a parallel
  % worker so can be seen during fitting process
    if mod(optimValues.iteration, props.dispPlot) == 0  && ...
          strcmp(state, 'iter')
      dispPlot(setParams(f_model_orig, p, struct('onlySelect', 1)));
    end
    stop = false;
  end

  fig_props = struct;
  
  function dispPlot(a_model)
  % is plotting disabled?
    if isfield(props, 'dispPlot') && props.dispPlot == 0
      return;
    end
    
    extra_text = ...
    [ '; fit range [' ...
      sprintf('%.2f ', plot_zoom) ']' ...
      '; levels: [' sprintf('%d ', use_levels) '], ' ...
      getParamsString(a_model) ];

    if isfield(props, 'quiet')
      all_title = properTeXLabel(title_str);
    else
      all_title = ...
          properTeXLabel([ cell_name num_iter_label extra_text title_str ]);
    end

    % TODO: fix problem of compatibility with model_data_vcs_Kprepulse
    % this should all be in a_md/plot_abstract
      fig_handle = ...
          plotFigure(plot_abstract(updateModel(props.plotMd, a_model), ...
                                   all_title, ...
                                   struct(... %'levels', use_levels, ...
                                          'axisLimits', ...
                                          [plot_zoom NaN NaN])), ...
                     '', fig_props);

% $$$       fig_handle = ...
% $$$           plotFigure(...
% $$$             plotDataCompare(b_md, all_title, ...
% $$$                             struct('levels', use_levels, ...
% $$$                                    'show', 'sub', ...
% $$$                                    'axisLimits', ...
% $$$                                    [range_maxima.start_time ...
% $$$                           * dt, range_maxima.end_time * dt NaN NaN], ...
% $$$                                    'fixedSize', [4 3], 'noTitle', 1)), '', ...
% $$$             fig_props);

      fig_props = mergeStructs(struct('figureHandle', fig_handle), ...
                               fig_props);
      if isfield(props, 'savePlotFile')
        print(fig_handle, '-depsc2', props.savePlotFile);
      end
  end

  params = getParamsStruct(f_model);

if ~ isempty(use_levels)
  disp('Fitting...');

  % save before optimization
  f_model_orig = f_model;
  
  % optimize
  f_model = ...
      optimize(f_model, ...
               struct('v', data_vc.v.data(range_cap_resp, use_levels), 'dt', dt), ...
               data_vc.i.data(range_cap_resp, use_levels), ...
               props);

  % show all parameters (only the ones optimized)
  dispParams(f_model, struct('relConfInt', f_model.props.relConfInt));

  % simulate new model here
  a_md = updateModel(a_md, f_model);

  % nicely plot current and voltage trace in separate axes only for
  % part fitted
  dispPlot(f_model);

end

end
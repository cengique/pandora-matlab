function [avg_vc sd_vc tex_file] = averageTracesSave(traceset, prot_name, props)

% averageTracesSave - Average all traces in traceset and save as voltage_clamp MAT file.
%
% Usage:
% [avg_vc sd_vc] = averageTracesSave(traceset, prot_name, props)
%
% Parameters:
%   traceset: A traceset object.
%   prot_name: Name of protocol to choose from traceset treatments. Also
%   	added to saved file name.
%   props: Structure with optional parameters.
%
% Returns:
%   avg_vc: Average VC object
%   sd_vc: Standard VC object
%
% Description:
%   Also generates statistics and saves a lot of files. Will create a
% LaTeX document in the proper directory.
%
% See also: traceset_L1_passive, data_L1_passive
%
% $Id: averageTracesSave.m 896 2007-12-17 18:48:55Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/02/04

% Copyright (c) 2011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% TODO: make it intelligent to check the voltage steps!

props = mergeStructs(defaultValue('props', struct), get(traceset, 'props'));

traceset_id = get(traceset, 'id');

% doc file names
plot_name = ['compare-orig-average-' properTeXFilename(prot_name)];
tex_file = ...
    [ properTeXFilename([ traceset_id '-' plot_name])  '.tex'];

% do it only if average files don't exist
avg_file = [ props.docDir filesep properTeXFilename(traceset_id) filesep ...
             'Average-' properTeXFilename(prot_name) '.mat' ];
sd_file = [ props.docDir filesep properTeXFilename(traceset_id) filesep ...
            'AverageSD-' properTeXFilename(prot_name) '.mat' ];

if ~exist(avg_file, 'file') || ~exist(sd_file, 'file')
  tracelist = traceset.treatments.(prot_name);

  num_traces = length(tracelist);
  traces = repmat(trace, 1, num_traces);

  % take first as template voltage protocol
  avg_vc = getItemVC(traceset, tracelist(1), ...
                               struct('absolute', 1));

  % then average only current traces
  traces(1) = get(avg_vc, 'i');
  for trace_index = 2:num_traces
    traces(trace_index) = get(getItemVC(traceset, tracelist(trace_index), ...
                                                  struct('absolute', 1)), 'i');
  end

  [avg_tr sd_tr] = avgTraces(traces, struct('id', [traceset_id '-' prot_name]));

  avg_vc = set(avg_vc, 'i', avg_tr);
  avg_vc = set(avg_vc, 'id', [traceset_id ' - Average' prot_name ]);
  sd_vc = set(avg_vc, 'i', sd_tr);
  sd_vc = set(sd_vc, 'id', [traceset_id ' - SD' prot_name ]);

  % make a doc with original traces and the average
  % TODO: take advantage of SD
  % TODO: plot using voltage_clamp methods
  plot_title = ...
      [ 'Original and averaged ' properTeXLabel(prot_name) ' protocol traces of ' ...
        properTeXLabel(traceset_id) ];
  a_doc = doc_plot(plot_superpose({...
    superposePlots(plot_abstract(traces, [ ' - ' plot_title], ...
                                 mergeStructs(props, struct('noTitle', 1, ...
                                                    'ColorOrder', [0.7 0.7 0.7], ...
                                                    'fixedSize', [6 4])))), ...
    plot_abstract(avg_tr, '', struct('ColorOrder', [0 0 0], ...
                                     'plotProps', struct('LineWidth', 2)))}, {}, '', ...
                                  struct('noCombine', 1)), ...
                   plot_title, ...
                   [ plot_name ], struct('width', '.7\columnwidth'), ...
                   properTeXLabel([ plot_name '-' traceset_id ]), ...
                   mergeStructs(props, ...
                                struct('plotRelDir', ...
                                       [properTeXFilename(get(traceset, 'id')) '/' ])));

  % this can be done during averaging or after
  % TODO: put a TeX label
  string2File([ '\clearpage\cellsection{' properTeXLabel(traceset_id) '}' sprintf('\n') ...
                getTeXString(a_doc) ], ...
            [ props.docDir filesep tex_file ]);
  
  avg_vc = setProp(avg_vc, 'doc', a_doc);
  
  save(avg_file, 'avg_vc');
  save(sd_file, 'sd_vc');
else
  disp(['Found existing averages in ''' avg_file ''' and ''' sd_file '''. Loading...']);

  load(avg_file);
  load(sd_file);
end


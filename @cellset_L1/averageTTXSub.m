function [tex_file] = averageTTXSub(cellset, props)

% averageTTXSub - Subtract averaged TTX from control traces and save as voltage_clamp MAT files.
%
% Usage:
% [tex_file] = averageTTXSub(cellset, props)
%
% Parameters:
%   cellset: A cellset object.
%   props: Structure with optional parameters.
%     protNames: Cell array of protocol(s) to average.
%     recalc: If 1, recalculate even if saved file is found.
%
% Returns:
%   tex_file: Name of TeX file generated.
%
% Description:
%   Also generates statistics and saves a lot of files. Will create a
% LaTeX document in the proper directory.
%
% See also: cellset_L1, traceset_L1_passive/averageTracesSave, data_L1_passive
%
% $Id: averageTTXSub.m 896 2007-12-17 18:48:55Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/05/17

% Copyright (c) 2011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

props = mergeStructs(defaultValue('props', struct), get(cellset, 'props'));
doc_dir = getFieldDefault(props, 'docDir', '');

cellset_id = get(cellset, 'id');

% for each protocol set for subtracting:
prot_names = ...
    getFieldDefault(props, 'protNames', cellset.treatments.averageTTXSub);

prot_tex_file = ...
      [ properTeXFilename([cellset_id '-TTXsub-all-protocols' ]) '.tex' ];

prot_tex_str = '';
for prot_name = prot_names
  prot_name = prot_name{1};

  plot_name = ['ttx-sub-' properTeXFilename(prot_name)];
  tex_file = ...
      [ properTeXFilename([cellset_id '-' plot_name]) '.tex' ];

  prot_zoom = ...
      getFieldDefault(getFieldDefault(props, 'protZoom', struct), ...
                      prot_name, repmat(NaN, 1, 4));

  % names
  sub_file = [ props.docDir filesep properTeXFilename(cellset_id) ' - TTXsub-' properTeXFilename(prot_name) ...
               '.mat' ];

  % Do only if files don't exist
  if ~exist(sub_file, 'file') || isfield(props, 'recalc')
    celllist = get(cellset, 'list');
    
    num_cells = length(celllist);
    norm_traces = repmat(trace, 1, num_cells);
    cell_tex_str = '';
    
    % there should be only 2 tracesets, one with TTX and one without
    assert(num_cells == 2, ['Cellset should only have TTX and control ' ...
                        'tracesets from same cell.']);
    for cell_index = 1:num_cells
      traceset = getItemTraceset(cellset, cell_index);
      traceset_props = get(traceset, 'props');
      if isfield(traceset_props, 'treatments')
        treat_str = [ '_' struct2str(traceset_props.treatments) ];
      else
        treat_str = '';
      end

      traceset_id = [ get(traceset, 'id') treat_str ];
      
      % call averageTracesSave
      % pass zoom param as axisLimits
      [avg_vc sd_vc ts_tex_file] = ...
          averageTracesSave(traceset, prot_name, ...
                            mergeStructs(props, ...
                                         struct('axisLimits', ...
                                                prot_zoom)));      

      if traceset_props.treatments.TTX == 0
        control_vc = avg_vc;
      else
        ttx_vc = avg_vc;
      end
      
      cell_tex_str = ...
          [ cell_tex_str '\input{' ts_tex_file '}' sprintf('\n') ];
    end % cell_index
    
    % subtract TTX from control
    sub_vc = control_vc;
    sub_vc = set(sub_vc, 'i', control_vc.i - ttx_vc.i);
    sub_vc = set(sub_vc, 'id', [cellset_id ' - TTXsub - ' prot_name ]);
    
    % make plot
    plot_title = ...
        [ 'TTX subtracted ' properTeXLabel(prot_name) ' protocols of ' ...
          properTeXLabel(cellset_id) '.' ];
    a_doc = doc_plot(...
      plot_abstract(sub_vc.i, '', ...
                    mergeStructs(props, ...
                                 struct('noTitle', 1, 'axisLimits', prot_zoom, 'ColorOrder', [0 0 0], ...
                                        'plotProps', struct('LineWidth', 2)))), ...
                     plot_title, ...
                     properTeXLabel([ cellset_id '-' plot_name ]), struct('width', '.7\columnwidth'), ...
                     properTeXLabel([ plot_name '-' cellset_id ]), ...
                     mergeStructs(props, struct('fixedSize', [6 4])));
    
    % this can be done during averaging or after
    % put protocols in tex file, too
    string2File([ '\clearpage\protsection{TTX Subtracting ' properTeXLabel(prot_name) '}' sprintf('\n') ...
                  cell_tex_str ...
                  '\clearpage\cellsection{Subtraction of ' properTeXLabel(prot_name) ...
                  '}' sprintf('\n') ...
                  getTeXString(a_doc) ], ...
                [ props.docDir filesep tex_file ]);
    
    sub_vc = setProp(sub_vc, 'doc', a_doc);
    
    % save data
    save(sub_file, 'sub_vc');
  else
    load(sub_file);
  end % if file exists
  prot_tex_str = [prot_tex_str '\input{' tex_file '}' sprintf('\n') ];
end % prot_name

string2File([ prot_tex_str ], ...
            [ props.docDir filesep prot_tex_file ]);

tex_file = prot_tex_file;
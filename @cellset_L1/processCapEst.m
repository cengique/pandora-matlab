function [a_db, a_stats_db, Cm_avg_db] = processCapEst(cellset, props)

% processCapEst - Collects capacitance estimate DBs of the cells.
%
% Usage:
% [a_db, a_stats_db, Cm_avg_db] = processCapEst(cellset)
%
% Parameters:
%   cellset: A cellset object.
%   props: Structure with optional parameters.
%
% Returns:
%
% Description:
%   Also generates statistics and saves a lot of files. Will create a
% LaTeX document in the proper directory.
%
% See also: cellset_L1, traceset_L1_passive, data_L1_passive
%
% $Id: processCapEst.m 896 2007-12-17 18:48:55Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/02/04

% Copyright (c) 2011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

props = mergeStructs(defaultValue('props', struct), get(cellset, 'props'));

cellset_id = get(cellset, 'id');
doc_dir = getFieldDefault(props, 'docDir', '');

stats_db_name = [ doc_dir filesep properTeXFilename(cellset_id) ' - passive stats DB.mat' ];
Cm_db_name = [ doc_dir filesep properTeXFilename(cellset_id) ' - Cm DB.mat' ];
tex_pre_name = [ properTeXFilename(cellset_id) '-passive-fits-cells.tex' ];

if ~exist(stats_db_name, 'file') || ~exist(Cm_db_name, 'file')
  celllist = get(cellset, 'list');

  num_cells = length(celllist);
  stats_dbs = cell(1, num_cells);
  Cm_vals = repmat(NaN, num_cells, 2);
  tex_string = '';
  
  for cell_index = 1:num_cells
    % TODO: add the cell number based on the unique identifier list in
    % cellset_L1
    traceset = getItemTraceset(cellset, cell_index);
    [a_db, a_stats_db, Cm_avg, tex_file] = ...
        processCapEst(traceset, props);
    Cm_vals(cell_index, :) = [cell_index, Cm_avg];
    % TODO: may need to change this to addColumns
    stats_dbs{cell_index} = ...
        addColumns(a_stats_db, {'Cell_Id'}, ...
                   repmat(cell_index, dbsize(a_stats_db, 1), 1));
    tex_string = ...
        [ tex_string sprintf('\n') ...
          '\clearpage\cellsection{' properTeXLabel(get(traceset, 'id')) '}' sprintf('\n') ...
          '\input{' tex_file '}' sprintf('\n') ...
          ''];
    
    string2File([ tex_string sprintf('\n') ], ...
            [ doc_dir filesep tex_pre_name ]);
  end
  a_stats_db = compareStats(stats_dbs{:});
  Cm_avg_db = params_tests_db(Cm_vals(:, 1), {'Cell_Id'}, Cm_vals(:, 1), {'Cm_avg_pF'}, ...
                              [ 'Cap estimate stats from ' cellset_id ]);
  % save them
  save(stats_db_name, 'a_stats_db');
  save(Cm_db_name, 'Cm_avg_db');
else
  load(stats_db_name);
  load(Cm_db_name);
  a_db = tests_db;                      % nothing for now
end

% make a new stats plot
for_stats_db = delColumns(a_stats_db, {'TraceNum', '/offset/', 'resnorm', 'ItemIndex'});

stats_name = 'passive_params_stats';
stats_plot = doc_plot(plot_bars(for_stats_db, [ 'Compare passive param stats of ' cellset_id ], ...
                                struct('pageVariable', 'Cell_Id', ...
                                       'quiet', 1, ...
                                       'fixedSize', [12 3], 'noTitle', ...
                                       1, 'Color', gray(1))), ...
                      [ 'Mean and standard error (SE) of passive parameters from ' cellset_id ], ...
                      [ stats_name ], struct('width', '\columnwidth'), ...
                      properTeXLabel([ stats_name '-' cellset_id ]), ...
                      mergeStructs(props, struct));

% TODO: also put \include statements to individual TeX files. Put
% section, clearpage, etc. Then summary section with the bar graph and
% table and maybe some text.
string2File([ '\input{' tex_pre_name '}' sprintf('\n') ...
              '\clearpage\cellsection{Summary for ' properTeXLabel(cellset_id) ...
              '}' sprintf('\n') ...
              displayRowsTeX([ ...
                for_stats_db({'mean', 'STD', 'n'}, ':', 1); ...
                for_stats_db({'mean', 'STD', 'n'}, ':', 2)], ...
                             ['Measured passive ' ...
                    'properties and statistics of ' properTeXLabel(cellset_id) '.'], ...
                             struct('rotate', 0, 'width', '\columnwidth', ...
                                    'height', '!')), ...
              getTeXString(stats_plot)  ], ...
            [ doc_dir filesep properTeXFilename(cellset_id) '-passive-fits.tex' ]);

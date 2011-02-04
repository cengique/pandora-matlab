function [a_db, Cm_avg] = processCapEst(traceset, props)

% processCapEst - Generates a DB of the cell's trace set by estimating their capacitances.
%
% Usage:
% processCapEst(traceset)
%
% Parameters:
%   traceset: A traceset object.
%   props: Structure with optional parameters.
%
% Returns:
%
% Description:
%   Also generates statistics and saves a lot of files.
%
% See also: traceset_L1_passive, data_L1_passive
%
% $Id: processCapEst.m 896 2007-12-17 18:48:55Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/02/04

% Copyright (c) 2011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

props = mergeStructs(defaultValue('props', struct), get(traceset, 'props'));

traceset_id = get(traceset, 'id');

% Save the db and load it later instead of processing
db_file = [ props.docDir filesep traceset_id filesep 'passive_params_db.mat' ];
if ~exist(db_file, 'file')
  % generate the DB and docs
  a_db = params_tests_db(traceset);
  % TODO: remove some columns?
  save(db_file, 'a_db');
  % TODO: also save a csv file of DB
else
  disp(['Found existing DB in ''' db_file '''. Loading...']);
  load(db_file);
end

% TODO: 

a_stats_db = statsAll(a_db);

% mean capacitance:
Cm_avg = a_stats_db('mean', 'fit_Cm_pF').data;

% TODO: save the final Cm value?

displayRows([a_db; a_stats_db])

for_stats_db = delColumns(a_db, {'TraceNum', '/offset/', 'resnorm', 'ItemIndex'});

% TODO: maybe collect many cells and plot them all together
% - put traceset id as file name
stats_name = 'passive_params_stats';
stats_plot = doc_plot(plot_bars(statsMeanSE(for_stats_db), '', ...
                                  struct('fixedSize', [12 3], 'noTitle', ...
                                         1, 'Color', gray(1))), ...
                      [ 'Statistics of passive params of ' properTeXLabel(traceset_id) ], ...
                      [ stats_name ], struct('width', '\columnwidth'), ...
                      properTeXLabel([ stats_name '-' traceset_id ]), ...
                      mergeStructs(props, ...
                                   struct('plotRelDir', ...
                                          [properTeXFilename(get(traceset, 'id')) '/' ])));

string2File([getTeXString(a_db.props.doc) ...
             displayRowsTeX([a_db; a_stats_db], ['Calculated passive ' ...
                    'properties and their statistics.'], ...
                            struct('rotate', 0, 'width', '\columnwidth', ...
                                   'height', '!')) ...
             getTeXString(stats_plot)], ...
            [ props.docDir filesep traceset_id '-passive-fits.tex' ]);

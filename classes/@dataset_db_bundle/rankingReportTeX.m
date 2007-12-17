function tex_string = rankingReportTeX(a_bundle, crit_bundle, crit_db, props)

% rankingReportTeX - Generates a report by comparing a_bundle with the given match criteria, crit_db from crit_bundle.
%
% Usage:
% tex_string = rankingReportTeX(a_bundle, crit_bundle, crit_db, props)
%
% Description:
%   Generates a LaTeX document with:
%	- (optional) Raw traces compared with some best matches at different distances
%	- Values of some top matching a_db rows and match errors in a floating table.
%	- colored-plot of measure errors for some top matches.
%	- Parameter distributions of 50 best matches as a bar graph.
%
%   Parameters:
%	a_bundle: A dataset_db_bundle object that contains the DB to compare rows from.
%	crit_bundle: A dataset_db_bundle object that contains the criterion dataset.
%	crit_db: A tests_db object holding the match criterion tests and STDs
%		 which can be created with matchingRow.
%	props: A structure with any optional properties.
%		caption: Identification of the criterion db (not needed/used?).
%		num_matches: Number of best matches to display (default=10).
%		rotate: Rotation angle for best matches table (default=90).
%
%   Returns:
%	tex_string: LaTeX document string.
%
% See also: displayRowsTeX
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/12/13

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props')
  props = struct([]);
end

tex_string = '';

a_ranked_db = rankMatching(a_bundle.joined_db, crit_db);
joined_db = joinOriginal(a_ranked_db);
ranked_num_rows = dbsize(a_ranked_db, 1);

% LaTeX likes '_' to be '\_' 
a_db_id = strrep(lower(get(a_bundle.joined_db, 'id')), '_', '\_');
crit_db_id = strrep(lower(get(crit_db, 'id')), '_', '\_');

if ranked_num_rows > 0

  % Display raw data traces from dataset

  % prepare a landscape figure with two rows
  % one row for original and 5 matching data traces
  % second row for original and 5 matching spike shapes
  % TODO: This should be in a *_profile class
  crit_trace_d100 = ctFromRows(crit_bundle, crit_db, 100);
  crit_trace_h100 = ctFromRows(crit_bundle, crit_db, -100);

  if isempty(crit_trace_h100) || isempty(crit_trace_d100)
    error(['Cannot find one of 100 or -100 pA cip traces in ' get(crit_bundle, 'id') '.']);
  end

  crit_trace_id = strrep(get(crit_trace_d100(1), 'id'), '_', '\_');

  num_plots = 5;
  trace_d100_plots = cell(1, num_plots);
  trace_h100_plots = cell(1, num_plots);

  for plot_num=1:num_plots
    rank_num = (plot_num - 1) * 10 + 1;
    trial_num = get(onlyRowsTests(joined_db, rank_num , 'trial'), 'data');
    if plot_num > 1
      sup_props = struct('noLegends', 1);
      crit_traces = 1;
    else
      sup_props = struct;
      crit_traces = ':';
    end
    trace_d100_plots{plot_num} = ...
	superposePlots([plotData(crit_trace_d100(crit_traces)), ...
			plotData(ctFromRows(a_bundle, trial_num, 100))], {}, ...
		       ['Rank ' num2str(rank_num) ', t' num2str(trial_num)], ...
		       'plot', sup_props);
    trace_h100_plots{plot_num} = ...
	superposePlots([plotData(crit_trace_h100(crit_traces)), ...
			plotData(ctFromRows(a_bundle, trial_num, -100))], {}, '', ...
		       'plot', sup_props);
  end
  
  % Make a full figure with the best matching guy
  plotFigure(plot_stack([trace_d100_plots{1}, trace_h100_plots{1}], ...
			[0 3000 -150 80], 'y', ...
			['The best match to ' crit_trace_id ], ...
			struct('xLabelsPos', 'bottom', 'titlesPos', 'none')));
  best_filename = properTeXFilename([crit_db_id  ' - best matching model from ' a_db_id ]);
  orient tall; print('-depsc2', [ best_filename '.eps' ] );

  horiz_props = struct('titlesPos', 'all', 'yLabelsPos', 'left', 'xLabelsPos', 'none');
  d100_row_plot = plot_stack([trace_d100_plots{2:num_plots}], [0 3000 -80 80], 'x', '', ... %+100 pA CIP
			      mergeStructs(struct('xLabelsPos', 'none'), horiz_props));
  h100_row_plot = plot_stack([trace_h100_plots{2:num_plots}], [0 3000 -150 80], 'x', '-100 pA CIP', ...
			     mergeStructs(struct('titlesPos', 'none'), horiz_props));
  
  plotFigure(plot_stack({d100_row_plot, h100_row_plot}, [], 'y', ...
			['Best matches to ' crit_trace_id ], ...
			struct('titlesPos', 'none')));

  filename = properTeXFilename([ crit_db_id ' - top matching models from ' a_db_id ]);
  print('-depsc2', [ filename '.eps' ] );

  % Put the best match in a figure float
  short_caption = [ 'Best matching model to ' crit_db_id ...
		     ' (' crit_trace_id ').' ];
  caption = [ short_caption ...
	     ' All available raw traces from the criterion cell are shown.' ];
  tex_string = [ tex_string ...
		TeXtable([ '\includegraphics{' best_filename '}' ], ...
			 caption, struct('floatType', 'figure', ...
					 'center', 1, ...
					 'height', '.9\textheight', ...
					 'shortCaption', short_caption)) ];

  % Put other matches in a figure float
  % TODO: indicate distances of best and furthest matches
  short_caption = [ 'Raw traces of the ranked to the ' crit_db_id  ...
		   ' (' crit_trace_id ').' ];
  caption = [ short_caption ...
	     ' Traces are taken from 5 equidistant matches from the best' ...
	     ' 50 ranks from ' a_db_id '.' ...
	     '  Criterion cell trace is superposed with each model trace.'];
  tex_string = [ tex_string ...
		TeXtable([ '\includegraphics{' filename '}' ], ...
			 caption, struct('floatType', 'figure', ...
					 'center', 1, ...
					 'rotate', 90, ...
					 'height', '.9\textheight', ...
					 'shortCaption', short_caption)) ...
		'\clearpage%' sprintf('\n') ];

  % Display values of 10 best matches
  if isfield(props, 'num_matches')
    num_best = props.num_matches;
  else
    num_best = 13;
  end
  top_ranks = onlyRowsTests(a_ranked_db, 1:min(num_best, ranked_num_rows), ':', ':');
  short_caption = [ a_db_id ' ranked to the ' crit_db_id '.' ];
  caption = [ short_caption ...
	     ' Only ' num2str(num_best) ' best matches are shown.' ];
  tex_string = [ tex_string displayRowsTeX(top_ranks, caption, ...
					   struct('shortCaption', short_caption, ...
						  'rotate', 0)) ];

  % Display colored-plot of top 50 matches
  num_best = min(50, ranked_num_rows);
  plotFigure(plotRowErrors(a_ranked_db, 1:num_best));

  % Save it as a picture 
  filename = properTeXFilename([ crit_db_id ' - colorgraph of ' num2str(num_best) ...
			     ' top matching models from ' a_db_id ]);
  orient tall; print('-depsc2', [ filename '.eps' ]);

  % Put it in a figure float
  % TODO: indicate distances of best and furthest matches
  short_caption = [ 'Individual measure distances color-coded for top matches of ' ...
		   a_db_id  ' ranked to the ' crit_db_id ' (' crit_trace_id ').'];
  caption = [ short_caption ...
	     ' Increasing distance represented with colors starting from ' ...
	     'blue to red. Dark blue=0 STD; light blue=1xSTD; yellow=2xSTD; ' ...
	     'and red=3xSTD difference.' ];
  tex_string = [ tex_string ...
		TeXtable([ '\includegraphics{' filename '}' ], ...
			 caption, struct('floatType', 'figure', ...
					 'center', 1, ...
					 'width', '\textwidth', ...
					 'shortCaption', short_caption)) ];

  % Display sorted colored-plot of top 50 matches
  plotFigure(plotRowErrors(a_ranked_db, 1:num_best, struct('sortMeasures', 1)));

  % Save it as a picture 
  filename = properTeXFilename([ crit_db_id ' - sorted colorgraph of ' num2str(num_best) ...
			     ' top matching models from ' a_db_id ]);
  orient tall; print('-depsc2', [ filename '.eps' ]);

  % Put it in a figure float
  % TODO: indicate distances of best and furthest matches
  short_caption = [ 'Sorted individual measure distances color-coded for top matches of ' ...
		   a_db_id  ' ranked to the ' crit_db_id ' (' crit_trace_id ').'];
  caption = [ short_caption ...
	     ' Increasing distance represented with colors starting from ' ...
	     'blue to red. Dark blue=0 STD; light blue=1xSTD; yellow=2xSTD; ' ...
	     'and red=3xSTD difference. Measures sorted with overall match quality. ' ];
  tex_string = [ tex_string ...
		TeXtable([ '\includegraphics{' filename '}' ], ...
			 caption, struct('floatType', 'figure', ...
					 'center', 1, ...
					 'width', '\textwidth', ...
					 'shortCaption', short_caption)) ];
  
  % Display parameter distributions of 50 best matches
  num_best = 50;
  top_ranks = onlyRowsTests(joined_db, 1:min(num_best, ranked_num_rows), ':', ':');
  all_param_cols = true(1, get(top_ranks, 'num_params'));
  all_param_cols(tests2cols(top_ranks, 'trial')) = false;
  p_hists = paramsHists(onlyRowsTests(top_ranks, ':', all_param_cols));
  plotFigure(plot_stack(num2cell(plotEqSpaced(p_hists)), [], 'x', ...
			['Parameter distribution histograms of ' num2str(num_best) ...
			 ' best matches' ], ...
			struct('yLabelsPos', 'left', 'titlesPos', 'none')));

  % Save it as a picture 
  filename = properTeXFilename([ crit_db_id ' - params distribution of top 50 matches to ' ...
			     a_db_id ]);
  print('-depsc2', [ filename '.eps' ]);

  % Put it in a figure float
  % TODO: indicate distances of best and furthest matches
  short_caption = [ 'Parameter distributions of the best ranked to the ' crit_db_id '.' ];
  caption = [ short_caption ...
	     ' Only ' num2str(num_best) ' best matches from ' a_db_id ...
	     ' are taken.' ];
  tex_string = [ tex_string ...
		TeXtable([ '\includegraphics{' filename '}' ], ...
			 caption, struct('floatType', 'figure', ...
					 'center', 1, ...
					 'width', '0.9\textwidth', ...
					 'shortCaption', short_caption)) ...
		'\clearpage%' sprintf('\n')];

end

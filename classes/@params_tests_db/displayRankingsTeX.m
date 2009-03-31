function tex_string = displayRankingsTeX(a_db, crit_db, props)

% displayRankingsTeX - Generates and displays a ranking DB by comparing rows of a_db with the given match criteria.
%
% Usage:
% tex_string = displayRankingsTeX(a_db, crit_db, props)
%
% Description:
%   Generates a LaTeX document with:
%	- Values of 10 best matching a_db rows in a floating table.
%	- (optional) Raw traces compared with some best matches at different distances
%	- Parameter distributions of 50 best matches as a bar graph.
%
%   Parameters:
%	a_db: A params_tests_db object to compare rows from.
%	crit_db: A tests_db object holding the match criterion tests and STDs
%		 which can be created with matchingRow.
%	props: A structure with any optional properties.
%		caption: Identification of the criterion db (not needed/used?).
%		a_dataset: Dataset for a_db.
%		a_dball: The non-joined DB for for a_db.
%		crit_dataset: Dataset for crit_db.
%		crit_dball: Dataset for crit_db.
%		num_matches: Number of best matches to display (default=10).
%		rotate: Rotation angle for best matches table (default=90).
%
%   Returns:
%	tex_string: LaTeX document string.
%
% See also: rankVsDB, displayRowsTeX
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/20

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct([]);
end

tex_string = '';

ranked_db = rankMatching(a_db, crit_db);
joined_db = joinOriginal(ranked_db);
ranked_num_rows = dbsize(ranked_db, 1);

% LaTeX likes '_' to be '\_' 
a_db_id = strrep(lower(get(a_db, 'id')), '_', '\_');
crit_db_id = strrep(lower(get(crit_db, 'id')), '_', '\_');

if ranked_num_rows > 0
  % Display values of 10 best matches
  if isfield(props, 'num_matches')
    num_best = props.num_matches;
  else
    num_best = 13;
  end
  top_ranks = onlyRowsTests(ranked_db, 1:min(num_best, ranked_num_rows), ':', ':');
  short_caption = [ a_db_id ' ranked to the ' crit_db_id '.' ];
  caption = [ short_caption ...
	     ' Only ' num2str(num_best) ' best matches are shown.' ];
  tex_string = [ tex_string displayRowsTeX(top_ranks, caption, ...
					   struct('shortCaption', short_caption, ...
						  'rotate', 0)) ];

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
  filename = [ lower(get(crit_db, 'id')) ' - top 50 - params distribution' ];
  % Replace all white space with underscores
  filename = strrep(filename, ' ', '_');
  filename = strrep(filename, '.', '_');
  filename = strrep(filename, '/', '+');  % And the /'s with +'s
  print('-depsc', [ filename '.eps' ]);

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
					 'shortCaption', short_caption)) ];

  % Display raw data traces from dataset
  if isfield(props, 'a_dataset') && isfield(props, 'a_dball') && ...
	isfield(props, 'crit_dataset')
    % prepare a landscape figure with two rows
    % one row for original and 5 matching data traces
    % second row for original and 5 matching spike shapes
    % TODO: This should be in a *_profile class
    crit_rows = onlyRowsTests(props.crit_dball, ':', 'TracesetIndex') == ...
	onlyRowsTests(crit_db, 1, 'TracesetIndex');
    crit_trace_d100 = ...
	cip_trace(props.crit_dataset, ...
		  onlyRowsTests(props.crit_dball, crit_rows & ...
				onlyRowsTests(props.crit_dball, ':', 'pAcip') == 100, ':'));
    crit_trace_h100 = ...
	cip_trace(props.crit_dataset, ...
		  onlyRowsTests(props.crit_dball, crit_rows & ...
				onlyRowsTests(props.crit_dball, ':', 'pAcip') == -100, ':'));
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
      plot_matching_d100 = ...
	  plotConcatSpontCIP(props.a_dataset, props.a_dball, trial_num, 100);
      trace_d100_plots{plot_num} = ...
	  superposePlots([plotData(crit_trace_d100(crit_traces)), ...
			  plot_matching_d100], {}, ...
			 ['Rank ' num2str(rank_num) ', t' num2str(trial_num)], ...
			 'plot', sup_props);
      plot_matching_h100 = ...
	  plotConcatSpontCIP(props.a_dataset, props.a_dball, trial_num, -100);
      trace_h100_plots{plot_num} = ...
	  superposePlots([plotData(crit_trace_h100(crit_traces)), ...
			  plot_matching_h100], {}, '', ...
			 'plot', sup_props);
    end

    % Make a full figure with the best matching guy
    plotFigure(plot_stack([trace_d100_plots{1}, trace_h100_plots{1}], ...
			  [0 3000 -150 80], 'y', ...
			  ['The best match to ' crit_trace_id ], ...
			  struct('xLabelsPos', 'bottom', 'titlesPos', 'none')));
    best_filename = [lower(get(crit_db, 'id')) ' - best matching model from ' ...
		     lower(get(a_db, 'id'))];

    % Replace all white space with underscores for LaTeX
    best_filename = strrep(best_filename, ' ', '_');
    best_filename = strrep(best_filename, '.', '_');
    orient tall; print('-depsc', [ best_filename '.eps' ] );

    horiz_props = struct('titlesPos', 'all', 'yLabelsPos', 'left', 'xLabelsPos', 'none');
    d100_row_plot = plot_stack([trace_d100_plots{2:num_plots}], [0 3000 -80 80], 'x', '', ... %+100 pA CIP
			      mergeStructs(struct('xLabelsPos', 'none'), horiz_props));
    h100_row_plot = plot_stack([trace_h100_plots{2:num_plots}], [0 3000 -150 80], 'x', '-100 pA CIP', ...
			       mergeStructs(struct('titlesPos', 'none'), horiz_props));

    plotFigure(plot_stack({d100_row_plot, h100_row_plot}, [], 'y', ...
			  ['Best matches to ' crit_trace_id ], ...
			  struct('titlesPos', 'none')));

    filename = [ lower(get(crit_db, 'id')) ' - top matching models from ' ...
		lower(get(a_db, 'id'))];

    % Replace all white space with underscores for LaTeX
    filename = strrep(filename, ' ', '_');
    filename = strrep(filename, '.', '_');
    print('-depsc', [ filename '.eps' ] );

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
					   'shortCaption', short_caption)) ...
		  '\clearpage%' sprintf('\n') ];

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
    
  end

end

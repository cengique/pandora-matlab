function tex_string = displayRankingsTeX(a_db, crit_db, props)

% displayRankingsTeX - Generates and displays a ranking DB by comparing rows of a_db with the given test criteria.
%
% Usage:
% tex_string = displayRankingsTeX(a_db, crit_db)
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
%		crit_dataset: Dataset for crit_db.
%
%   Returns:
%	tex_string: LaTeX document string.
%
% See also: rankVsDB, displayRowsTeX
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/20

if ~ exist('props')
  props = struct([]);
end

tex_string = '';

ranked_db = rankMatching(a_db, crit_db);
joined_db = joinOriginal(ranked_db);
ranked_num_rows = dbsize(ranked_db, 1);
if ranked_num_rows > 0
  %# Display values of 10 best matches
  num_best = 8;
  top_ranks = onlyRowsTests(ranked_db, 1:min(num_best, ranked_num_rows), ':', ':');
  short_caption = [ lower(get(a_db, 'id')) ' ranked to the ' lower(get(crit_db, 'id')) '.' ];
  caption = [ short_caption ...
	     ' Only ' num2str(num_best) ' best matches are shown.' ];
  tex_string = [ tex_string displayRowsTeX(top_ranks, caption, ...
					   struct('shortCaption', short_caption)) ];

  %# Display parameter distributions of 50 best matches
  num_best = 50;
  top_ranks = onlyRowsTests(joined_db, 1:min(num_best, ranked_num_rows), ':', ':');
  p_hists = paramsHists(top_ranks);
  plotFigure(plot_stack(num2cell(plotEqSpaced(p_hists)), [], 'x', ...
			['Parameter distribution histograms of ' num2str(num_best) ...
			 ' best matches' ], ...
			struct('yLabelsPos', 'left', 'titlesPos', 'none')));

  %# Save it as a picture 
  filename = [ get(crit_db, 'id') ' - top 50 - params distribution' ];
  %# Replace all white space with underscores
  filename = strrep(filename, ' ', '_');
  print('-depsc2', filename);

  %# Put it in a figure float
  %# TODO: indicate distances of best and furthest matches
  short_caption = [ 'Parameter distributions of the best ranked to the ' lower(get(crit_db, 'id')) '.' ];
  caption = [ short_caption ...
	     ' Only ' num2str(num_best) ' best matches from ' lower(get(a_db, 'id')) ...
	     ' are taken.' ];
  tex_string = [ tex_string ...
		TeXtable([ '\includegraphics{' filename '}' ], ...
			 caption, struct('floatType', 'figure', ...
					 'center', 1, ...
					 'width', '0.9\textwidth', ...
					 'shortCaption', short_caption)) ];

  %# Display raw data traces from dataset
  if isfield(props, 'a_dataset') && isfield(props, 'crit_dataset')
    %# prepare a landscape figure with two rows
    %# one row for original and 5 matching data traces
    %# second row for original and 5 matching spike shapes
    %# TODO: This should be in a *_profile class
    orig_prof = loadItemProfile(props.crit_dataset, get(onlyRowsTests(crit_db, 1, 'ItemIndex'), 'data'));
    trace_plots = cell(1, 6);
    spont_shape_plots = cell(1, 6);
    pulse_shape_plots = cell(1, 6);
    trace_plots{1} = plotData(orig_prof.trace);

    spont_results  = getResults(orig_prof.spont_spike_shape);
    spont_xmax = spont_results.MinTime * 1.1;
    spont_shape_plots{1} = set(plotResults(orig_prof.spont_spike_shape), ...
			       'title', 'Criterion');

    pulse_results  = getResults(orig_prof.pulse_spike_shape);
    pulse_xmax = pulse_results.MinTime * 1.1;
    pulse_shape_plots{1} = plotResults(orig_prof.pulse_spike_shape);
    %# = setProp(, 'title', 'Criterion');

    for plot_num=1:5
      rank_num = (plot_num - 1) * 10 + 1;
      prof = loadItemProfile(props.a_dataset, ...
			     get(onlyRowsTests(joined_db, rank_num , ...
					       'ItemIndex'), 'data'));
      trace_plots{1 + plot_num} = plotData(prof.trace);
      spont_results  = getResults(prof.spont_spike_shape);
      spont_xmax = max(spont_xmax, spont_results.MinTime * 1.1);
      spont_shape_plots{1 + plot_num} = ...
	  set(plotResults(prof.spont_spike_shape), ...
	      'title', ['Rank ' num2str(rank_num) ]);

      pulse_results  = getResults(prof.pulse_spike_shape);
      pulse_xmax = max(pulse_xmax, pulse_results.MinTime * 1.1);
      pulse_shape_plots{1 + plot_num} = plotResults(prof.pulse_spike_shape);
    end
    horiz_props = struct('titlesPos', 'none', 'yLabelsPos', 'left', 'xLabelsPos', 'none');
    top_row_plot = plot_stack(trace_plots, [], 'x', ...
			      'Raw traces', ...
			      mergeStructs(struct('xLabelsPos', 'bottom'), horiz_props));
    bottom_row_plot2 = plot_stack(pulse_shape_plots, [0, pulse_xmax, NaN, NaN], 'x', ...
				 'Pulse spike shapes', ...
				 horiz_props);
    bottom_row_plot = plot_stack(spont_shape_plots, [0, spont_xmax, NaN, NaN], 'x', ...
				 'Spontaneous spike shapes', ...
				 mergeStructs(struct('titlesPos', 'all'), horiz_props));

    plotFigure(plot_stack({top_row_plot, bottom_row_plot2, bottom_row_plot}, ...
			  [], 'y', '', struct('titlesPos', 'none')));

    filename = [ get(crit_db, 'id') ' - some matching raw traces' ];
    %# Replace all white space with underscores
    filename = strrep(filename, ' ', '_');
    print('-depsc2', filename);

    %# Put it in a figure float
    %# TODO: indicate distances of best and furthest matches
    short_caption = [ 'Raw traces of the ranked to the ' lower(get(crit_db, 'id')) '.' ];
    caption = [ short_caption ...
	       ' Leftmost trace and spike shape from ' lower(get(crit_db, 'id')) ...
	       '. Other traces are taken from 5 equidistant matches from the best' ...
	       ' 50 matches from ' lower(get(a_db, 'id')) '.' ];
    tex_string = [ tex_string ...
		  TeXtable([ '\includegraphics{' filename '}' ], ...
			   caption, struct('floatType', 'figure', ...
					   'center', 1, ...
					   'rotate', 90, ...
					   'width', '1\textwidth', ...
					   'shortCaption', short_caption)) ...
		  '\clearpage%' sprintf('\n') ];
    
  end

end

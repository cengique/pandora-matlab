function a_plot = plotParamPairImage(a_db, test, title_str, props)

% plotParamPairImage - Generates an image plot of variation of a test with two parameters in the first page.
%
% Usage:
% a_plot = plotParamPairImage(a_db, test, title_str, props)
%
% Description:
%   It is assumed that the 3D DB is created by invariant combinations of two parameters,
% which are the first two columns. Each page of the db must contain a same parameter 
% values. This is the default character of tests_3D_db created by 
% params_tests_db/invarParam. Parameter values will be enumerated and then an 
% image plot is created.
%
%   Parameters:
%	a_db: A tests_3D_db object.
%	test: Test column to take the measure value.
%	title_str: (Optional) String to append to plot title.
%	props: Optional properties to be passed to plot_abstract.
%	  truncateDecDigits: Truncate labels to this many decimal digits.
%	  labelSteps: Skip this many labels between ticks to reduce to total number.
%	  maxValue: Maximal value to normalize colors and to annotate the colorbar.
%		
%   Returns:
%	a_plot: A plot_abstract object or one of its subclasses.
%
% Example:
% Find relationship of two parameters against a measure:
% >> plotFigure(plotParamPairImage(invarParam(a_db, {'NaF', 'KCNQ'}), 'PulseIni100msRest2SpikeRateISI_D100pA'));
%
% See also: params_tests_db/invarParam, plotImage, plot_abstract.
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/11/10

if ~ exist('props')
  props = struct([]);
end

%# Take only the first page
page_db = onlyRowsTests(a_db, ':', ':', 1);

%# Enumerate the first two columns (parameters)
enum_db = enumerateColumns(page_db, 1:2, struct('truncateDecDigits', 3));
enum_data = get(enum_db, 'data');

col = tests2cols(enum_db, test);

num_param1 = max(enum_data(:, 1));
num_param2 = max(enum_data(:, 2));

%# Address values into image_data
image_data = nan(num_param1, num_param2);
for row_num = 1:dbsize(a_db, 1)
  %# Invert rows
  image_data(num_param1 - enum_data(row_num, 1) + 1, enum_data(row_num, 2)) = ...
      enum_data(row_num, col);
end

num_colors = 50;

col_names = getColNames(a_db, test)
if ~ exist('title_str') || isempty(title_str)
  title_str = ['Change of ' properTeXLabel(col_names{1}) ' in ' ...
	       properTeXLabel(get(a_db, 'id'))];
end

%# Truncate some digits to unify parameter values estranged by numerical error
if isfield(props, 'truncateDecDigits')
  mult_factor = 10^props.truncateDecDigits;
else
  mult_factor = 10^3;
end

if isfield(props, 'labelSteps')
  skip_steps = props.labelSteps;
else
  skip_steps = 1;
end

page_data = get(page_db, 'data');
plot_props.YTick = 1:skip_steps:num_param1;
unique_vals = sort(uniqueValues(round(page_data(:, 1) * mult_factor) / mult_factor));
plot_props.YTickLabel = unique_vals(end:-skip_steps:1);

plot_props.XTick = 1:skip_steps:num_param2;
unique_vals = sort(uniqueValues(round(page_data(:, 2) * mult_factor) / mult_factor));
plot_props.XTickLabel = unique_vals(1:skip_steps:end);

% send this to the plot
if ~ isfield(props, 'maxValue')
  props.maxValue = max(max(image_data));
end

a_plot = plot_abstract({image_data ./ props.maxValue * num_colors, @gray, ...
			num_colors, props}, getColNames(a_db, [2 1]), ...
		       title_str, {}, @plotImage, mergeStructs(props, ...
                                                  plot_props));

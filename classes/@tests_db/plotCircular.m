function a_p = plotCircular(a_db, theta_col, title_str, short_title, props)

% plotCircular - Circular plot.
%
% Usage:
% a_p = plotCircular(a_db, theta_col, title_str, short_title, props)
%
% Parameters:
%   a_db: A tests_db object.
%   theta_col: Column with angle values to plot on circle.
%   title_str: (Optional) A string to be concatanated to the title.
%   short_title: (Optional) Few words that may appear in legends of multiplot.
%   props: A structure with any optional properties.
%     avgVector: If 1, plot an average vector from polar coordinates.
%     radius: The radius at which angles are plotted (default=1).
%     angles1: If 1, angles are in the range of 0-1, and they will be
%     	converted to radians.
%     jitter: Add this much random jitter to radius while plotting.
%     quiet: If 1, don't include database name on title.
%		
% Returns:
%   a_p: A plot_abstract.
%
% Description:
%   Radius is taken to be constant on the unit circle.
%
% See also: polar, pol2cart
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2014/07/14

% Copyright (c) 2007-2014 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% TODO: 
% - also add option to draw histogram
% - also add option to calculate stats?

vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

if ~ exist('title_str', 'var')
  title_str = '';
end

if ~ exist('props', 'var')
  props = struct;
end

col = tests2cols(a_db, theta_col);
col_db = onlyRowsTests(a_db, ':', col);

% add the radius
radius = getFieldDefault(props, 'radius', 1);
col_db = addColumns(col_db, 'radius', ones(dbsize(col_db)) * radius);

% skip NaN value rows
col_db = onlyRowsTests(col_db, ~isnan(col_db), ':');

if isfield(props, 'angles1')
  col_db = ...
      assignRowsTests(col_db, ...
                      onlyRowsTests(col_db, ':', 1) * 2 * pi, ':', 1);
end

test_names = fieldnames(get(a_db, 'col_idx'));

if ~ exist('short_title', 'var') || isempty(short_title)
  short_title = [ strrep(test_names{col}, '_', ' ') ];
end

if ~ isfield(props, 'quiet')
  all_title = [ strrep(get(a_db, 'id'), '_', '\_') title_str ];
else
  all_title = title_str;
end

jitter = getFieldDefault(props, 'jitter', 0);
rdata = get(onlyRowsTests(col_db, ':', 2), 'data');

if jitter ~= 0
  rdata = rdata + jitter * rand(size(rdata));
end

a_p = plot_abstract({get(onlyRowsTests(col_db, ':', 1), 'data'), ...
                    rdata}, ...
                {}, all_title, { short_title }, 'polar', ...
                mergeStructsRecursive(...
                  props, ...
                  struct('plotProps', ...
                         struct('Marker', '.', 'LineStyle', 'none'))));

if isfield(props, 'avgVector')
  % convert polar to cartesien coordinate system for averaging
  mypol2cart = @(uv) [cos(uv(:, 1)).*uv(:, 2), sin(uv(:, 1)).*uv(:, 2) ];
  cart_db = ...
      set(col_db, 'data', mypol2cart(get(col_db, 'data')));

  cart_mean = get(mean(cart_db), 'data');
  a_p = plot_superpose({...
    a_p, ...
    plot_abstract(mat2cell([0 0; cart_mean], 2, [1 1]), ...
                  {}, '', {''}, 'plot', ...
                  mergeStructsRecursive(...
                    props, ...
                    struct('plotProps', struct('Marker', '.', 'LineStyle', '-'))))}, {}, '');

  % display the calculated size
  hypothenus = sqrt(sum(cart_mean .* cart_mean));
  uv = [atan(cart_mean(1)/cart_mean(2))*360/2/pi, hypothenus];
  disp([ 'Mean vector (angle, radius) for ' short_title ': ' num2str(uv)])
end

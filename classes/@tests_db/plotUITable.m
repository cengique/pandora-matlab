function a_p = plotUITable(a_db, title_str, props)

% plotUITable - Display rows in figure table element.
%
% Usage:
% a_p = plotUITable(a_db, title_str, props)
%
% Parameters:
%   a_db: A params_tests_db object.
%   title_str: (Optional) A string to be concatanated to the title.
%   props: A structure with any optional properties
%		
% Returns:
%   a_p: A plot_abstract.
%
% Description:
%
% Example:
% >> plotFigure(plotUITable(my_db(1:5, :), 'my DB'))
%
% See also: displayRows
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2014/10/22

% Copyright (c) 2014 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('title_str', 'var')
  title_str = '';
end

if ~ exist('props', 'var')
  props = struct;
end

display_data = displayRows(a_db);

a_p = plot_abstract({'Data', display_data(2:end, 2:end), 'ColumnName', display_data(1, 2:end), ...
                    'RowName', display_data(2:end, 1), ...
                    'Units', 'Normalized', 'Position', [0 0 1 1]}, {}, ...
                    title_str, {}, 'uitable', props);

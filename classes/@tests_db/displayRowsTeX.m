function tex_string = displayRowsTeX(a_db, caption, props)

% displayRowsTeX - Generates a LaTeX table that lists rows of this DB.
%
% Usage:
% tex_string = displayRowsTeX(a_db, caption, props)
%
% Description:
%   By default table is rotated 90 degrees and scaled to 90% of page height.
%
%   Parameters:
%	a_db: A tests_db object.
%	caption: Table caption.
%	props: A structure with any optional properties, passed to TeXtable.
%
%   Returns:
%	tex_string: LaTeX string for table float.
%
% Example:
% >> string2File(displayRowsTeX(a_db(1:10, 4:7), 'some values',
%                               struct('rotate', 0)), 'table.tex')
%
% See also: displayRows, TeXtable, cell2TeX
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/16

if ~ exist('props')
  props = struct([]);
end

if ~ exist('caption') || isempty(caption)
  caption = [ 'Rows of ' strrep(get(a_db, 'id'), '_', '\_') '.' ];
end

%# User props have priority
props = mergeStructs(props, struct('rotate', 90, ...
				   'height', '0.9\textheight', ...
				   'center', 1, 'shortCaption', caption));

%# List all db rows in a table
%# TODO: need to pass hasTitleRow to cell2TeX for ranked_db
tex_string = [ TeXtable(cell2TeX(displayRows(a_db, ':')), ...
			caption, props) ...
	      sprintf('\n') ];

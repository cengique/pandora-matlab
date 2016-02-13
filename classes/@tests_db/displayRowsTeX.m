function tex_string = displayRowsTeX(a_db, caption, props)

% displayRowsTeX - Generates a LaTeX table that lists rows of this DB.
%
% Usage:
% tex_string = displayRowsTeX(a_db, caption, props)
%
% Parameters:
%   a_db: A tests_db object.
%   caption: Table caption.
%   props: A structure with any optional properties, passed to TeXfloat.
%     landscape: If 1, rotate table 90 degrees and scale to 90% of page height.
%
% Returns:
%   tex_string: LaTeX string for table float.
%
% Description:
%   Can be then written to a file for processing by Latex or inclusion in
% other documents.
%
% Example:
% >> string2File(displayRowsTeX(a_db(1:10, 4:7), 'some values',
%                               struct('rotate', 0)), 'table.tex')
%
% See also: displayRows, TeXfloat, cell2TeX
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/16

% Copyright (c) 2007-14 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct([]);
end

if ~ exist('caption', 'var') || isempty(caption)
  caption = [ 'Rows of ' strrep(get(a_db, 'id'), '_', '\_') '.' ];
end

def_props = struct('center', 1, 'shortCaption', caption);
if isfield(props, 'landscape')
  def_props = ...
      mergeStructs(def_props, ...
                   struct('rotate', 90, 'height', '0.9\textheight'));
end

% User props have priority
props = mergeStructs(props, def_props);

if ~ isempty(fieldnames(get(a_db, 'row_idx')))
  props = mergeStructs(props, struct('hasTitleRow', 1));
end

% List all db rows in a table
% TODO: need to pass hasTitleRow to cell2TeX for ranked_db
tex_string = [ TeXfloat(cell2TeX(displayRows(a_db, ':'), props), ...
			caption, props) ...
	      sprintf('\n') ];

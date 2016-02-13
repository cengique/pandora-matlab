function tex_string = TeXfloat(contents, caption, props)

% TeXfloat - Places LaTeX content into a float (e.g., table, figure).
%
% Usage:
% tex_string = TeXfloat(contents, caption, props)
%
% Parameters:
%   contents: Table contents in LaTeX.
%   caption: Table caption.
%   props: A structure with any optional properties.
%     rotate: Degrees to rotate.
%     width: Resize to this width.
%     height: Resize to this height
%     center: Align to center.
%     shortCaption: Short version of caption to appear at list of tables.
%     floatType: LaTeX float to use (default='table').
%     label: Used for internal LaTeX references.
%		
% Returns:
%   tex_string: LaTeX string for float.
%
% Description:
%   Tabular contents can be created from cell arrays using
% cell2TeX. displayRowsTeX calls this function to make the float directly
% from database contents.
%
% Example:
% >> string2File(TeXfloat(cell2TeX({'a', 1; 'b', 2}), 'a basic table', ...
%     		 struct('rotate', 90, 'label', 'simple-table')))
%
% See also: cell2TeX, tests_db/displayRowsTeX
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/13

% Copyright (c) 2007-14 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% TODO: should be renamed to TeXfloat

if ~ exist('props', 'var')
  props = struct([]);
end

float_type = 'table';
if isfield(props, 'floatType')
  float_type = props.floatType;
end

tex_string = ['\begin{' float_type '}' sprintf('\n') ];

% Center
if isfield(props, 'center')
  tex_string = [ tex_string '\centering%' sprintf('\n') ];
end

% Resize
if isfield(props, 'width') && ~ strcmp(props.width, '!')
  tex_string = [ tex_string '\resizebox*{' props.width '}{!}{' ];
  resize = 1;
elseif isfield(props, 'height') && ~ strcmp(props.height, '!')
  tex_string = [ tex_string '\resizebox*{!}{' props.height '}{' ];
  resize = 1;
else
  resize = 0;
end

% Rotate
is_rotate = false;
if isfield(props, 'rotate') && props.rotate ~= 0
  tex_string = [ tex_string '\rotatebox{' num2str(props.rotate) '}{' ];
  is_rotate = true;
end

% Place contents
tex_string = [ tex_string contents ];

% Close rotate
if is_rotate
  tex_string = [ tex_string '}' ];
end

% Close resize
if resize
  tex_string = [ tex_string '}' ];
end

% Caption
short_caption = '';
if isfield(props, 'shortCaption')
  short_caption = [ '[' props.shortCaption ']' ];
end
tex_string = [ tex_string sprintf('\n') '\caption' short_caption ...
	      '{' caption '}' sprintf('\n') ];

if isfield(props, 'label')
  tex_string = [ tex_string sprintf('\n') '\label{' props.label '}' ...
                 sprintf('\n') ];
end

tex_string = [ tex_string '\end{' float_type '}' sprintf('\n\n') ];


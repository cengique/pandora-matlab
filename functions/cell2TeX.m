function tex_string = cell2TeX(a_cell, props)

% cell2TeX - Creates LaTeX string of a formatted table with the cell array's contents.
%
% Usage:
% tex_string = cell2TeX(a_cell, props)
%
% Description:
%
%   Parameters:
% 	a_cell: A cell matrix to be tabularized.
%	props: A structure with any optional properties.
%		hasTitleRow: The first row contains titles.
%		hasTitleCol: The first column contains titles.
%		
%   Returns:
%	tex_string: LaTeX formatted table string.
%
% See also: 
%
% $Id: cell2TeX.m,v 1.5 2005/08/10 20:27:21 cengiz Exp $
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/09

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props')
  props = struct([]);
end

% TODO: get column formatting in props, count rlc's and divide size by that.
col_align = {'|c'};
col_align = cat(2, col_align{ones(1, size(a_cell, 2))});
tex_string = ['\begin{tabular}{' col_align '|}' sprintf('\n') ];

for row=1:size(a_cell, 1)
  row_string = '';
  for col=1:size(a_cell, 2)
    the_cell = a_cell{row, col};
    if ischar(the_cell)
      if ~ isempty(regexp(the_cell, '^[\d*+-/()\[\].]+$'))
	% It's a numeric string
	add_string = [ '$' the_cell '$' ];
      else
	add_string = strrep(the_cell, '_', ' '); % replace _ with space
      end
    elseif isnan(the_cell) || isinf(the_cell)
      add_string = [ num2str(the_cell) ];
    else
      add_string = [ '$' num2str(the_cell) '$' ];
    end
    row_string = [ row_string add_string ];
    if col ~= size(a_cell, 2)
      row_string = [ row_string ' & ' ];
    end
  end
  tex_string = [ tex_string row_string '\\' sprintf('\n') ];
  if isfield(props, 'hasTitleRow') && row == 1
    tex_string = [ tex_string '\hrule%' sprintf('\n') ]
  end
end
tex_string = [ tex_string '\end{tabular}' sprintf('\n') ];


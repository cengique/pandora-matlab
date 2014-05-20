function a_str = cell2str(a_cell, props)

% cell2str - Creates a tab-delimited string from the cell array's contents.
%
% Usage:
% a_str = cell2str(a_cell, props)
%
% Description:
%
% Parameters:
%   a_cell: A cell matrix to be tabularized.
%   props: A structure with any optional properties.
%		
% Returns:
%   a_str: LaTeX formatted table string.
%
% See also: 
%
% $Id: cell2str.m 1334 2012-04-19 18:02:13Z cengique $
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/09

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct([]);
end

a_str = '';

for row=1:size(a_cell, 1)
  row_string = '';
  for col=1:size(a_cell, 2)
    the_cell = a_cell{row, col};
    if ischar(the_cell)
      if ~ isempty(regexp(the_cell, '^[\d*+-/()\[\].]+$'))
	% It's a numeric string
	add_string = [ the_cell ];
      else
	add_string = strrep(the_cell, '_', ' '); % replace _ with space
      end
    elseif isempty(the_cell)
      add_string = '';
    elseif isnan(the_cell) || isinf(the_cell)
      add_string = [ num2str(the_cell) ];
    else
      add_string = [ num2str(the_cell) ];
    end
    row_string = [ row_string add_string ];
    if col ~= size(a_cell, 2)
      row_string = [ row_string sprintf('\t\t') ];
    end
  end
  a_str = [ a_str row_string sprintf('\n') ];
end
a_str = [ a_str sprintf('\n') ];


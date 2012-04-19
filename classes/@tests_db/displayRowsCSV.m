function csv_string = displayRowsCSV(a_db, props)

% displayRowsCSV - Returns a comma-separated values (CSV) version of the table.
%
% Usage:
% csv_string = displayRowsCSV(a_db, props)
%
% Parameters:
%   a_db: A tests_db object.
%   props: A structure with any optional properties.
%
% Returns:
%   csv_string: String that can be saved as  a file or copy-pasted into other software.
%
% Description:
% Uses displayRows. See its documentation for details.
%
% Example:
% >> string2File(displayRowsCSV(a_db(1:10, 4:7)), 'excel-export.csv')
%
% See also: displayRows, displayRowsTeX
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/07/07

% Copyright (c) 2011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

props = defaultValue('props', struct);

% List all db rows in a table and
% convert to cell of strings
csv_string = cellfun(@(x) [ format_cell(x) ', ' ], displayRows(a_db, ':'), ...
                     'UniformOutput', false);

% put end of lines
csv_string = ...
    [ csv_string repmat({sprintf('\n')}, size(csv_string, 1), 1) ]';

% concat all strings
csv_string = [ csv_string{:} ];

end
 
 function y = format_cell(x)
 if ischar(x)
   y = [ '"' x '"' ];
 else
   y = num2str(x);
 end
 end
function col_idx = makeColIdx(col_names)

% makeColIdx - Prepare the col_idx structure from col_names.
%
% Usage:
% col_idx = makeColIdx(col_names)
%
% Description:
% Helper function.
%
%   Parameters:
%	col_names: Cell array of column names.
%		
%   Returns:
%	col_idx: Structure associating column names to column indices.
%
% See also: tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/17

%# Prepare col_idx
col_idx = struct;
for i=1:length(col_names)
  col_idx = setfield(col_idx, col_names{i}, i);
end

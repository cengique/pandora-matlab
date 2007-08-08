function a_db = transpose(a_db)

% transpose - Transposes data matrix and swaps row and columns metadata as well.
%
% Usage:
% a_db = transpose(a_db)
%
% Description:
%
%   Parameters:
%	a_db: A tests_db.
%		
%   Returns:
%	a_db: The transposed tests_db.
%
% See also: transpose
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2007/02/07

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

%# swap row-col metadata
row_idx = a_db.row_idx;
a_db.row_idx = a_db.col_idx;
a_db.col_idx = row_idx;

%# swap data
a_db.data = a_db.data';

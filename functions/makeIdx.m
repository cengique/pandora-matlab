function idx = makeIdx(names)

% makeIdx - Prepare the idx structure from names.
%
% Usage:
% idx = makeIdx(names)
%
% Description:
% Helper function.
%
%   Parameters:
%	names: Cell array of names for a db dimension.
%		
%   Returns:
%	idx: Structure associating names to array indices.
%
% See also: tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/17

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

%# Prepare idx
idx = struct;
for i=1:length(names)
  %# replace '-' characters
  idx = setfield(idx, strrep(names{i}, '-', '_'), i);
end

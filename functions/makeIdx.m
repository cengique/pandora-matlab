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

%# Prepare idx
idx = struct;
for i=1:length(names)
  %# replace '-' characters
  idx = setfield(idx, strrep(names{i}, '-', '_'), i);
end

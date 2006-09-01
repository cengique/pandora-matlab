function s = end(db, index, total)

% end - Overloaded primitive matlab function, returns maximal dimension size.
%
% Usage:
% s = end(db, index, total)
%
% Description:
%
%   Parameters:
%	db: A tests_db object.
%		
%   Returns:
%	s: The size.
%
% See also: size, tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/06

s = dbsize(db, index);

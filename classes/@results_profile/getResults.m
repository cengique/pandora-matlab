function results = getResults(p)

% getResults - Return the results profile structure.
%
% Usage:
% results = getResults(p)
%
% Description:
%
%   Parameters:
%	p: A result_profile object.
%
%   Returns:
%	results: A structure associating test names to values.
%
% See also: results_profile
%
% $Id$
%
% Author: 
%   Cengiz Gunay <cgunay@emory.edu>, 2004/09/14

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

results = p.results;

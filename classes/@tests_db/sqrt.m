function a_db = sqrt(a_db)

% sqrt - Takes the square root of a_db.
%
% Usage:
% a_db = sqrt(a_db)
%
% Description:
%  Overloaded sqrt function.
%
% Parameters:
%   a_db: A tests_db.
%		
% Returns:
%   a_db: The resulting tests_db.
%
% See also: sqrt
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2007/12/13

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

a_db = set(a_db, 'id', [ 'sqrt(' get(a_db, 'id') ')' ]);
a_db = tests_db(a_db, 'data', sqrt(get(a_db, 'data')));

function a_db = swapColsPages(db)

% swapColsPages - Swaps the column dimension with the page dimension of the tests_db.
%
% Usage:
% a_db = swapColsPages(db)
%
% Parameters:
%	db: A tests_db object.
%		
% Returns:
%	a_db: A tests_db object.
%
% Description:
%   Watered-down version of the tests_3D_db/swapColsPages function that
% does not touch column indices. 
%
% See also: tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2017/06/09

% Copyright (c) 2017 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% Reorder the column and page dimensions
a_db = set(db, 'data', permute(get(db, 'data'), [1, 3, 2]));

% erase column info
a_db.col_idx = makeIdx(cellfun( @(x)['col' num2str(x) ], ...
                                num2cell(1:dbsize(a_db, 2)), ...
                                'UniformOutput', false ));


function a_db_piece = runJob(a_s, vector_index)

% runJob - Loads one piece of the database.
%
% Usage:
% a_db_piece = runJob(a_s, vector_index)
%
% Parameters:
%	a_s: A script_array_loaddb object.
%	vector_index: The index within the vector job.
%
% Returns:
%   a_db_piece: Piece of loaded database.
%
% Description:
%   Load the part of the database calculated by the index. Uses
% the params_tests_dataset/params_tests_db method to load the database.
%
% See also: script_array_loaddb, runLast, runFirst
%
% $Id: runJob.m 1335 2012-04-19 18:04:32Z cengique $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2014/04/02

% Copyright (c) 2007-2014 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

items = ...
    getFieldDefault(get(a_s, 'props'), 'items', ...
                                  1:length(a_s.dataset.list));
num_items = length(items);
num_runs = get(a_s, 'num_runs');

a_db_piece = ...
    params_tests_db(a_s.dataset, ...
                    items(round((vector_index-1)*num_items/num_runs + 1):...
                          round(vector_index*num_items/num_runs)));
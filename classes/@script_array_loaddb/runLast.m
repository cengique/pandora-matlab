function a_db = runLast(a_script_array, job_results)

% runLast - Method to be called last after the script_array jobs.
%
% Usage:
% a_db = runLast(a_script_array, job_results)
%
% Parameters:
%	a_script_array: A script_array object.
%	job_results: The index within the vector job.
%
% Returns:
%   a_db: Concatenated database.
%
% Description:
%   Combines the separately loaded databases found in job_results into a
% final one and returns it.
%
% See also: script_array_loaddb, runJob, runFirst
%
% $Id: runLast.m 1335 2012-04-19 18:04:32Z cengique $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2014/04/02

% Copyright (c) 2007-2014 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% Take first piece and use it as the object to hold all
% (such that we have the right type of tests_db subclass)
  a_db = job_results{1};
  
  num_rows = 0;
  % count all rows
  for i=1:length(job_results)
    num_rows = num_rows + dbsize(job_results{i}, 1);
  end
  
  % allocate new matrix
  a_db.data = [];
  a_db = allocateRows(a_db, num_rows);

  % fill it by addressing rows (much faster than appending!)
  start_row = 1;
  for i=1:length(job_results)
    new_rows = dbsize(job_results{i}, 1);
    a_db(start_row:(start_row + new_rows - 1), :) = ...
        job_results{i}.data;
    start_row = start_row + new_rows;
  end

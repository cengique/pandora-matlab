function job_results = runFirst(a_script_array)

% runFirst - Method to be called at beginning of script_array jobs.
%
% Usage:
% job_results = runFirst(a_script_array)
%
% Parameters:
%	a_script_array: A script_array object.
%
% Returns:
%	job_results: A cell array of results collected from each item of the vector jobs.
%
% Description:
%   This method initiates the script_array jobs. It loops and calls runJob and 
% finally calls runLast.
%
% Example:
% >> runFirst(script_array(10, 'this one does nothing for 10 times'));
%
% See also: runLast, runJob
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/02/01

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

job_results = cell(a_script_array.num_runs, 1);
for vector_index=1:a_script_array.num_runs
  job_results{vector_index} = runJob(a_script_array, vector_index);
end

job_results = runLast(a_script_array, job_results);

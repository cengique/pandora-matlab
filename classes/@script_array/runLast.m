function job_results = runLast(a_script_array, job_results)

% runLast - Method to be called last after the script_array jobs.
%
% Usage:
% job_results = runLast(a_script_array, job_results)
%
% Parameters:
%	a_script_array: A script_array object.
%	job_results: The index within the vector job.
%
% Returns:
%   job_results: Any output produced by the job.
%
% Description:
%   This method is provided as a placeholder and does nothing. It can filter-out the
% results returned from the jobs run. Normally it is invoked internally by the runFirst
% method, after running and collecting results from the vector jobs with the runJob method.
%
% Example:
% Call it directly:
% >> runLast(script_array(10, 'this one does nothing for 10 times'), {});
%
% See also: runJob, runFirst
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/02/01

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% Do nothing

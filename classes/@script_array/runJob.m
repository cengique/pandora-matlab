function job_result = runJob(a_script_array, vector_index)

% runJob - Method to be called for each of the script_array jobs.
%
% Usage:
% job_result = runJob(a_script_array, vector_index)
%
% Parameters:
%	a_script_array: A script_array object.
%	vector_index: The index within the vector job.
%
% Returns:
%   job_result: Any output produced by the job.
%
% Description:
%   This method is provided as a placeholder and does nothing. If the run_job_func
% property is defined, it will call that function.
%
% Example:
% See real example in script_array. Call the 5th job:
% >> runJob(script_array(10, 'this one does nothing for 10 times'), 5);
%
% See also: runLast, runFirst
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/02/01

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

%# Call the run_job_func, if defined
if isfield(a_script_array.props, 'runJobFunc')
  job_result = feval(a_script_array.props.runJobFunc, vector_index);
else
  job_result = [];
end

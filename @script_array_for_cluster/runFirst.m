function job_results = runFirst(a_script_cluster)

% runFirst - Method to be called at beginning of script_array_for_cluster jobs.
%
% Usage:
% job_results = runFirst(a_script_cluster)
%
% Parameters:
%	a_script_cluster: A script_array_for_cluster object.
%
% Returns:
%	job_results: A cell array of results collected from each item of the vector jobs.
%
% Description:
%   This method initiates the script_array_for_cluster jobs. It submits an SGE vector job for running
% each runJob and finally runLast. There is no way of collecting outputs from 
% individual runJob calls.
%
% Example:
% >> runFirst(script_array_for_cluster(10, 'this one does nothing for 10 times'));
%
% See also: script_array_for_cluster
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/02/01

eol_str = sprintf('\n');

%# Save this object into a file
save([get(a_script_cluster, 'id') '.mat' ], 'a_script_cluster');

%# Submit a SGE job for the array jobs
load_obj = ['load ''' get(a_script_cluster, 'id') '.mat''; '];
array_job_command = ...
    ['qsub -t 1:' num2str(get(a_script_cluster, 'num_runs')) ' ' ...
     a_script_cluster.sge_wrapper_script ' "' load_obj ...
     'runJob(a_script_cluster, %d)"' ];
[s, w] = system(array_job_command);

if s == 0
  %# Success, look for SGE job number
  [array_job_number] = sscanf(w, 'Your job %d');

  disp(['Submitted job ' num2str(array_job_number) ': ' eol_str array_job_command]);

  %# Check if mail notification is requested
  a_props = get(a_script_cluster, 'props');
  if isfield(a_props, 'notifyByMail')
    sge_opts = ['-m ea -M ' a_props.notifyByMail];
  else
    sge_opts = '';
  end

  %# Then submit the last job as dependent on the array job
  last_job_command = ...
      ['qsub -hold_jid ' num2str(array_job_number) ' ' sge_opts ' ' ...
       a_script_cluster.sge_wrapper_script ' "' load_obj ...
       'runLast(a_script_cluster)"' ];
  [s, w] = system(last_job_command);
  if s == 0
    %# Success, look for SGE job number
    [last_job_number] = sscanf(w, 'Your job %d');
    disp(['Submitted last job ' num2str(last_job_number) ': ' eol_str last_job_command]);

  else
    error(['Could not submit last job!' eol_str last_job_command eol_str ...
	   'Error: ' w ]);
  end

else
  error([ 'Could not submit array job!' sprintf('\n') array_job_command eol_str ...
	 'Error: ' w ]);
end

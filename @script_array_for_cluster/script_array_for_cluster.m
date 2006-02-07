function a_script_cluster = script_array_for_cluster(num_runs, sge_wrapper_script, id, props)

% script_array_for_cluster - Generic class defining a repetitive vector job to be run on a Sun Grid Engine (SGE) computing cluster.
%
% Usage:
% a_script_cluster = script_array_for_cluster(num_runs, sge_wrapper_script, id, props)
%
% Parameters:
%	num_runs: The number of times the runJob script should be evoked.
%	sge_wrapper_script: A script that can be submitted with qsub and can execute arbitrary
%		Matlab commands on the cluster nodes. It can have qsub options prepended to it
%		such as '-p -100 -q all.q <abs_path_to>/sge_matlab.sh'.
%	id: Identification string.
%	props: A structure with any optional properties.
%	  notifyByMail: An SGE notification email is sent to this address after lastJob.
%	  (others passed to script_array)
%
% Description:
%   This is a subclass of the script_array class. The runFirst method spawns num_runs
% copies of the runJob method in parallel on the cluster, followed by the invocation 
% of the runLast method.
%
% Returns a structure object with the following fields:
%	num_runs, id, props.
%
% General methods of script_array_for_cluster objects:
%   script_array_for_cluster - Construct a new script_array_for_cluster object.
%   runFirst	- Script run at the beginning
%   runLast	- Script run at the end
%   runJob	- Script to run with each job number sequence.
%   display	- Returns and displays the identification string.
%   get		- Gets attributes of this object and parents.
%   subsref	- Allows usage of . operator.
%
% Additional methods:
%   See methods('script_array_for_cluster') and methods('script_array')
%
% See also: runFirst, runLast, runJob, script_array
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/02/02

if nargin == 0 %# Called with no params, creates empty object
  a_script_cluster.sge_wrapper_script = '';
  a_script_cluster = class(a_script_cluster, 'script_array_for_cluster', script_array);
elseif isa(num_runs, 'script_array_for_cluster') %# copy constructor?
  a_script_cluster = num_runs;
else
  if ~ exist('props')
    props = struct;
  end

  a_script_cluster.sge_wrapper_script = sge_wrapper_script;

  %# Create the object
  a_script_cluster = class(a_script_cluster, 'script_array_for_cluster', ...
			   script_array(num_runs, id, props));
end

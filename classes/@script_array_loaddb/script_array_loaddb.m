function a_s = script_array_loaddb(num_runs, a_dataset, id, props)

% script_array_loaddb - Loads dataset items into a database by partitioning into parallel tasks.
%
% Usage:
% a_s = script_array_loaddb(num_runs, a_dataset, id, props)
%
% Parameters:
%   num_runs: The number of times the runJob script should be evoked.
%   sge_wrapper_script: A script that can be submitted with qsub and can execute arbitrary
%     Matlab commands on the cluster nodes. It can have qsub options prepended to it
%     such as '-p -100 -q all.q <abs_path_to>/sge_matlab.sh'.
%   id: Identification string.
%   props: A structure with any optional properties.
%     items: If specified, only load the dataset items in this list.
%     (others passed to script_array)
%
% Description:
%   This is a subclass of the script_array class. It will analyze and load
% items in a params_tests_dataset (and subclass) objects by partitioning it
% into num_runs pieces, to be loaded in parallel on multicore
% machines. Partitioned loading of databases can also be beneficial in
% serial (by setting prop 'parallel' to 0) for large datasets, such that
% problematic items (that crash) do not hinder the loading of the rest of
% the dataset.
%
% Returns a structure object with the following fields:
%	dataset, script_array.
%
% General methods of script_array_loaddb objects:
%   script_array_loaddb - Construct a new script_array_loaddb object.
%   runFirst	- Script run at the beginning
%   runLast	- Script run at the end
%   runJob	- Script to run with each job number sequence.
%   display	- Returns and displays the identification string.
%   get		- Gets attributes of this object and parents.
%   subsref	- Allows usage of . operator.
%
% Additional methods:
%   See methods('script_array_loaddb') and methods('script_array')
%
% See also: runFirst, runLast, runJob, script_array
%
% $Id: script_array_loaddb.m 1335 2012-04-19 18:04:32Z cengique $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2014/04/02

% Copyright (c) 2007-2014 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 % Called with no params, creates empty object
  a_s.dataset = params_tests_dataset;
  a_s = class(a_s, 'script_array_loaddb', script_array);
elseif isa(num_runs, 'script_array_loaddb') % copy constructor?
  a_s = num_runs;
else
  if ~ exist('props', 'var')
    props = struct;
  end
  
  % by default, run jobs in parallel
  props = ...
      mergeStructs(props, ...
                   struct('parallel', 1));

  a_s.dataset = a_dataset;

  % Create the object
  a_s = class(a_s, 'script_array_loaddb', ...
              script_array(num_runs, id, props));
end

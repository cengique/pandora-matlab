function obj = script_array(num_runs, id, props)

% script_array - Generic class that provides the scripts for a repetitive array job.
%
% Usage:
% obj = script_array(num_runs, id, props)
%
% Parameters:
%	num_runs: The number of times the runJob script should be evoked.
%	id: Identification string.
%	props: A structure with any optional properties.
%	  runJobFunc: A function name or handle to be used instead of default runJob.
%
% Description:
%   This is the base class for all script_array classes. Runs the runJob method as 
% num_runs many times.
%
% Returns a structure object with the following fields:
%	num_runs, id, props.
%
% Example:
% >> func1 = inline('x^2')
% >> runFirst(script_array(10, 'squares numbers up to 10'), struct('runJobFunc', func1))
% ans = [  1]    [  4]    [  9]    [ 16]    [ 25]    [ 36]    [ 49]    [ 64]    [ 81]    [100]
%
% General methods of script_array objects:
%   script_array - Construct a new script_array object.
%   runFirst	- Script run at the beginning
%   runLast	- Script run at the end
%   runJob	- Script to run with each job number sequence.
%   display	- Returns and displays the identification string.
%   get		- Gets attributes of this object and parents.
%   subsref	- Allows usage of . operator.
%
% Additional methods:
%   See methods('script_array')
%
% See also: runFirst, runLast, runJob
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/02/01

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 % Called with no params, creates empty object
  obj.num_runs = 0;
  obj.id = '';
  obj.props = struct;
  obj = class(obj, 'script_array');
elseif isa(num_runs, 'script_array') % copy constructor?
  obj = num_runs;
else
  if ~ exist('props', 'var')
    props = struct;
  end

  obj.num_runs = num_runs;
  obj.id = id;
  obj.props = props;

  % Create the object
  obj = class(obj, 'script_array');
end

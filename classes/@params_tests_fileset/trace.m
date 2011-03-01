function a_trace = trace(fileset, file_index)

% trace - Loads a raw trace given a file_index to this fileset.
%
% Usage:
% a_trace = trace(fileset, file_index)
%
% Description:
%
%   Parameters:
%	fileset: A params_tests_fileset.
%	file_index: Index of file in fileset.
%		
%   Returns:
%	a_trace: A trace object.
%
% See also: trace, params_tests_fileset
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/13

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

filename = getItem(fileset, file_index);
fullname = fullfile(fileset.path, filename);

props = get(fileset, 'props');
if isfield(props, 'param_rows')
  % Take parameter values from the specified parameter file,
  % in addition to the ones specified on data filenames.

  names_vals = parseGenesisFilename(fullname);
  if isfield(props, 'num_params')
    num_params = props.num_params;
  else
    num_params = size(names_vals, 1);
  end
  str_index = strmatch('trial', names_vals{1:num_params, 1});

  if length(str_index) < 1
    error(['Parameter lookup from rows is requested, but cannot find ' ...
	   'the "trial" parameter in the data filename ' fullname ]);
  end
  
  trial_num = names_vals{str_index, 2};
  trace_id = [ 't' num2str(trial_num) ];
else
  trace_id = num2str(file_index);
end

% Load a trace object
a_trace = trace(fullname, fileset.dt, fileset.dy, ...
		[fileset.id '(' trace_id ')'], get(fileset, 'props'));

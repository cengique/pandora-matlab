function obj = params_tests_fileset(file_pattern, dt, dy, id, props)

% params_tests_fileset - Description of a set of data files of raw data varying with parameter values.
%
% Usage:
% obj = params_tests_fileset(file_pattern, dt, dy, id, props)
%
% Description:
%   This is a subclass of params_tests_dataset. This class is used to
% generate params_tests_db objects and keep a connection to the raw
% data files. This class only keeps names of files and loads raw data
% files whenever it's requested. A database object can easily be
% generated using the convertion methods.  Most methods defined here
% can be used as-is, however some should be overloaded in subclasses.
% The specific methods are loadItemProfile.
%
% Parameters:
%   file_pattern: File pattern, or cell array of patterns, matching all 
%		files to be loaded.
%   dt: Time resolution [s]
%   dy: y-axis resolution [ISI (V, A, etc.)]
%   id: An identification string
%   props: A structure with any optional properties.
%     num_params: Number of parameters that appear in filenames
%     		(auto-detected by default; see props for
%     		parseFilenameNamesVals).
%     param_trial_name: Use this name on the filename as the 'trial' parameter.
%     param_row_filename: If given, the 'trial' parameter will be used
%		to address rows from this file and acquire parameters.
%     param_rows: Instead of a file, just give parameters in this matrix.
%     param_desc_filename: Contains the parameter range descriptions one per 
%		each row. The parameter names are acquired from this file.
%     param_names: Cell array of parameter names corresponding to the 
%		param_row_filename columns can be specified as an alternative to
%		specifying param_desc_filename. These names are not for the 
%		parameters present in the data filename.
%     profile_method_name: It can be one of the profile-creating methods in this
%		class. E.g., 'trace_profile', 'srp_trace_profile',
%		etc. OBSOLOTE: see loadItemProfileFunc prop in
%		params_tests_dataset.
%     (Others passed to params_tests_dataset and parseFilenameNamesVals)
%		
% Returns a structure object with the following fields:
%   params_tests_dataset,
%   path: The pathname to files.
%
% General operations on params_tests_fileset objects:
%   params_tests_fileset - Construct a new object.
%   loadItemProfile 	 - Implements the specific way to load raw data 
%			   traces for this fileset.
%   testNames		 - Returns test names for this fileset. Uses
%			   loadItemProfile to load the raw data.
%   paramNames		 - Returns parameter names for this fileset.
%   itemResultsRow	 - Uses loadItemProfile to load raw data and
%			   queries it to get parameters and results.
%   trace		- Load a trace corresponding to fileset entry.
%   trace_profile	- Load a trace_profile corresponding to fileset entry.
%   display		- Returns and displays the identification string.
%   get			- Gets attributes of this object and parents.
%   subsref		- Allows usage of . operator.
%   
%
% Additional methods:
%	See methods('params_tests_fileset')
%
% See also: params_tests_db, tests_db, params_tests_dataset
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/09

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 % Called with no params
  obj.path='';
  obj = class(obj, 'params_tests_fileset', params_tests_dataset);
elseif isa(file_pattern, 'params_tests_fileset') % copy constructor?
  obj = file_pattern;
else

  if ~ exist('props', 'var')
    props = struct([]);
  end

  % First find all filenames matching the pattern

  % Multiple patterns in cell array allowed
  if iscell(file_pattern)
    num_patterns = length(file_pattern);

    % Separate filename components
    [obj.path, name, ext, ver] = fileparts(file_pattern{1});
  else
    num_patterns = 1;

    % Separate filename components
    [obj.path, name, ext] = fileparts(file_pattern);
  end

  % Remove the last directory if the subdirs option is given
  if isfield(props, 'isSubdirs')
    [obj.path, name, ext, ver] = fileparts(obj.path);
  end

  % Loop over patterns (or do one pattern only)
  total_entries = 0;
  for pattern_num = 1:num_patterns
    if iscell(file_pattern)
      this_pattern = file_pattern{pattern_num};
    else
      this_pattern = file_pattern;
    end

    filestruct = dir(this_pattern);
    entries = size(filestruct, 1);

    % if there's a subdir, prepend it to the filename
    names = { filestruct(:).name };
    if isfield(props, 'isSubdirs')
      [path, name, ext, ver] = fileparts(this_pattern);
      [path, subdir_name, ext, ver] = fileparts(path);

      names = cellfun(@(x)sprintf([subdir_name '/%s'], x), names, 'UniformOutput', false);
    end

    [filenames{total_entries + (1:entries)}] = deal(names{:});
    total_entries = total_entries + entries;
    if entries == 0
      warning([ 'Pattern "' this_pattern '" matched no files.' ]);
    end
  end

  if total_entries == 0
    warning([ '*** Fatal: No files in dataset!!! ***' ]);
  end


  % Read parameters if specified
  if isfield(props, 'param_row_filename')
    param_rows = dlmread(props.param_row_filename);
    props.param_rows = param_rows(2:end, 1:param_rows(1, 2)); % strip off excess columns

    % Check for names
    if ~ isfield(props, 'param_names')
      % Then read the parameter description file to get the names
      if ~ isfield(props, 'param_desc_filename')
	error(['If param_row_filename is specified, one needs to specify ' ...
	      ' a method to get parameter names. Use either param_names ' ...
	       'or param_desc_filename.']);
      end
      param_names = textread(props.param_desc_filename, '%s %*s %*s %*s', ...
			     'commentstyle', 'shell');
      props.param_names = param_names';
    end
  end

  % then create the object 
  obj = class(obj, 'params_tests_fileset', ...
	      params_tests_dataset(filenames, dt, dy, id, props));

end


function obj = params_tests_fileset(file_pattern, dt, dy, id, props)

% params_tests_fileset - Description of a set of data files of
%		raw data varying with parameter values.
%
% Usage:
% obj = params_tests_fileset(file_pattern, dt, dy, id, props)
%
% Description:
%   This is a subclass of params_tests_dataset. This class is used to generate 
% params_tests_db objects and keep 
% a connection to the raw data files. This class only keeps names of
% files and loads raw data files whenever it's requested. A database
% object can easily be generated using the convertion methods.
% Most methods defined here can 
% be used as-is, however some should be overloaded in subclasses. 
% The specific methods are loadItemProfile.
%
%   Parameters:
%	file_pattern: File pattern matching all files to be loaded.
%	dt: Time resolution [s]
%	dy: y-axis resolution [ISI (V, A, etc.)]
%	id: An identification string
%	props: A structure with any optional properties.
%		num_params: Number of parameters that appear in filenames.
%		param_row_filename: If given, the 'trial' parameter will be used
%			to address rows from this file and acquire parameters.
%		param_desc_filename: Contains the parameter range descriptions one per 
%			each row. The parameter names are acquired from this file.
%		param_names: Cell array of parameter names corresponding to the 
%			param_row_filename columns can be specified as an alternative to
%			specifying param_desc_filename. These names are not for the 
%			parameters present in the data filename.
%		(See parent classes and cip_trace object for more props)
%		
%   Returns a structure object with the following fields:
%	params_tests_dataset,
%	path: The pathname to files,
%	filenames: Cell array of filenames corresponding to DB entries.
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
% See also: params_tests_db, tests_db, test_variable_db (N/I)
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/09

if nargin == 0 %# Called with no params
  obj.path='';
  obj = class(obj, 'params_tests_fileset', params_tests_dataset);
elseif isa(file_pattern, 'params_tests_fileset') %# copy constructor?
  obj = file_pattern;
else

  if ~ exist('props')
    props = struct([]);
  end


  %# First find all filenames matching the pattern
  
  %# Separate filename components
  [obj.path, name, ext, ver] = fileparts(file_pattern);

  filestruct = dir(file_pattern);
  entries = size(filestruct, 1);
  [filenames{1:entries}] = deal(filestruct(:).name);

  %# Read parameters if specified
  if isfield(props, 'param_row_filename')
    param_rows = dlmread(props.param_row_filename);
    props.param_rows = param_rows(2:end, 1:param_rows(1, 2)); %# strip off excess columns

    %# Check for names
    if ~ isfield(props, 'param_names')
      %# Then read the parameter description file to get the names
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

  %# then create the object 
  obj = class(obj, 'params_tests_fileset', ...
	      params_tests_dataset(filenames, dt, dy, id, props));

end


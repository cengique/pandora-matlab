function obj = params_tests_fileset(file_pattern, dt, dy, id, props)

% params_tests_fileset - Description of a set of data files of
%		raw data varying with parameter values.
%
% Usage:
% obj = params_tests_fileset(file_pattern, dt, dy, id, props)
%
% Description:
%   This class is used to generate params_tests_db objects and keep 
% a connection to the raw data files. This class only keeps names of
% files and loads raw data files whenever it's requested. A database
% object can easily be generated using the convertion methods.
% Most methods defined here can 
% be used as-is, however some should be overloaded in subclasses. 
% The specific methods are loadFileProfile.
%
%   Parameters:
%	file_pattern: File pattern matching all files to be loaded.
%	dt: Time resolution [s]
%	dy: y-axis resolution [ISI (V, A, etc.)]
%	id: An identification string
%	props: A structure any optional properties.
%		channel: Channel to read from in data files (default = 1).
%		trace_start: Starting of trace in file (default = 1).
%		type: type of file (default = '')
%		
%   Returns a structure object with the following fields:
%	params_tests_db,
%	path: The pathname to files,
%	filenames: Cell array of filenames corresponding to DB entries,
%	dt, dy, id, props (see above).
%
% General operations on params_tests_fileset objects:
%   params_tests_fileset - Construct a new object.
%   params_tests_db	 - Generate a db by calling fileResultsRow for 
%			   each file.
%   loadFileProfile 	 - Implements the specific way to load raw data 
%			   traces for this fileset.
%   testNames		 - Returns test names for this fileset. Uses
%			   loadFileProfile to load the raw data.
%   paramNames		 - Returns parameter names for this fileset.
%   fileResultsRow	 - Uses loadFileProfile to load raw data and
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
  obj.dt=1;
  obj.dy=1;
  obj.id = '';
  obj.props = struct([]);
  obj.path='';
  obj.filenames = {};
  obj.dy='';
  obj = class(obj, 'params_tests_fileset');
elseif isa(file_pattern, 'params_tests_fileset') %# copy constructor?
  obj = file_pattern;
else

  if ~ exist('props')
    props = struct([]);
  end

  obj.dt = dt;
  obj.dy = dy;
  obj.id = id;
  obj.props = props;

  %# First find all filenames matching the pattern
  
  %# Separate filename components
  [obj.path, name, ext, ver] = fileparts(file_pattern);
  
  filestruct = dir(file_pattern);
  entries = size(filestruct, 1);
  [obj.filenames{1:entries}] = deal(filestruct(:).name);

  %# then create the object 
  obj = class(obj, 'params_tests_fileset');

end


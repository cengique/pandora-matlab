function obj = params_tests_fileset(file_pattern, dt, dy, id, props)

% params_tests_fileset - Description of a set of data files of
%		raw data varying with parameter values.
%
% Usage:
% obj = params_tests_fileset(file_pattern, dt, dy, id, props)
%
% Description:
%   This class is used to generate params_tests_db objects and keep 
% a connection to the raw data files.
%
%   Parameters:
%	file_pattern: File pattern mathing all files to be loaded.
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
%	dt, dy, props (see above).
%
% General operations on params_tests_fileset objects:
%   params_tests_fileset - Construct a new object.
%   params_tests_db	 - Generate a db by calling fileResultsRow for 
%			  each file.
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
  obj.filenames = {};
  obj.dt=1;
  obj.dy=1;
  obj.props = struct([]);
  obj = class(obj, 'params_tests_fileset');
elseif isa(file_pattern, 'params_tests_fileset') %# copy constructor?
  obj = file_pattern;
else

  if ~ exist('props')
    props = struct([]);
  end

  obj.dt = dt;
  obj.dy = dy;
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


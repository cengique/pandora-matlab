function obj = params_tests_dataset(list, dt, dy, id, props)

% params_tests_dataset - Contains a set of data objects or files of raw data varying with parameter values.
%
% Usage:
% obj = params_tests_dataset(list, dt, dy, id, props)
%
% Description:
%   This is an abstract base class for keeping dataset information separate
% from the parameters-results database (params_tests_db). The list contents
% can be filenames or objects (such as cip_traces) from which to get the raw data.
% The dataset should have all the necessary information to create a db when
% needed. This is an abstract class, thet it it cannot act on its own. Only 
% fully implemented subclasses can actually hold datasets. See methods below.
%
%   Parameters:
%	list: Array of dataset items (filenames, objects, etc.).
%	dt: Time resolution [s]
%	dy: y-axis resolution [integral V, A, etc.]
%	id: An identification string.
%	props: A structure with any optional properties.
%		type: type of file (default = '')
%		
%   Returns a structure object with the following fields:
%	list, dt, dy, id, props (see above).
%
% General operations on params_tests_dataset objects:
%   params_tests_dataset - Construct a new object.
%   params_tests_db	 - Generate a db by calling readDBItems.
%   readDBItems		 - Loops over all items, reading them with loadItemProfile.
%   loadItemProfile 	 - Load raw data traces (needs to be implemented in subclass).
%   testNames		 - Returns test names for this fileset. Uses
%			   loadItemProfile to load the raw data.
%   paramNames		 - Returns parameter names for this fileset.
%   itemResultsRow	 - Uses loadItemProfile to load raw data and
%			   queries it to get parameters and results.
%   display		- Returns and displays the identification string.
%   get			- Gets attributes of this object and parents.
%   subsref		- Allows usage of . operator.
%   
%
% Additional methods:
%	See methods('params_tests_dataset')
%
% See also: params_tests_db, params_tests_fileset, cip_traces_dataset
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/02

if nargin == 0 %# Called with no params
  obj.dt=1;
  obj.dy=1;
  obj.id = '';
  obj.props = struct([]);
  obj.path='';
  obj.list = {};
  obj.dy='';
  obj = class(obj, 'params_tests_dataset');
elseif isa(list, 'params_tests_dataset') %# copy constructor?
  obj = list;
else

  if ~ exist('props')
    props = struct([]);
  end

  obj.list = list;
  obj.dt = dt;
  obj.dy = dy;
  obj.id = id;
  obj.props = props;

  %# then create the object 
  obj = class(obj, 'params_tests_dataset');

end


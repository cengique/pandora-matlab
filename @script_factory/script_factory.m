function obj = script_factory(num_scripts, out_name, id, props)

% script_factory - Generic class to automatically create a set of scripts.
%
% Usage:
% obj = script_factory(num_scripts, out_name, id, props)
%
%   Parameters:
%	num_scripts: Number of scripts to create.
%	out_name: The file name for the output scripts. A '%d' in the
%		   filename corresponds to the script number.
%	id: Identification string.
%	props: A structure with any optional properties.
%
% Description:
% This is the base class for all script_factory classes.
%
% Returns a structure object with the following fields:
%	num_scripts, out_name, id, props.
%
% General methods of script_factory objects:
%   script_factory - Construct a new script_factory object.
%   writeScripts  - Create the scripts.
%   display	- Returns and displays the identification string.
%   get		- Gets attributes of this object and parents.
%   subsref	- Allows usage of . operator.
%
% Additional methods:
%   See methods('script_factory')
%
% See also: script_factory/writeScripts
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/11/28

if nargin == 0 %# Called with no params, creates empty object
  obj.num_scripts = 0;
  obj.out_name = '';  
  obj.id = '';
  obj.props = struct;
  obj = class(obj, 'script_factory');
elseif isa(num_scripts, 'script_factory') %# copy constructor?
  obj = num_scripts;
else
  if ~ exist('props')
    props = struct;
  end

  obj.num_scripts = num_scripts;
  obj.out_name = out_name;
  obj.id = id;
  obj.props = props;

  %# Create the object
  obj = class(obj, 'script_factory');
end

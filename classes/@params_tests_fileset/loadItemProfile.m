function a_profile = loadItemProfile(fileset, file_index)

% loadItemProfile - Loads a profile object from a raw data file in the fileset.
%
% Usage:
% a_profile = loadItemProfile(fileset, file_index)
%
% Description:
%   Subclasses should overload this function to load the specific profile
% object they desire. The profile class should define a getResults method
% which is used in the itemResultsRow method.
%
%   Parameters:
%	fileset: A params_tests_fileset.
%	file_index: Index of file in fileset.
%		
%   Returns:
%	a_profile: A profile object that implements the getResults method.
%
% See also: itemResultsRow, params_tests_fileset, paramNames, testNames
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/14

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

props = get(fileset, 'props');

if isfield(props, 'profile_method_name')
  a_profile = ...
      feval(props.profile_method_name, trace(fileset, file_index));
else
  % Load a trace_profile object
  a_profile = trace_profile(fileset, file_index);
end
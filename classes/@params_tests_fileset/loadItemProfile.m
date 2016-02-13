function a_profile = loadItemProfile(fileset, file_index, props)

% loadItemProfile - Loads a profile object from a raw data file in the fileset.
%
% Usage:
% a_profile = loadItemProfile(fileset, file_index)
%
% Parameters:
%   fileset: A params_tests_fileset.
%   file_index: Index of file in fileset.
%   props: A structure with any optional properties.
%     (passed to loadItemProfileFunc)
%		
% Returns:
%   a_profile: A results_profile object that implements the getResults method.
%
% Description:
%   First it looks for the prop loadItemProfileFunc to load the
% profile. Otherwise, it assumes fileset items can be loaded as traces. and
% runs props.profile_method_name if available, or simply creates a
% trace_profile object. Subclasses should overload this function to load the
% specific profile object they desire. The profile class should define a
% getResults method which is used in the params_tests_dataset/itemResultsRow
% method.
%
% See also: results_profile, params_tests_dataset/itemResultsRow
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/14

% Copyright (c) 2007-2014 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

props = mergeStructs(defaultValue('props', struct), get(fileset, 'props'));

% look if custom function defined
if isfield(props, 'loadItemProfileFunc')
  % get params from file (if any)
  params_row = getItemParams(fileset, file_index);

  % Load any profile object
  a_profile = feval(props.loadItemProfileFunc, fileset, file_index, ...
                    params_row, props);
else
  % old code, assumes fileset elements are loadable traces
  if isfield(props, 'profile_method_name')
    a_profile = ...
        feval(props.profile_method_name, trace(fileset, file_index));
  else
    % Load a trace_profile object
    a_profile = trace_profile(fileset, file_index);
  end
end
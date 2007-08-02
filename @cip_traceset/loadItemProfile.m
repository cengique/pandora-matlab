function a_profile = loadItemProfile(dataset, index)

% loadItemProfile - Loads a profile object from a raw data item in the dataset.
%
% Usage:
% a_profile = loadItemProfile(dataset, index)
%
% Description:
%   Subclasses should overload this function to load the specific profile
% object they desire. The profile class should define a getResults method
% which is used in the itemResultsRow method.
%
%   Parameters:
%	dataset: A params_tests_dataset.
%	index: Index of item in dataset.
%		
%   Returns:
%	a_profile: A profile object that implements the getResults method.
%
% See also: itemResultsRow, params_tests_dataset, paramNames, testNames
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/14

%# Load a trace_profile object
a_profile = cip_trace_profile(dataset, index);
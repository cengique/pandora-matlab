function a_profile = loadItemProfile(traceset, trace_index)

% loadItemProfile - Loads a cip_trace_profile object from a raw data file in the traceset.
%
% Usage:
% a_profile = loadItemProfile(traceset, trace_index)
%
% Description:
%
%   Parameters:
%	traceset: A physiol_cip_traceset object.
%	trace_index: Index of file in traceset.
%		
%   Returns:
%	a_profile: A profile object that implements the getResults method.
%
% See also: itemResultsRow, params_tests_fileset, paramNames, testNames
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/14

%# Load a trace_profile object
a_profile = cip_trace_profile(traceset, trace_index);

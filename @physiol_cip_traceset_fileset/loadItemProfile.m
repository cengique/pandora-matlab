function a_profile = loadItemProfile(fileset, neuron_id, trace_index)

% loadItemProfile - Loads a cip_trace_profile object from a raw data file in the fileset.
%
% Usage:
% a_profile = loadItemProfile(fileset, neuron_id, trace_index)
%
% Description:
%
%   Parameters:
%	fileset:     A physiol_cip_traceset object.
%       neuron_id :  tells which item in fileset (corresponds to cells_filename) to use grab the cell information 
%	trace_index: Index of file in traceset.
%		
%   Returns:
%	a_profile: A profile object that implements the getResults method.
%
% See also: itemResultsRow, params_tests_fileset, paramNames, testNames
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/14 and Tom Sangrey

%# Load a trace_profile object
traceset=getItem(fileset,neuron_id);
a_profile = loadItemProfile(traceset, trace_index);

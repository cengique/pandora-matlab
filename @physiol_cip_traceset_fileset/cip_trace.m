function a_cip_trace = cip_trace(fileset, traceset_index, trace_index)

% cip_trace - Loads a cip_trace object from a raw data file in the fileset.
%
% Usage:
% a_cip_trace = cip_trace(fileset, traceset_index, trace_index)
%
% Description:
%
%   Parameters:
%	fileset: A physiol_cip_traceset_fileset object.
%       traceset_index: Index of traceset item in this fileset (corresponds 
%			to row in cells_filename) to find the cell information.
%	trace_index: Index of item in the traceset.
%		
%   Returns:
%	a_cip_trace: A cip_trace object that holds the raw data.
%
% See also: loadItemProfile, physiol_cip_traceset/cip_trace
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/07/13

%# Delegate to the traceset to load the cip_trace object
a_cip_trace = cip_trace(getItem(fileset, traceset_index), trace_index);

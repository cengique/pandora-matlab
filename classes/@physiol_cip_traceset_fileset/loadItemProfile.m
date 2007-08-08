function a_profile = loadItemProfile(fileset, traceset_index, trace_index)

% loadItemProfile - Loads a cip_trace_profile object from a raw data file in the fileset.
%
% Usage:
% a_profile = loadItemProfile(fileset, traceset_index, trace_index)
%
% Description:
%
%   Parameters:
%	fileset:     A physiol_cip_traceset object.
%       traceset_index :  Index of traceset item in this fileset (corresponds 
%			to row in cells_filename) to use grab the cell information.
%	trace_index: Index of item in the traceset.
%		
%   Returns:
%	a_profile: A profile object that implements the getResults method.
%
% See also: itemResultsRow, params_tests_fileset, paramNames, testNames
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/14 and Tom Sangrey

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

%# Load a trace_profile object
traceset = getItem(fileset, traceset_index);
a_profile = loadItemProfile(traceset, trace_index);

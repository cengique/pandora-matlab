function names_vals = parseGenesisFilename(raw_filename)

% parseGenesisFilename - (OBSOLETE, see parseFilenameNamesVals) Parses the GENESIS filename to get names and values of simulation parameters.
% Usage:
% names_vals = parseGenesisFilename(filename)
%
% Description:
%	Parameters:
%		filename: GENESIS filename (no need to exist)
%		
%	Returns:
%		names_vals: A two-column cell array with names and values.
%
% See also: parseFilenameNamesVals
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/03/10

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% delegates to newly named function:
  names_vals = parseFilenameNamesVals(raw_filename, struct('skipNum', -1, 'namesFirst', 0));
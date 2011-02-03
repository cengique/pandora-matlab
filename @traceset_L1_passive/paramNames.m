function param_names = paramNames(fileset, item)

% paramNames - Returns trace number as param.
%
% Usage:
% param_names = paramNames(fileset, item)
%
% Description:
%
%   Parameters:
%	fileset: A params_tests_fileset.
%	item: (Optional) If given, read param names by loading item at this index.
%		
%   Returns:
%	params_names: Cell array with ordered parameter names.
%
% See also: params_tests_fileset, paramNames, testNames
%
% $Id: paramNames.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/10

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('item', 'var')
  item = 1;
end

param_names = {'TraceNum'};

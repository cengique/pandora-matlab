function new_struct = prefixStruct(a_struct, prefix_str)

%  prefixStruct - Adds the given prefix to each of the field names in the structure.
%
% Usage:
% new_struct = prefixStruct(a_struct, prefix_str)
%
% Parameters:
%	a_struct: A structure.
%	prefix_str: A string to be prefixed to each field name.
%
% Returns:
% 	new_struct: The new structure.
%
% Description:
%
% Example: 
% prefixStruct( struct('bye', 1), 'hello');
%  => struct('hellobye', 1)
%
% $Id: prefixStruct.m,v 1.2 2005/05/08 00:03:02 cengiz Exp $
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/22

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

names = fieldnames(a_struct);
for name = names'
  name = name{1};
  new_struct.([ prefix_str name ]) = a_struct.(name);
end


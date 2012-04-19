function a_str = struct2str(a_struct, props)

% struct2str - Converts numerical structure into a single-line string.
%
% Usage:
% a_str = struct2str(a_struct, props)
%
% Parameters:
%   a_struct: Structure that has names pointing to numerical values.
%   props: A structure with any optional properties.
%		
% Returns:
%   a_str: A string that contains structure fields and value like in 'name1_val1_name2_val2_...'
%
% Description:
%
% See also: cell2TeX
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/05/17

% Copyright (c) 20011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

a_str = '';
names = fieldnames(a_struct)';
prefix = '';
for name = names
  name = name{1};
  a_str = [ a_str prefix name '_' num2str(a_struct.(name)) ];
  prefix = '_';
end

function string2File(string, filename, props)

% string2File - Writes string verbatim into a file.
%
% Usage:
% string2File(string, filename, props)
%
% Description:
%
%   Parameters:
% 	string: To be written into file.
%	filename: The file to be created.
%	props: A structure with any optional properties.
%	  append: If 1, append to existing file.
%		
%   Returns:
%
% See also: cell2TeX
%
% $Id: string2File.m,v 1.1 2004/12/13 21:38:23 cengiz Exp $
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/10

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

if exist('filename', 'var') && ~ isempty(filename)
  if isfield(props, 'append')
    write_mode = 'a';
  else
    write_mode = 'w';
  end
  fp = fopen(filename, write_mode);
  fprintf(fp, '%s', string);
  fclose(fp);
end

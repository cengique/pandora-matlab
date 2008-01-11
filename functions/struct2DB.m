function a_tests_db = struct2DB(a_struct, props)

% struct2DB - Converts a structure array to a tests_db object.
%
% Usage:
% a_tests_db = struct2DB(a_struct, props)
%
% Description:
%   Field names become column names in the DB.
%
%   Parameters:
% 	a_struct: A structure to convert.
%	props: A structure with any optional properties, passed to tests_db.
%		
%   Returns:
%	a_tests_db: A tests_db object.
%
% See also: 
%
% $Id: struct2DB.m,v 1.5 2006/01/18 22:10:28 cengiz Exp $
% Author: Cengiz Gunay <cgunay@emory.edu>, 2008/01/11

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props')
  props = struct([]);
end

a_tests_db = ...
    tests_db(cell2mat(struct2cell(a_struct))', fieldnames(a_struct)', {}, ...
             'DB from a structure.', props);
function a_chans_db = chans_db(data, col_names, channel_info, id, props)

% chans_db - A database of channel activation and kinetics.
%
% Usage:
% a_chans_db = chans_db(data, col_names, orig_db, crit_db, id, props)
%
% Description:
%   This is a subclass of tests_db. Channel tables can be imported from
% Genesis using the utils/chanTables2DB script.
%
%   Parameters:
%	data: Database contents.
%	col_names: The channel variable names.
%	channel_info: Structure that holds scalar data elements such as Gbar.
%	id: An identifying string.
%	props: A structure with any optional properties.
%		
%   Returns a structure object with the following fields:
%	tests_db, channel_info, props.
%
% General operations on chans_db objects:
%   chans_db		- Construct a new chans_db object.
%
% Additional methods:
%	See methods('chans_db')
%
% See also: tests_db, chanTables2DB
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2007/06/26

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

if nargin == 0 %# Called with no params
   a_chans_db.channel_info = struct;
   a_chans_db = class(a_chans_db, 'chans_db', tests_db);
 elseif isa(data, 'chans_db') %# copy constructor?
   a_chans_db = data;
 else %# Create a new object

   if ~ exist('props')
     props = struct([]);
   end

   a_chans_db.channel_info = channel_info;

   if isa(data, 'tests_db')
     a_tests_db = data;
     a_tests_db.id = id;
     a_tests_db.props = mergeStructs(props, a_tests_db.props);
   else
     tests_db(data, col_names, {}, id, props);
   end
   
   a_chans_db = class(a_chans_db, 'chans_db', a_tests_db);
end


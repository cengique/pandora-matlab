function a_ts = getItemTraceset(cellset, cell_index)

% getItemTraceset - Loads and returns a traceset_L1_passive object.
%
% Usage:
% a_ts = getItemTraceset(cellset, cell_index)
%
%   Parameters:
%	cellset: A cellset object.
%	cell_index: Index of item in cellset.
%		
%   Returns:
%	a_ts: A voltage_clamp object.
%
% Description:
%
% See also: traceset_L1_passive
%
% $Id: getItemTraceset.m 818 2007-08-28 20:28:51Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/02/04

% Copyright (c) 2011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

cellset_props = get(cellset, 'props');

basedir = getFieldDefault(cellset_props, 'docDir', '');

a_ts = getItem(cellset, cell_index);

% if a directory, load the traceset_L1_passive object
if ischar(a_ts)
  pwd = cd;
  eval(['cd basedir; ' a_ts '; cd pwd']);
end

assert(isa(a_ts, 'traceset_L1_passive'));

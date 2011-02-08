function a_cset = cellset_L1(cells_list, treatments, cellset_id, props)

% cellset_L1 - Dataset of files from multiple cells.
%
% Usage:
% a_cset = cellset_L1(cells_list, treatments, cellset_id, props)
%
% Parameters:
%   cells_list: Cell array of cell directory names or traceset_L1_passive objects.
%   treatments: Structure with protocol names and corresponding cell lists.
%   cellset_id: Name for this set.
%   props: A structure with any optional properties.
%     docDir: Directory to find the files.
%     protZoom: Structure connecting protocol names to axisLimits
%     		quadruples for proper zooming into trace plots.
%     (All other props are passed to ...)
%		
%   Returns a structure object with the following fields:
%	params_tests_dataset,
%	treatments.
%
% Description:
%   This is a subclass of params_tests_dataset. 
%
% Example:
% > a_cs = cellset_L1({a_ts, a_ts2}, 'my neurons',
% 				struct('baseDir', 'C:/myfiles/'));
% would make a traceset out of two tracests a_ts and a_ts2.
%
% General operations on cellset_L1 objects:
%   cellset_L1 - Construct a new object.
%   loadItemProfile	- Builds a data_L1_passive for each trace in the set.
%
% Additional methods:
%	See methods('cellset_L1'), and 
%	    methods('params_tests_dataset').
%
% See also: traceset_L1_passive, data_L1_passive, params_tests_dataset, params_tests_db
%
% $Id: cellset_L1.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/02/04

% Copyright (c) 2011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

if nargin == 0 % Called with no params
  a_cset.treatments = struct;
  a_cset = class(a_cset, 'cellset_L1', params_tests_dataset);
elseif isa(cells_list, 'cellset_L1') % copy constructor?
  a_cset = cells_list;
else
  props = defaultValue('props', struct);
  
  a_cset.treatments = treatments;
  
  % TODO: run through cells and enumerate them based on unique identifiers
  
  % Create the object 
  a_cset = class(a_cset, 'cellset_L1', ...
                 params_tests_dataset(cells_list, [], [], ...
                                      cellset_id, props));
end


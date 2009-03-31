function a_cip_trace = ctFromRows(a_pbundle, a_db, cip_levels, props)

% ctFromRows - Loads a cip_trace object from a raw data file in the a_pbundle.
%
% Usage:
% a_cip_trace = ctFromRows(a_pbundle, a_db|traceset_idx, cip_levels, props)
%
% Description:
%
%   Parameters:
%	a_pbundle: A physiol_cip_traceset_fileset object.
%	a_db: A DB created by this fileset to read the traceset indices from.
%	traceset_idx: A column vector with traceset indices.
%	cip_levels: A column vector of CIP-levels to be loaded.
%	props: A structure with any optional properties.
%	  traces: column vector of trace indices to load.
%	  showParamsList: Cell array of params or treatments to include in the id field.
%		
%   Returns:
%	a_cip_trace: One or more cip_trace object that holds the raw data.
%
% See also: loadItemProfile, physiol_cip_traceset/cip_trace
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/07/13

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~exist('props', 'var')
  props = struct;
end

traceset_vals = item2TracesetIndex( a_pbundle, a_db );

p_db = get(a_pbundle, 'db');
rows = anyRows(onlyRowsTests(p_db, ':', 'TracesetIndex'), traceset_vals);

if isfield(props, 'traces') 
  rows = rows & anyRows(onlyRowsTests(p_db, ':', 'ItemIndex'), props.traces);
end

if ~ isempty(cip_levels) 
  rows = rows & anyRows(onlyRowsTests(p_db, ':', 'pAcip'), cip_levels);
end

a_cip_trace = cip_trace(get(a_pbundle, 'dataset'), ...
			onlyRowsTests(p_db, rows, ':'), [], props);

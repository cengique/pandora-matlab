function a_cip_trace = ctFromRows(a_pbundle, a_db, cip_levels, props)

% ctFromRows - Loads a cip_trace object from a raw data file in the a_pbundle.
%
% Usage:
% a_cip_trace = ctFromRows(a_pbundle, a_db/traceset_idx, cip_levels, props)
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

if ~exist('props')
  props = struct;
end

if isa(a_db, 'tests_db')
  traceset_vals = get(onlyRowsTests(a_db, ':', 'TracesetIndex'), 'data');
else
  traceset_vals = a_db;
end

p_db = get(a_pbundle, 'db');
rows = onlyRowsTests(p_db, ':', 'TracesetIndex') == traceset_vals;

if isfield(props, 'traces') 
  rows = rows & onlyRowsTests(p_db, ':', 'ItemIndex') == props.traces;
end

if ~ isempty(cip_levels) 
  rows = rows & onlyRowsTests(p_db, ':', 'pAcip') == cip_levels;
end

a_cip_trace = cip_trace(get(a_pbundle, 'dataset'), ...
			onlyRowsTests(p_db, rows, ':'), [], props);

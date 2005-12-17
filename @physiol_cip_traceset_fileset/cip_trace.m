function a_cip_trace = cip_trace(fileset, traceset_index, trace_index, props)

% cip_trace - Loads a cip_trace object from a raw data file in the fileset.
%
% Usage 1:
% a_cip_trace = cip_trace(fileset, traceset_index, trace_index, props)
%
% Usage 2:
% a_cip_trace = cip_trace(fileset, a_db, [], props)
%
% Description:
%
%   Parameters:
%	fileset: A physiol_cip_traceset_fileset object.
%       traceset_index: Index of traceset item in this fileset (corresponds 
%			to row in cells_filename) to find the cell information.
%	trace_index: Index of item in the traceset.
%	a_db: A DB created by this fileset to read the traceset and item indices from.
%	props: A structure with any optional properties.
%	  showParamsList: Cell array of params or treatments to include in the id field.
%		
%   Returns:
%	a_cip_trace: One or more cip_trace object that holds the raw data.
%
% See also: loadItemProfile, physiol_cip_traceset/cip_trace
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/07/13

if ~exist('props')
  props = struct;
end

if isa(traceset_index, 'tests_db')
  a_db = traceset_index;
  col_data = get(onlyRowsTests(a_db, ':', {'TracesetIndex', 'ItemIndex'}), 'data');
  num_rows = dbsize(a_db, 1);
  a_cip_trace = repmat(cip_trace, 1, num_rows);
  for row_num = 1:num_rows
    a_cip_trace(row_num) = ...
	cip_trace(fileset, col_data(row_num, 1), col_data(row_num, 2), props);
  end
else
  num_traces = length(trace_index);
  if num_traces > 1
    [ a_cip_trace(1:num_traces) ] = deal(cip_trace);
    for trace_num = 1:num_traces
      %# recurse 
      a_cip_trace(trace_num) = cip_trace(fileset, traceset_index, ...
					 trace_index(trace_num), props);
    end
  else
    %# Delegate to the traceset to load the cip_trace object
    a_cip_trace = cip_trace(getItem(fileset, traceset_index), trace_index, ...
			    mergeStructs(props, struct('TracesetIndex', traceset_index)));
  end
end

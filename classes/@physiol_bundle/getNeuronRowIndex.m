function a_row_index = getNeuronRowIndex(a_bundle, traceset_index, props)

% getNeuronRowIndex - Returns the neuron index from bundle.
%
% Usage:
% a_row_index = getNeuronRowIndex(a_bundle, traceset_index, props)
%
% Description:
%
% Parameters:
%	a_bundle: A physiol_bundle object.
%	traceset_index: The TracesetIndex number of neuron, or a DB row containing this.
%	props: A structure with any optional properties.
%		
% Returns:
%	a_row_index: A row index of neuron in a_bundle.joined_db.
%
% Example: see dataset_db_bundle/getNeuronRowIndex.
%
% See also: dataset_db_bundle/getNeuronRowIndex
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/06/09

if ~exist('props')
  props = struct;
end

if isa(traceset_index, 'tests_db')
  traceset_index = get(onlyRowsTests(traceset_index, 1, 'TracesetIndex'), 'data');
end

joined_db = get(a_bundle, 'joined_db');

a_row_index = find(joined_db(:, 'TracesetIndex') == traceset_index);

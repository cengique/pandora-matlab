function all_ranks_db = bestMatchAllNeurons(p_bundle, joined_db, props)

% bestMatchAllNeurons - Finds the best match among given database for each physiology neuron.
%
% Usage:
% all_ranks_db = bestMatchAllNeurons(p_bundle, joined_db, props)
%
% Description:
%   Returns a database of best matching entries from joined_db for each
% entry in p_bundle.joined_control_db.
%
%   Parameters:
%	p_bundle: A physiol_bundle object.
%	joined_db: A database with neuron representations to rank against
%			neurons.
%	props: A structure with any optional properties.
%	       (passed to rankMatching)
%		
%   Returns:
%	all_ranks_db: DB of best matching from joined_db. Each row
%		corresponds to p_bundle.joined_control_db rows.
%
%   Example:
% >> all_ranks_db = ...
%	bestMatchAllNeurons(constrainedMeasuresPreset(pbundle2, 6), mbundle_maxcond.joined_db)
% >> plotXRows(all_ranks_db, 'Distance', 'maxcond DB distance per neuron', 'maxcond', ...
%              struct('LineStyle', '-', 'quiet', 1, 'PaperPosition', [0 0 4 3]))
%
% See also: tests_db/rankMatching, tests_db/matchingRow
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2007/05/24

  if ~exist('props', 'var')
    props = struct;
  end
  
  num_neurons = dbsize(p_bundle.joined_control_db, 1);

  % Do initial ranking to get number of columns
  no_rows_ranks = ...
      rankMatching(joined_db, ...
                   matchingRow(p_bundle, 25), mergeStructs(props, struct('topRows', 0)));
  
  %# add the traceset_index
  all_ranks_db = ...
      allocateRows(addColumns(no_rows_ranks, ...
                              {'TracesetIndex'}, repmat(nan, 0, 1)), num_neurons);

  % calculate all best matches in joined_db
  % Do all neurons
  for neuron_num = 1:num_neurons
    traceset_index = p_bundle.joined_control_db(neuron_num, 'TracesetIndex').data;
    a_r = rankMatching(joined_db, matchingRow(p_bundle, traceset_index), ...
                       mergeStructs(props, struct('topRows', 1)));
    all_ranks_db(neuron_num, getColNames(a_r)) = a_r;
    all_ranks_db(neuron_num, {'TracesetIndex'}) = traceset_index;
  end
end

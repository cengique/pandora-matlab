function a_crit_db = matchingRow(p_bundle, traceset_index, props)

% matchingRow - Creates a criterion database for matching the neuron at traceset_index.
%
% Usage:
% a_crit_db = matchingRow(p_bundle, traceset_index, props)
%
% Description:
%   Copies selected test values from row as the first row into the 
% criterion db. Adds a second row for the STD of each column in the db.
%
%   Parameters:
%	p_bundle: A physiol_bundle object.
%	traceset_index: A TracesetIndex of the neuron and treatments to match.
%	props: A structure with any optional properties.
%		
%   Returns:
%	a_crit_db: A tests_db with two rows for values and STDs.
%
%   Example:
%	physiol_bundle has an overloaded matchingRow method that
%	takes the TracesetIndex as argument:
%	>> a_crit_bundle = matchingRow(pbundle, 61)
%	>> a_ranked_bundle = rankMatching(mbundle, a_crit_bundle);
%	>> printTeXFile(comparisonReport(a_ranked_bundle), 'my_report.tex')
%
% See also: rankMatching, tests_db/matchingRow
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/12/21

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

num_tracesets = length(traceset_index);
if num_tracesets > 1
  % If called with vectorized indices
  [ a_crit_bundle(1:num_tracesets) ] = deal(physiol_bundle);
  for traceset_num = 1:num_tracesets
    a_crit_bundle(traceset_num) = matchingRow(p_bundle, traceset_index(traceset_num), props);
  end
else
  % Called with one index
  j_db = get(p_bundle, 'joined_db');

  row_num = find(j_db(:, 'TracesetIndex') == traceset_index);

  if isempty(row_num)
    error(['Cannot find TracesetIndex ' num2str(traceset_index) ]);
  end

  % Get a_crit_db and rename to a more human-readable form
  a_crit_db = set(matchingRow(j_db, row_num, ...
			      struct('distDB', p_bundle.joined_control_db)), 'id', ...
		  ['Matching traceset ' num2str(traceset_index) ' of neuron ' ...
		   get(getItem(get(p_bundle, 'dataset'), traceset_index), 'id') ...
		   ' of ' j_db.id ]);
end
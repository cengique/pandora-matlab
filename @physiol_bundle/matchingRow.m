function a_crit_bundle = matchingRow(a_bundle, traceset_index, props)

% matchingRow - Creates a criterion database for matching the neuron at traceset_index.
%
% Usage:
% a_crit_bundle = matchingRow(a_bundle, traceset_index, props)
%
% Description:
%   Copies selected test values from row as the first row into the 
% criterion db. Adds a second row for the STD of each column in the db.
%
%   Parameters:
%	a_bundle: A physiol_bundle object.
%	traceset_index: A TracesetIndex of the neuron and treatments to match.
%	props: A structure with any optional properties.
%		
%   Returns:
%	a_crit_bundle: A dataset_db_bundle with two rows for values and STDs.
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
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/12/21

if ~ exist('props')
  props = struct;
end

j_db = get(a_bundle, 'joined_db');

%# Warning: doesn't call parent function, directly calls tests_db/matchingRow
a_crit_bundle = ...
    set(a_bundle, 'joined_db', ...
	matchingRow(j_db, find(j_db(:, 'TracesetIndex') == traceset_index), ...
		    struct('std_db', a_bundle.joined_control_db)));

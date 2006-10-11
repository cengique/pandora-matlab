function row_index = collectPhysiolMatches(a_mbundle, a_crit_bundle, props)

% collectPhysiolMatches - Compare model DB to given physiol criteria and return some top matches.
%
% Usage:
% row_index = collectPhysiolMatches(a_mbundle, a_crit_bundle, props)
%
% Description:
%
% Parameters:
%	a_mbundle: A model_ct_bundle object.
%	a_crit_bundle: A physiol_bundle object that holds the criterion neuron.
%	props: A structure with any optional properties.
%	  showTopmost: Number of top matching models to return (default=50)
%		
% Returns: 
%	row_index: Row indices of best matching models.
%
% Example: 
%
% See also: 
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/01/18

if ~exist('props')
  props = struct;
end

num_crits = length(a_crit_bundle);
if num_crits > 1
  %# If called with vectorized criteria
  rankeds = cell(1, num_crits);
  row_index = [];
  for crit_num=1:num_crits
    row_index = ...
	[ row_index; collectPhysiolMatches(a_mbundle, a_crit_bundle(crit_num), props) ];
    %#ranked{crit_num} = onlyRowsTests(get(a_ranked_bundle, 'joined_db'), ':', ...
    %#			     {'RowIndex', 'Distance'});
  end
  %#a_ranked_bundle = set(a_ranked_bundle, 'joined_db', ...
  %#		onlyRowsTests(a_ranked_bundle.joined_db, row_index, ':'));
else
  %# Called with one criterion
  num_best = 50;
  if isfield(props, 'showTopmost')
    num_best = props.showTopmost;
  end
  
  a_ranked_bundle = rankMatching(a_mbundle, a_crit_bundle);
  row_index = ...
      get(onlyRowsTests(get(a_ranked_bundle, 'joined_db'), 1:num_best, 'RowIndex'), 'data');
end

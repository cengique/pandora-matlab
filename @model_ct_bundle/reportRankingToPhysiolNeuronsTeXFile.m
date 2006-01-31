function tex_filename = reportRankingToPhysiolNeuronsTeXFile(a_mbundle, a_crit_bundle, props)

% reportRankingToPhysiolNeuronsTeXFile - Compare model DB to given physiol criterion and create a report.
%
% Usage:
% tex_filename = reportRankingToPhysiolNeuronsTeXFile(a_mbundle, a_crit_bundle, props)
%
% Description:
%   A LaTeX report is generated using the model_ranked_to_physiol_bundle/comparisonReport,
% following the example in physiol_bundle/matchingRow. The filename contains the neuron
% name, followed by the traceset index as an identifier of pharmacological applications,
% as in gpd0421c_s34. 
%
% Parameters:
%	a_mbundle: A model_ct_bundle object.
%	a_crit_bundle: A physiol_bundle object that holds the criterion neuron.
%	props: A structure with any optional properties.
%	  filenameSuffix: Append this identifier to the TeX filename.
%		
% Returns: 
%	tex_filename: Name of LaTeX file generated.
%
% Example: (see example in physiol_bundle/matchingRow)
%
% See also: loadItemProfile, physiol_cip_traceset/cip_trace
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/01/18

if ~exist('props')
  props = struct;
end

traceset_index = a_crit_bundle.joined_db(1, 'TracesetIndex').data;
neuron_name = get(getItem(get(a_crit_bundle, 'dataset'), traceset_index), 'id');
tex_filename = [ neuron_name '_s' num2str(traceset_index) ];

if isfield(props, 'filenameSuffix')
  tex_filename = [ tex_filename props.filenameSuffix ];
end

tex_filename = [ tex_filename '.tex' ];

%# TODO: have showParamsList in props to show some arbitrary params
%# TODO: create LyX file for convenience.

a_ranked_bundle = rankMatching(a_mbundle, a_crit_bundle);
printTeXFile(comparisonReport(a_ranked_bundle), tex_filename);

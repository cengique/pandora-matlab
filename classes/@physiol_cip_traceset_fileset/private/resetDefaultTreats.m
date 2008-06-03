function traceset_list = resetDefaultTreats(traceset_list, all_treatments, props)

% resetDefaultTreats - Count distinct neuron ids and find global list of treatments among tracesets.
%
% Usage:
% [neuron_idx, all_treatments] = resetDefaultTreats(traceset_list, props)
%
% Description:
%
%   Parameters:
%	traceset_list: Cell array of physiol_cip_traceset objects.
%	props: A structure with any optional properties.
%	  neuronIdStart: Start counting neuron_id's from this number.
%		
%   Returns:
%	neuron_idx: A structure that points from neuron names to NeuronId numbers.
%	all_treatments: Structure containing all treatments across tracesets.
%
% See also: physiol_cip_traceset_fileset
%
% $Id: resetDefaultTreats.m 1006 2008-04-03 18:10:14Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2008/05/18

  treat_names = fieldnames(all_treatments);
  zero_treatments = cell2struct(repmat({0}, length(treat_names), 1), treat_names);
  % go over the list again to set zeros for missing treatments
  for ts_num = 1:length(traceset_list)
    traceset_list{ts_num}.treatments = ...
        orderfields(mergeStructs(traceset_list{ts_num}.treatments, ...
                                 zero_treatments), all_treatments);
  end    

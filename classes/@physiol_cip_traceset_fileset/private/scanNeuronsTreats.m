function [neuron_idx, all_treatments] = scanNeuronsTreats(traceset_list, props)

% scanNeuronsTreats - Count distinct neuron ids and find global list of treatments among tracesets.
%
% Usage:
% [neuron_idx, all_treatments] = scanNeuronsTreats(traceset_list, props)
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
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2008/05/18

  if ~exist('props', 'var')
    props = struct;
  end
  
  neuron_idx = struct;
  if isfield(props, 'neuronIdStart')
    neuron_id = props.neuronIdStart;
  else
    neuron_id = 1;
  end
  all_treatments = struct;
  % count neuron_ids and also make global list of treatments
  for a_ts=traceset_list
    if ~ isfield(neuron_idx, a_ts{1}.neuron_id)
      neuron_idx.(a_ts{1}.neuron_id) = neuron_id;
      neuron_id = neuron_id + 1;
    end
    % collect treatments
    all_treatments = mergeStructs(a_ts{1}.treatments, all_treatments);
  end

function p_bundle = mergeBundles(p_bundle, w_bundle, props)

% mergeBundles - Merges two bundles together by adding w_bundle to p_bundle.
%
% Usage:
% p_bundle = mergeBundles(p_bundle, w_bundle, props)
%
% Description:
%
%   Parameters:
%	p_bundle, w_bundle: physiol_bundle objects.
%	props: A structure with any optional properties.
%		
%   Returns:
%	p_bundle: The merged p_bundle.
%
%   Example:
% >> p_bundle = mergeBundles(pbundle, another_bundle)
%
% See also: rankMatching, tests_db/mergeBundles
%
% $Id: mergeBundles.m 896 2007-12-17 18:48:55Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2008/05/18

% Copyright (c) 2008 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props')
  props = struct;
end

% merge filesets
% - count tracesets, increment w_bundle's fileset traceset#
% - count neuronids, increment w_bundle (find max(neuronid) in p_bundle
% and min(neuronid) in w_bundle to calculate offset
% - merge treatments, zero defaults

[p_fileset, traceset_offset, neuron_id_offset] = ...
    mergeFilesets(get(p_bundle, 'dataset'), get(w_bundle, 'dataset'));

p_bundle = ...
    set(p_bundle, 'dataset', p_fileset);

% merge db
% - remap traceset and neuronid numbers. itemindex stays same.
% - make sure they have same treatments? 
p_bundle = ...
    set(p_bundle, 'db', ...
                  unionCatDBs(get(p_bundle, 'db'), get(w_bundle, 'db')));
p_bundle = ...
    set(p_bundle, 'joined_db', ...
                  unionCatDBs(get(p_bundle, 'joined_db'), get(w_bundle, 'joined_db')));
p_bundle = ...
    set(p_bundle, 'joined_control_db', ...
                  unionCatDBs(get(p_bundle, 'joined_control_db'), ...
                              get(w_bundle, 'joined_control_db')));


  function a_db = unionCatDBs(a_db, w_db)
  if ismember('TracesetIndex', getColNames(w_db))
    w_db(:, 'TracesetIndex') = ...
        w_db(:, 'TracesetIndex') + traceset_offset;
  end
  if ismember('NeuronId', getColNames(w_db))
    w_db(:, 'NeuronId') = ...
        w_db(:, 'NeuronId') + neuron_id_offset;
  end

  % make sure they have same treatments? 
  a_db = unionCatTwo(a_db, w_db);

  end
end
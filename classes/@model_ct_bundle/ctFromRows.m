function a_cip_trace = ctFromRows(a_mbundle, a_db, cip_levels, props)

% ctFromRows - Loads a cip_trace object from a raw data file in the a_mbundle.
%
% Usage:
% a_cip_trace = ctFromRows(a_mbundle, a_db|trials, cip_levels, props)
%
% Description:
%   This is an overloaded method.
%
%   Parameters:
%	a_mbundle: A model_ct_bundle object.
%	a_db: A DB created by the dataset in the a_mbundle to read the trial numbers from.
%	trials: A column vector with trial numbers.
%	cip_levels: A column vector of CIP-levels to be loaded.
%	props: A structure with any optional properties.
%	  (passed to a_mbundle.dataset/cip_trace)
%
%   Returns:
%	a_cip_trace: One or more cip_trace objects that hold the raw data.
%
% See also: dataset_db_bundle/ctFromRows
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/07/13

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~exist('props', 'var')
  props = struct;
end

% pass the neuron label to the dataset
trial_num = getTrialNum(a_mbundle, a_db, props);
props.neuronLabel = [ '(t' num2str(trial_num) ')' ];

a_cip_trace = ctFromRows(get(a_mbundle, 'dataset'), get(a_mbundle, 'db'), ...
			 a_db, cip_levels, props);

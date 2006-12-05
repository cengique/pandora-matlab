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

if ~exist('props')
  props = struct;
end

a_cip_trace = ctFromRows(get(a_mbundle, 'dataset'), get(a_mbundle, 'db'), ...
			 a_db, cip_levels, props);

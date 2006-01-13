function a_cip_trace = ctFromRows(a_mbundle, a_db, cip_levels, props)

% ctFromRows - Loads a cip_trace object from a raw data file in the a_mbundle.
%
% Usage:
% a_cip_trace = ctFromRows(a_mbundle, a_db/trials, cip_levels, props)
%
% Description:
%
%   Parameters:
%	a_mbundle: A physiol_cip_traceset_fileset object.
%	a_db: A DB created by this fileset to read the trial numbers from.
%	trials: A column vector with trial numbers.
%	cip_levels: A column vector of CIP-levels to be loaded.
%	props: A structure with any optional properties.
%	  (passed to a_mbundle.dataset/cip_trace)
%		
%   Returns:
%	a_cip_trace: One or more cip_trace objects that hold the raw data.
%
% See also: loadItemProfile, physiol_cip_traceset/cip_trace
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/07/13

if ~exist('props')
  props = struct;
end

a_cip_trace = ctFromRows(get(a_mbundle, 'dataset'), get(a_mbundle, 'db'), ...
			 a_db, cip_levels, props);

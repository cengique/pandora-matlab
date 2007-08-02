function a_cip_trace = ctFromRows(a_bundle, a_db, cip_levels, props)

% ctFromRows - Loads a cip_trace object from a raw data file in the a_bundle.
%
% Usage:
% a_cip_trace = ctFromRows(a_bundle, a_db, cip_levels, props)
%
% Description:
%   This method is not implemented for the generic dataset_db_bundle class. See 
% subclass implementations.
%
%   Parameters:
%	a_bundle: A dataset_db_bundle object.
%	a_db: A DB created by the dataset in the a_bundle to read the neuron index numbers from.
%	cip_levels: A column vector of CIP-levels to be loaded.
%	props: A structure with any optional properties.
%	  (passed to a_bundle.dataset/cip_trace)
%
%   Returns:
%	a_cip_trace: One or more cip_trace objects that hold the raw data.
%
% See also: model_ct_bundle/ctFromRows, physiol_bundle/ctFromRows
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/10/11

error('not implemented. See subclasses physiol_bundle and model_ct_bundle.');


function a_row_index = getNeuronRowIndex(a_bundle, an_index, props)

% getNeuronRowIndex - Returns the neuron index from bundle.
%
% Usage:
% a_row_index = getNeuronRowIndex(a_bundle, an_index, props)
%
% Description:
%   This is a polymorphic method. Therefor it is not defined for this class, 
% but see subclasses of dataset_db_bundle for its more meaningful implementations.
%
%   Parameters:
%	a_bundle: A dataset_db_bundle subclass object.
%	an_index: An index number of neuron, or a DB row containing this.
%	props: A structure with any optional properties.
%		
%   Returns:
%	a_row_index: A row index of neuron in a_bundle.joined_db.
%
% Example:
% >> displayRows(mbundle.joined_db(getNeuronRowIndex(mbundle, 98364), :))
%
% See also: dataset_db_bundle
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/06/09

error('This method is only defined for specific instances of dataset_db_bundle.');

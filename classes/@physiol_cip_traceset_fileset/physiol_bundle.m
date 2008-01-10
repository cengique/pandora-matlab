function a_pbundle = physiol_bundle(fileset, props)

% physiol_bundle - Loads the database and then creates the physiol_bundle object.
%
% Usage:
% a_pbundle = physiol_bundle(fileset, props)
%
% Description:
%   Calls params_tests_db to get the db, and then calls
% tests_db/physiol_bundle to do transformations.
%
%   Parameters:
%	fileset: A physiol_cip_traceset_fileset object.
%	props: A structure with any optional properties.
%		(Passed to tests_db/physiol_bundle)
%		
%   Returns:
%	a_physiol_bundle: One or more physiol_bundle object that holds the raw data.
%
% See also: tests_db/physiol_bundle
%
% $Id: physiol_bundle.m 896 2007-12-17 18:48:55Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2007/12/21

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~exist('props')
  props = struct;
end

a_pbundle = physiol_bundle(params_tests_db(fileset), fileset, props);

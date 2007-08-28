function a_mbundle = addToDB(a_mbundle, a_raw_db, props)

% addToDB - Concatenate to existing DB in the bundle.
%
% Usage:
% a_mbundle = addToDB(a_mbundle, a_raw_db, props)
%
% Description:
%   If joinedDb is not given in props, calls treatSimDB to get the joined_db from this raw DB. 
% Then concats to both db and joined_db in bundle.
%
% Parameters:
%	a_mbundle: A model_ct_bundle object.
%	a_crit_bundle: A physiol_bundle having a crit_db as its joined_db.
%	props: A structure with any optional properties.
%	  joinedDb: The joined version of a_raw_db.
%	  dataset: If given, this one is used to replace the fileset in the bundle.
%		
% Returns:
%	a_mbundle: a model_ct_bundle object containing the added DB.
%
% Example: 
% >> mbundle = addToDB(mbundle, params_tests_db(mfileset, [19684:59956]))
%
% See also: params_tests_fileset/addFiles, multi_fileset_gpsim_cns2005/addFileDir
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/02/06

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props')
  props = struct([]);
end

if isfield(props, 'joinedDb')
  j_db = props.joinedDb;
else
  j_db = treatSimDB(a_raw_db);
end

if isfield(props, 'dataset')
  a_mbundle = set(a_mbundle, 'dataset', props.dataset);
end

a_mbundle = set(a_mbundle, 'db' , [get(a_mbundle, 'db'); ...
				   a_raw_db(:, {'pAcip', 'trial', 'ItemIndex'})]);
a_mbundle = set(a_mbundle, 'joined_db', ...
		[ get(a_mbundle, 'joined_db'); j_db ]) ;


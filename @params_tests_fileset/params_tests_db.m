function db_obj = params_tests_db(obj, props)

% params_tests_db - Generates a params_tests_db object from the fileset.
%
% Usage:
% db_obj = params_tests_db(obj, props)
%
% Description:
%   This is a converter method to convert from params_tests_fileset to
% params_tests_db. Uses readDBFiles to read the files.
% A customized subclass should provide the correct 
% paramNames, testNames, and fileResultsRow functions. Adds a FileIndex
% column to the DB to keep track of raw data files after shuffling.
%
%   Parameters:
%	obj: A params_tests_fileset object.
%	props: Any optional params to pass to params_tests_db.
%		
%   Returns:
%	db_obj: A params_tests_db object.
%
% See also: readDBFiles, params_tests_db, params_tests_fileset, fileResultsRow
%	    testNames, paramNames
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/09

[params, param_names, tests, test_names] = readDBFiles(obj);

db_obj = params_tests_db(params, param_names, tests, test_names, ...
			 obj.id, props);


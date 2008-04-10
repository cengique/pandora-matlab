function db_obj = params_tests_db(obj, items, props)

% params_tests_db - Generates a params_tests_db object from the dataset.
%
% Usage:
% db_obj = params_tests_db(obj, items, props)
%
% Description:
%   This is a converter method to convert from params_tests_dataset to
% params_tests_db. Uses readDBItems to read the files.
% A customized subclass should provide the correct 
% paramNames, testNames, and itemResultsRow functions. Adds a ItemIndex
% column to the DB to keep track of raw data files after shuffling.
%
%   Parameters:
%	obj: A params_tests_dataset object.
%	items: (Optional) List of item indices to use to create the db.
%	props: Any optional params to pass to params_tests_db.
%		
%   Returns:
%	db_obj: A params_tests_db object.
%
% See also: readDBItems, params_tests_db, params_tests_dataset, itemResultsRow
%	    testNames, paramNames
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/09

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props')
  props = struct([]);
end

if exist('items')
  args = {obj, items};
else
  args = {obj};
end

% add by Li Su. pass data source and trace number info to database. just
% in case the fileset is lost, we can still get a clue of where the data
% came from.
if isfield(obj, 'neuron_idx')
    id=get(obj, 'neuron_idx');
    props(1).neuron_idx=id;
    for n=1:length(obj.list)
        ts=obj.list{n};
        props.data_src{n}=get(ts,'data_src');
        ds=get(ts,'params_tests_dataset');
        props.tracesets{n}=ds.list;
    end
end

[params, param_names, tests, test_names] = readDBItems(args{:});

db_obj = params_tests_db(params, param_names, tests, test_names, ...
			 obj.id, props);


function a_bundle = dataset_db_bundle(a_dataset, a_db, a_joined_db, props)

% dataset_db_bundle - The dataset and the DB created from it bundled together.
%
% Usage:
% a_bundle = dataset_db_bundle(a_dataset, a_db, a_joined_db, props)
%
% Parameters:
%   a_dataset: A params_tests_dataset object or a subclass.
%   a_db: The raw tests_db object (or a subclass) created from the dataset.
%   a_joined_db: The processed DB created from the raw DB.
%   props: A structure with any optional properties.
%     joinDBfunc: A function(a_db) to be called that can generate
%     		a_joined_db from it.
%		
% Description:
%   This class is made to enable operations that require seamless connection
% between the high-level (joined) DB and the raw data. The raw DB is only
% required to make a connection to the dataset. Therefore it only needs to
% contain columns necessary to make this connection (e.g., ItemIndex) and
% other columns can be discarded to save space. The raw DB corresponds
% row-to-row to the dataset. The joined DB is a higher-level database where
% multiple rows from the raw DB is combined into single rows that represent
% entities (trials, neurons, etc). This is achieved with a function like
% mergePages or mergeMultipleCIPsInOne. There may be several steps for this
% process, which can be specified as a function handle in the joinDBfunc
% property.
%
% Returns a structure object with the following fields:
%	dataset, db, joined_db, props.
%
% General operations on dataset_db_bundle objects:
%   dataset_db_bundle 	- Construct a new dataset_db_bundle object.
%   profileFromRows	- Given a database row, returns the profile
%   			object by loading it using the dataset.
%   getNeuronRowIndex	- Given an index, returns row index in joined_db.
%   display		- Returns and displays the identification string.
%   get			- Gets attributes of this object and parents.
%   subsref		- Allows usage of . operator.
%
% Additional methods:
%	See methods('dataset_db_bundle')
%
% See also: tests_db, params_tests_dataset
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/12/13

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 % Called with no params
  a_bundle.dataset = params_tests_dataset;
  a_bundle.db = tests_db;
  a_bundle.joined_db = tests_db;
  a_bundle.props = struct([]);
  a_bundle = class(a_bundle, 'dataset_db_bundle');
elseif isa(a_dataset, 'dataset_db_bundle') % copy constructor?
  a_bundle = a_dataset;
else
  if ~ exist('props', 'var')
    props = struct([]);
  end

  a_bundle.dataset = a_dataset;
  a_bundle.db = a_db;
  a_bundle.joined_db = a_joined_db;
  a_bundle.props = props;

  a_bundle = class(a_bundle, 'dataset_db_bundle');
end


function a_db=unionCat(db, with_db, props)

% unionCat - Vertically concatenate two databases with different parameters or tests.
%
% Usage:
% a_db = unionCat(db, with_db, props)
%
% Parameters:
%	db, with_db: tests_db objects to be concatenated together.
%	props: A structure with any optional properties.
%	  offsetTracesets: If 1, make sure the TracesetIndex column is
%	  	offset to non-overlapping values in the concatenated
%	  	databases (default=0).
%
% Description:
%   The parameters and tests in the result are a union of both. Adds 0 for
% parameter and NaN for tests in the rows which didn't have the additional
% columns before.
%
% $Id$
%
% Author: Li Su, 2008-04-10

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

% find params and other column names separately
with_params = getParamNames(with_db);
with_names = setdiff(getColNames(with_db), with_params);
params = getParamNames(db);
names = setdiff(getColNames(db), params);

% combine to find final set of params and cols
combined_params = union(params, with_params);
combined_cols = union(names, with_names);

% fill in params and cols
with_db = fillMissingParams(with_db, combined_params, 0);
db = fillMissingParams(db, combined_params, 0);

with_db = fillMissingColumns(with_db, combined_cols, NaN);
db = fillMissingColumns(db, combined_cols, NaN);

% count tracesets
% [this shouldn't be here, since tracesets correspond to dataset items. I
% added code into physiol_bundle/mergeBundles to count tracesets
% before merging.]
if isfield(props, 'offsetTracesets')
  % take the maximum of tracesetIndex
  max_idx = max(get(onlyRowsTests(db, ':', 'TracesetIndex'), 'data'));
  with_db = ...
      assignRowsTests(with_db, ...
                      onlyRowsTests(with_db, ':', 'TracesetIndex') + max_idx, ...
                      ':', 'TracesetIndex')
end

% delegated to tests_db/vertcat
a_db=[db; with_db];

% merge props recursively
% TODO: put this functinality into mergeStructs [made it recursive, but
% doesn't concat vectors and cells]
props=get(db,'props');
with_props=get(with_db,'props');
commonfield=intersect(fieldnames(props), fieldnames(with_props));
for field={commonfield{:}}
    if isstruct(props.(field{1}))
        props.(field{1})=mergeStructs(props.(field{1}),with_props.(field{1}));
    elseif iscell(props.(field{1})) || isnumeric(props.(field{1}))
        props.(field{1})=[props.(field{1}), with_props.(field{1})];
    end
end
props=mergeStructs(props, with_props); % a union of both fields.

a_db = set(a_db, 'props', props );


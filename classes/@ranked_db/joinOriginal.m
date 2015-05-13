function a_db = joinOriginal(a_ranked_db, rows, props)

% joinOriginal - Joins the distance values to the original db rows with matching row indices.
%
% Usage:
% a_db = joinOriginal(a_ranked_db, rows, props)
%
% Parameters:
%   a_ranked_db: A ranked_db object.
%   rows: Join only the given rows.
%   props: A structure with any optional properties.
%     includeIndices: Also joins ItemIndex columns from the original db.
%     origCols: Also join these columns from the original DB.
%     rankedCols: Also join these columns from a_ranked_db.
%     keepScores: Keep tests (metrics) from a_ranked_db instead of original db.
%		
% Returns:
%   a_db: A params_tests_db object (same type as a_ranked_db.orig_db) containing 
%	the desired rows in ascending order of distance.
%
% Description:
%   Takes the parameter columns from orig_db and all tests from
% crit_db. Therefore z-score values in a_ranked_db are replaced with
% original metric magnitudes. Alternatively, the scores can be preserved in
% the output by specifying the keepScores prop.
%
% See also: tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/21

% Copyright (c) 2007-14 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

props = defaultValue('props', struct);

if ~exist('rows', 'var')
  rows = ':';
end

crit_cols = fieldnames(get(a_ranked_db.crit_db, 'col_idx'));
% Remove the RowIndex and ItemIndex columns, if exists
all_test_cols(1:length(crit_cols)) = true(1);
if isa(a_ranked_db.crit_db, 'params_tests_db')
  all_test_cols(1:get(a_ranked_db.crit_db, 'num_params')) = false;
end
if any(ismember(crit_cols, 'RowIndex'))
  all_test_cols(tests2cols(a_ranked_db.crit_db, 'RowIndex')) = false(1);
end
if any(ismember(crit_cols, 'NeuronId'))
  all_test_cols(tests2cols(a_ranked_db.crit_db, 'NeuronId')) = false(1);
end
%if any(ismember(crit_cols, 'ItemIndex'))
%  all_test_cols(tests2cols(a_ranked_db.crit_db, 'ItemIndex')) = false(1);
%end
crit_cols = {crit_cols{all_test_cols}};

% only keep columns in db
crit_cols = intersect(crit_cols, getColNames(a_ranked_db));

orig_cols = getParamNames(a_ranked_db.orig_db);
if isfield(props, 'includeIndices')
  orig_cols = [ orig_cols, {'/ItemIndex/'}, ...
                {getFieldDefault(props, 'origCols', [])} ];
end

if isfield(props, 'origCols')
  if iscell(props.origCols)
    orig_cols = [ orig_cols, props.origCols ];
  elseif ischar(props.origCols)
    orig_cols = [ orig_cols, {props.origCols} ];
  else
    error('props.origCols must be a single string or a cell array.');
  end
end
orig_cols = getColNames(a_ranked_db.orig_db(:, orig_cols));

% columns to include from a_ranked_db
ranked_cols = getFieldDefault(props, 'rankedCols', []);
if ~ iscell(ranked_cols) 
  ranked_cols = {ranked_cols};
end
ranked_cols = [ {'Distance', 'RowIndex'}, ...
                ranked_cols ];
ranked_cols = getColNames(onlyRowsTests(a_ranked_db, ':', ranked_cols));

if isfield(props, 'keepScores')
  % join only params from orig_db, keep everything else from a_ranked_db
  a_db = joinRows(onlyRowsTests(a_ranked_db.orig_db, ':', ...
                                {orig_cols{:}}), ... 
                  onlyRowsTests(a_ranked_db, rows, ...
                                union(crit_cols, ranked_cols)));
else
  % join only params and tests from orig_db, only keep distance from a_ranked_db
  a_db = joinRows(onlyRowsTests(a_ranked_db.orig_db, ':', ...
                                {orig_cols{:}, ...
                      crit_cols{:}}), ...
                  onlyRowsTests(a_ranked_db, rows, ranked_cols));
end

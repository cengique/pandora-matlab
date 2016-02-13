function a_coefs_db = corrcoef(db, props)

% corrcoef - Calculates a correlation coefficient matrix by comparing cols.
%
% Usage:
% a_coefs_db = corrcoef(db, cols, props)
%
% Parameters:
%   db: A tests_db object.
%   cols: Columns to be compared.
%   props: A structure with any optional properties.
%     skipCoefs: If 1, coefficients of less confidence than %95 
%		will be skipped. (default=1)
%     alpha: Skip coefs with p values lower than this (default=0.05).
%     partialCols: Columns to calculate partial correlations by
%	  	controlling for the other columns.
%     bonfer: Bonferroni correction to alpha value.
%     resample: Shuffle columns and resample correlations this many times to get
%     		statistics for the null hypothesis.
%		
% Returns:
%	a_coefs_db: A tests_3D_db of the coefficient matrix, and their
%		upper/lower limits on different pages.
%
% Description:
%
% See also: tests_db, corrcoefs_db, corrcoef, partialcorr
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2008/04/25

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

if isfield(props, 'skipCoefs')
  skipCoefs = props.skipCoefs;
else
  skipCoefs = 1;
end

% Obsolete, always need to remove NaNs
if isfield(props, 'excludeNaNs')
  excludeNaNs = props.excludeNaNs;
else
  excludeNaNs = 1;
end

if isfield(props, 'alpha')
  alpha = props.alpha;
else
  alpha = 0.05; % for 95%
end

if isfield(props, 'bonfer')
  alpha = alpha / prod(dbsize(db));
end

data = get(db, 'data');
col_names = getColNames(db);
row_names = col_names;
if ~ isfield(props, 'partialCols')
  % ignore NaNs
  [coef_data, p, rlo, rup] = ...
      corrcoef(data, 'rows', 'complete');
else
  partial_cols = tests2cols(db, props.partialCols);
  rest_cols = true(dbsize(db, 2), 1);
  rest_cols(partial_cols) = false;
  if sum(rest_cols) ~= 0
    partial_params = {data(:, partial_cols(1)), ...
                      data(:, partial_cols(2:end)), ...
                      data(:, rest_cols)};
    all_names = getColNames(db);
    row_names = all_names(partial_cols(1));
    col_names = all_names(partial_cols(2:end));
  else
    partial_params = {data};
  end
  %disp('Calculating partial correlations...')
  [coef_data, p] = partialcorr(partial_params{:}, 'rows', 'complete');
  rlo = repmat(NaN, size(coef_data));
  rup = repmat(NaN, size(coef_data));
end

if skipCoefs
  insignificant = p > alpha;
  coef_data(insignificant) = NaN;
  rlo(insignificant) = NaN;
  rup(insignificant) = NaN;
end


% Check if any coefs left
if all(all(isnan(coef_data)))
  warning('tests_db:corrCoef:no_coefs', 'No coefficients found.');
end

% Create the coefficient database
a_coefs_db = ...
    tests_3D_db(cat(3, coef_data, rlo, rup, p), ...
                col_names, row_names, {'corr_coefs', 'rlo', 'rup', 'p'}, ...
                [ 'Correlations in ' ...
                  properTeXLabel(get(db, 'id')) ], props);


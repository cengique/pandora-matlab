function a_coefs_db = corrcoef(db, props)

% corrcoef - Calculates a correlation coefficient matrix by comparing cols.
%
% Usage:
% a_coefs_db = corrcoef(db, cols, props)
%
% Parameters:
%	db: A tests_db object.
%	cols: Columns to be compared.
%	props: A structure with any optional properties.
%	  skipCoefs: If 1, coefficients of less confidence than %95 
%			will be skipped. (default=1)
%	  alpha: Skip coefs with p values lower than this (default=0.05).
%	  partial: Calculate partial correlations instead.
%	  bonfer: Bonferroni correction to alpha value.
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

if ~ isfield(props, 'partial')
  % ignore NaNs
  [coef_data, p, rlo, rup] = ...
      corrcoef(get(db, 'data'), 'rows', 'complete');
else
  [coef_data, p] = partialcorr(get(db, 'data'));
  rlo = repmat(NaN, size(coef_data));
  rup = repmat(NaN, size(coef_data));
end

if skipCoefs
  insignificant = p > alpha;
  coef_data(insignificant) = NaN;
  rlo(insignificant) = NaN;
  rup(insignificant) = NaN;
end

% Create the coefficient database
col_names = getColNames(db);

% Check if any coefs left
if all(all(isnan(coef_data)))
  warning('tests_db:corrCoef:no_coefs', 'No coefficients found.');
end

a_coefs_db = ...
    tests_3D_db(cat(3, coef_data, rlo, rup, p), ...
                col_names, col_names, {'corr_coefs', 'rlo', 'rup', 'p'}, ...
                [ 'Correlations in ' ...
                  properTeXLabel(get(db, 'id')) ], props);


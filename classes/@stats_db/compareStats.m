function a_mult_stats_db = compareStats(a_stats_db, varargin)

% compareStats - Merges multiple stats_dbs into pages of a single stats_db for comparison.
%
% Usage:
% a_mult_stats_db = compareStats(a_stats_db, a_2nd_stats_db, ...)
%
% Description:
%   Generates a plot_simple object from this histogram.
%
%   Parameters:
%	a_stats_db: A stats_db object.
%		
%   Returns:
%	a_mult_stats_db: A multi-page stats_db.
%
% See also: plot_abstract, plot_simple
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/08

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% TODO: should take an array of stats_dbs rather than varargin, so that
% additional arguments can be processed. Make sure to update user's manual.

if ~ exist('props')
  props = struct([]);
end

% do nothing for single input
if isempty(varargin)
  a_mult_stats_db = a_stats_db;
  return;
end

% recurse if multiple inputs were given
if length(varargin) > 1
  with_db = compareStats(varargin{:});
else
  with_db = varargin{1};
end

% Setup lookup tables
col_names = fieldnames(get(a_stats_db, 'col_idx'));
wcol_names = fieldnames(get(with_db, 'col_idx'));

% Check if they have same columns
if dbsize(a_stats_db, 2) ~= dbsize(with_db, 2) || ... % Same number of columns
  ((~ isempty(col_names) || ~ isempty(wcol_names)) && ... % If any names are specified,
   ~ all(ismember(col_names, wcol_names))) 	          % make sure they're same 
  error('Need to have same columns with same names in a_stats_db and with_db.');
end

a_mult_stats_db = ...
    set(a_stats_db, 'data', ...
                    cat(3, get(a_stats_db, 'data'), get(with_db, 'data')));

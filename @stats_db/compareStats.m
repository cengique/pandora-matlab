function a_mult_stats_db = compareStats(a_stats_db, varargin)

% compareStats - Merges multiple stats_dbs into pages of a single stats_db for comparison.
%
% Usage:
% a_mult_stats_db = compareStats(a_stats_db)
%
% Description:
%   Generates a plot_simple object from this histogram.
%
%   Parameters:
%	a_stats_db: A histogram_db object.
%	command: Plot command (Optional, default='bar')
%		
%   Returns:
%	a_mult_stats_db: A object of compareStats or one of its subclasses.
%
% See also: plot_abstract, plot_simple
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/08

if ~ exist('props')
  props = struct([]);
end

%# recurse if multiple inputs were given
if length(varargin) > 1
  with_db = compareStats(varargin{:});
else
  with_db = varargin{1};
end

%# Setup lookup tables
col_names = fieldnames(get(a_stats_db, 'col_idx'));
wcol_names = fieldnames(get(with_db, 'col_idx'));

%# Check if they have same columns
if dbsize(a_stats_db, 2) ~= dbsize(with_db, 2) || ... %# Same number of columns
  ((~ isempty(col_names) || ~ isempty(wcol_names)) && ... %# If any names are specified,
   ~ all(ismember(col_names, wcol_names))) 	          %# make sure they're same 
  error('Need to have same columns with same names in a_stats_db and with_db.');
end

data(:, :, 1) = get(a_stats_db, 'data');

w_pages = dbsize(with_db, 3);
data(:, :, 2:(1+w_pages)) = get(with_db, 'data');

a_mult_stats_db = set(a_stats_db, 'data', data);

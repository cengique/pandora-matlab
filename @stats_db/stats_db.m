function a_stats_db = ...
      stats_db(test_results, col_names, row_names, page_names, id, props)

% stats_db - A database of rows corresponding to statistical distribution
%		properties of tests. Multiple pages can be used to
%		indicate another dimension.
%
% Usage:
% a_stats_db = stats_db(test_results, col_names, row_names, page_names, 
%			id, props)
%
% Description:
%   This is a subclass of tests_3D_db. Allows generating a plot, etc.
%
%   Parameters:
%	test_results: The 3-d array of rows, columns, and pages.
%	col_names: Test names in this db.
%	row_names: Statistical test names for each row.
%	page_names: Meaning of each separate page of data 
%		(e.g., a different invariant parameter).
%	id: An identifying string.
%	props: A structure with any optional properties.
%		axis_limits: Limits in the form of [xmin xmax ymin ymax]
%			     for errorbar axes.
%		yTicksPos: 'left' means only put y-axis ticks to leftmost plot.
%		xTicksPos: 'bottom' means only put x-axis ticks to lowest plot.
%		
%   Returns a structure object with the following fields:
%	tests_3D_db.
%
% General operations on stats_db objects:
%   stats_db		- Construct a new stats_db object.
%   plot_abstract	- Create a simple plot object
%
% Additional methods:
%	See methods('stats_db')
%
% See also: tests_3D_db, plot_abstract
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/07

if nargin == 0 %# Called with no params
  a_stats_db = struct;
  a_stats_db = class(a_stats_db, 'stats_db', tests_3D_db);
elseif isa(test_results, 'stats_db') %# copy constructor?
  a_stats_db = test_results;
else
  
  if ~ exist('props')
    props = struct([]);
  end

  a_stats_db = class(struct, 'stats_db', ...
		     tests_3D_db(test_results, col_names, row_names, ...
				 page_names, id, props));
end


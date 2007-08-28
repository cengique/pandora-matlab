function a_spikes_db = spikes_db(data, col_names, a_trace, a_period, id, props)

% spikes_db - A database of spike shape results obtained from a period in a trace.
%
% Usage:
% a_spikes_db = spikes_db(data, col_names, a_trace, a_period, id, props)
%
% Description:
%   This is a subclass of tests_db. Use trace/analyzeSpikesInPeriod to 
% get an instance of this class.
%
%   Parameters:
%	data: Database contents.
%	col_names: The column names.
%	a_trace: The trace where the spikes were found.
%	a_period: The period inside a_trace where spikes were found.
%	id: An identifying string.
%	props: A structure with any optional properties.
%		
%   Returns a structure object with the following fields:
%	tests_db, trace, period, props.
%
% General operations on spikes_db objects:
%   spikes_db		- Construct a new spikes_db object.
%   plot_abstract	- Creates a trace plot with spike shapes annotated in red.
%
% Additional methods:
%	See methods('spikes_db')
%
% See also: tests_db, trace, period, trace/analyzeSpikesInPeriod
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/08/17

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 %# Called with no params
   a_spikes_db.trace = trace;
   a_spikes_db.period = period;
   a_spikes_db = class(a_spikes_db, 'spikes_db', tests_db);
 elseif isa(data, 'spikes_db') %# copy constructor?
   a_spikes_db = data;
 else %# Create a new object

   if ~ exist('props')
     props = struct([]);
   end

   a_spikes_db.trace = a_trace;
   a_spikes_db.period = a_period;

   %# Create subclass object
   a_spikes_db = class(a_spikes_db, 'spikes_db', ...
		       tests_db(data, col_names, {}, id, props));
end

function obj = trace(data_src, dt, dy, id, props)

% trace - A generic trace from a cell. It can be voltage, current, etc.
%
% Usage:
% obj = trace(data_src, dt, dy, id, props)
%
% Description:
%   Traces for specific neurons can inherit from this class for
%   adding new parameters.
%
%   Parameters:
%	data_src: The trace column OR the .MAT filename.
%	props: A structure any needed properties, such as:
%		dy: y-axis scale to be applied from input file.
%		baseline: Resting potential.
%		channel: Channel to read from file.
%		traces: Traces to read from PCDX file.
%		spike_finder: Method of finding spikes 
%		(1 for findFilteredSpikes, 2 for findspikes).
%		threshold: Spike threshold.
%	(see below for the rest)
%		
%   Returns a structure object with the following fields:
%	data: The trace column matrix.
%	dt: Time resolution [s]
%	dy: y-axis resolution [ISI (V, A, etc.)]
%	id: Identification string
%	props: (see above)
%
% General operations on trace objects:
%   trace		- Construct a new trace object.
%   plot		- Graph the trace.
%   display		- Returns and displays the identification string.
%   calcAvg		- Calculate the average value of the trace period.
%   calcMin		- Calculate the minimum value of the trace period.
%   calcMax		- Calculate the minimum value of the trace period.
%   periodWhole		- Return the whole period of this trace.
%   findFilteredSpikes	- Use a band-pass filter to smooth the data and
%			find spikes afterwards. TODO: separate the filter
%
% Converter methods:
%   spikes		- Find the spikes and construct a spikes object.
%   spike_shape		- Construct a spike_shape object from this trace.
% 
% Additional methods:
%	See methods('trace')
%
% See also: spikes, spike_shape, period
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/07/30

if nargin == 0 %# Called with no params
   obj.data = [];
   obj.dt = 1;
   obj.dy = 1;
   obj.id = '';
   obj.props = struct([]);
   obj = class(obj,'trace');
 elseif isa(data_src,'trace') %# copy constructor?
   obj = data_src;
 else

   if isa(data_src, 'char') %# filename?

     %# TODO: load genesis, pcdx, and matlab files

     %# use the filename as id unless otherwise specified
     if ~ exist('id') | strcmp(id, '') == 1
       [path, name, ext, ver] = fileparts(data_src);
       id = name;
     end

     s = load(data_src);
     fields = fieldnames(s);
     data = getfield(s, fields{1});	%# Assuming there's only one vector
   elseif isa(data_src, 'double')
     data = data_src;
   else
     error(sprintf('Unrecognized data source %s', data_src));
   end

   if ~ exist('props')
     props = struct([]);
   end

   obj.data = data;
   obj.dt = dt;
   obj.dy = dy;
   obj.id = id;
   obj.props = props;
   obj = class(obj, 'trace');
end


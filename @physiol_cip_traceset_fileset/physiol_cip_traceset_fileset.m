function obj = physiol_cip_traceset_fileset(cells_filename, dt, dy, props)

% physiol_cip_traceset_fileset - Physiological fileset of traceset objects (concatenated).
%
% Usage:
% obj = physiol_cip_traceset_fileset(cells_filename, dt, dy, props)
%
% Description:
%   This is a subclass of params_tests_dataset. Each trace varies in bias, 
% pulse times and cip magnitude.
%
%   Parameters:
%	cells_filename: Ascii file containing the following tab-delimited items:
%		1. Neuron ID (name to associate with the neuron). If left blank, use
%			the filename with the '.all' extension removed.
%		2. The absolute path of the data file
%		3. The trace numbers to load, space-delimited (e.g. 1-21 24 26 27)
%		4. Vchan: voltage channel number
%		5. Ichan: current channel number
%		6. Vgain: external gain on voltage channel IN ADDITION to the 10X that
%				automatically comes from the Axoclamp 2B.
%		7. Igain: external gain on current channel.
%		8. Pairs of condition names and molar concentrations in any order
%			e.g.: TTX	1e-8	apamin	2e-7	picrotoxin	1e-4
%
%	dt: time resolution [s].
%	dy: y-axis resolution [V] or [A].
%	props: A structure with any optional properties passed to cip_trace_profile.
%		
%   Returns a structure object with the following fields:
%	neuron_idx: A structure that points from neuron names to NeuronId numbers.
%	params_tests_dataset
%
% General operations on physiol_cip_traceset_fileset objects:
%   physiol_cip_traceset_fileset - Construct a new object.
%   params_tests_db - Loops over traceset objects and concatenates to form database
% Additional methods:
%	See methods('physiol_cip_traceset_fileset'), and 
%	    methods('params_tests_dataset').
%
% See also: physiol_cip_traceset, params_tests_dataset, params_tests_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu> and Thomas Sangrey, 2005/01/17
% Modified: Jeremy Edgerton

if nargin == 0 %# Called with no params
  obj.neuron_idx = struct([]);
  obj.props = struct([]);
  obj = class(obj, 'physiol_cip_traceset_fileset', params_tests_dataset);
elseif isa(cells_filename, 'physiol_cip_traceset_fileset') %# copy constructor?
  obj = cells_filename;
else

  if ~ exist('props')
    props = struct([]);
  end
   
  obj.neuron_idx = struct;
  obj.props = props;
  %# read ASCII file, make each line an item in a cell array
  tcell = textread(cells_filename, '%s', 'delimiter', '\n');
  %# Parse each line, organize items by line number.
  tmtstruct = struct('tmp', 0);	% keep track of treatments in use.
  names = cell(length(tcell), 1);
  paths = cell(length(tcell), 1);
  traces = cell(length(tcell), 1);
  chaninfo = cell(length(tcell), 1);
  tmts = cell(length(tcell), 1);
  list = cell(length(tcell), 1);    
  neuron_id = 1;
  
  for n = 1:length(tcell)
	ttm = {};
	resid = tcell{n};
	ntok = 0;
	pars = {};
	while isempty(resid) ~= 1
		ntok = ntok + 1;
		[pars{ntok}, resid] = strtok(resid, sprintf('\t'));
	end

	%# Skip empty lines
	if isempty(pars)
	  continue;
	end

	% First token is either neuron id name or data file with path.
	% If data file, make neuron id name = file name without extension.
	if exist(pars{2}, 'file') == 2
		names{n} = pars{1};
		pars(1) = [];
	elseif exist(pars{1}, 'file') ~= 2
	  error('No valid data file name found.');
	else
		slashes = strfind(pars{1}, '/');
		if isempty(slashes) ~= 1
			tstr = pars{1}(slashes(length(slashes)) + 1 : length(pars{1}));
		else
			tstr = pars{1};
		end
		dots = strfind(tstr, '.');
		if isempty(dots) ~= 1
			names{n} = tstr(1:dots(length(dots)) - 1);
		else
			names{n} = tstr;
		end
	end

	%# Enter the name into a structure to keep track of unique neuron ids
	if ~ isfield(obj.neuron_idx, names{n})
	  obj.neuron_idx.(names{n}) = neuron_id;
	  neuron_id = neuron_id + 1;
	end
	
	paths{n} = pars{1};
	traces{n} = pars{2};
	
	chaninfo{n} = [str2num(pars{3}), str2num(pars{4}), ...
	 			str2num(pars{5}), str2num(pars{6})];
	for m = 7:2:length(pars)-1
		if isstr(pars{m+1})
			pars{m+1} = str2num(pars{m+1});
		end
		ttm = cat(1, ttm, pars(m:m+1));
	end
	for m = 1:size(ttm, 1)
		if isfield(tmtstruct, ttm{m, 1}) ~= 1
			if isstr(ttm{m, 1}) ~= 1
				sprintf('Illegal field name: %s', ttm{m, 1})
				sprintf('Error is in line %d of input file', n)
				error('');
			end
			tmtstruct = setfield(tmtstruct, ttm{m, 1}, 0);
		end
	end
	tmts{n} = ttm;
  end

  if isfield(tmtstruct, 'tmp')
	  tmtstruct = rmfield(tmtstruct, 'tmp');
  end

  %# Create list of traceset objects.
  for n = 1:length(tcell)
	% make copy of treatment struct, fill in values for this item
	tempstruct = tmtstruct;
	ttm = tmts{n};
	for m = 1:size(ttm, 1)
		tempstruct = setfield(tempstruct, ttm{m,1}, ttm{m,2});
	end
	list{n} = physiol_cip_traceset(traces{n}, paths{n}, chaninfo{n}, ...
				       dt, dy, tempstruct, names{n}, props);
  end

  %# Create the fileset object
  obj = class(obj, 'physiol_cip_traceset_fileset', ...
	      params_tests_dataset(list, dt, dy, ...
	      ['tracesets from ', cells_filename ], props));

end



function a_tset = traceset_L1_passive(traces_cell, treatments, neuron_id, props)

% traceset_L1_passive - Dataset of multiple ABF files that belong to the same cell.
%
% Usage:
% a_tset = traceset_L1_passive(traces_cell, treatments, neuron_id, props)
%
% Parameters:
%   traces_cell: Cell array of file names, numeric file indices for fileTempl or voltage_clamp objects.
%   treatments: Structure with protocol names and corresponding trace lists.
%   neuron_id: Neuron name.
%   props: A structure with any optional properties.
%     fileTempl: A sprintf template to place the items in traces_cell to
%     		 generate the final filename. See example below.
%     baseDir: Directory to find the files.
%     (All other props are passed to getResultsPassiveReCeElec in loadItemProfile)
%		
%   Returns a structure object with the following fields:
%	params_tests_dataset,
%	treatments, neuron_id.
%
% Description:
%   This is a subclass of params_tests_dataset. 
%
% Example:
% > a_ts = traceset_L1_passive({1, 5, 456}, 'my neuron',
% 				struct('fileTempl', 'file%05d.abf',
% 				'baseDir', 'C:/myfiles/'));
% would make a traceset out of file00001.abf, file00005 and file00456.abf.
%
% General operations on traceset_L1_passive objects:
%   traceset_L1_passive - Construct a new object.
%   loadItemProfile	- Builds a data_L1_passive for each trace in the set.
%
% Additional methods:
%	See methods('traceset_L1_passive'), and 
%	    methods('params_tests_dataset').
%
% See also: sprintf, cip_traces, params_tests_dataset, params_tests_db
%
% $Id: traceset_L1_passive.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/02/02

% Copyright (c) 2011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

if nargin == 0 % Called with no params
  a_tset.treatments = struct;
  a_tset.neuron_id = '';
  a_tset = class(a_tset, 'traceset_L1_passive', params_tests_dataset);
elseif isa(traces_cell, 'traceset_L1_passive') % copy constructor?
  a_tset = traces_cell;
else
  a_tset.treatments = treatments;
  a_tset.neuron_id = neuron_id;

  if isnumeric(traces_cell)
    traces_cell = num2cell(traces_cell);
  end
  
  % Create the object 
  a_tset = class(a_tset, 'traceset_L1_passive', ...
                 params_tests_dataset(traces_cell, [], [], ...
                                      neuron_id, props));
end


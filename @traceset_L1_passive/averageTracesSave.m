function [avg_vc sd_vc] = averageTracesSave(traceset, suffix_str, props)

% averageTracesSave - Average all traces in traceset and save as voltage_clamp MAT file.
%
% Usage:
% [avg_vc sd_vc] = averageTracesSave(traceset, suffix_str, props)
%
% Parameters:
%   traceset: A traceset object.
%   suffix_str: Add to save file indicating protocol.
%   props: Structure with optional parameters.
%
% Returns:
%   avg_vc: Average VC object
%   sd_vc: Standard VC object
%
% Description:
%   Also generates statistics and saves a lot of files. Will create a
% LaTeX document in the proper directory.
%
% See also: traceset_L1_passive, data_L1_passive
%
% $Id: averageTracesSave.m 896 2007-12-17 18:48:55Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/02/04

% Copyright (c) 2011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% TODO: make it intelligent to check the voltage steps!

props = mergeStructs(defaultValue('props', struct), get(traceset, 'props'));

traceset_id = get(traceset, 'id');

% do it only if average files don't exist
avg_file = [ props.docDir filesep traceset_id filesep 'Average' suffix_str ...
             '.mat' ];
sd_file = [ props.docDir filesep traceset_id filesep 'AverageSD' suffix_str ...
             '.mat' ];
if ~exist(avg_file, 'file') || ~exist(sd_file, 'file')
  tracelist = get(traceset, 'list');

  num_traces = length(tracelist);
  traces = repmat(trace, 1, num_traces);

  % take first as template voltage protocol
  avg_vc = getItemVC(traceset, 1);

  % then average only current traces
  traces(1) = get(avg_vc, 'i');
  for trace_index = 2:num_traces
    traces(trace_index) = get(getItemVC(traceset, trace_index), 'i');
  end

  [avg_tr sd_tr] = avgTraces(traces);

  avg_vc = set(avg_vc, 'i', avg_tr);
  avg_vc = set(avg_vc, 'id', [traceset_id ' - Average' suffix_str ]);
  sd_vc = set(avg_vc, 'i', sd_tr);
  sd_vc = set(sd_vc, 'id', [traceset_id ' - SD' suffix_str ]);
  
  save(avg_file, 'avg_vc');
  save(sd_file, 'sd_vc');
else
  disp(['Found existing averages in ''' avg_file ''' and ''' sd_file '''. Loading...']);

  load(avg_file);
  load(sd_file);
end


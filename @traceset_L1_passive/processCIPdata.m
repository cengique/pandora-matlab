function [a_db, a_stats_db, Cm_avg, tex_file] = processCIPdata(traceset, props)

% processCIPdata - Generates a DB of the cell's traceset by extracting measures from current-clamp data.
%
% Usage:
% [a_db, a_stats_db, Cm_avg, tex_file] = processCIPdata(traceset, props)
%
% Parameters:
%   traceset: A traceset object.
%   props: Structure with optional parameters.
%     recalc: If 1, recalculate even if saved file is found.
%
% Returns:
%
% Description:
%
% See also: traceset_L1_passive, data_L1_passive
%
% $Id: processCIPdata.m 896 2007-12-17 18:48:55Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/02/24

% Copyright (c) 2011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

props = mergeStructs(defaultValue('props', struct), get(traceset, 'props'));

traceset_id = get(traceset, 'id');

% Save the db and load it later instead of processing
db_file = [ props.docDir filesep traceset_id filesep 'cip_db.mat' ];
if ~exist(db_file, 'file') || isfield(props, 'recalc')
  % generate the DB and docs from current-clamp data protocols
  a_db = params_tests_db(setProp(set(traceset, 'list', ...
                                               num2cell(traceset.protocols.cip)), ...
                                 'loadItemProfileFunc', ...
                                 @loadCCprof));
  % TODO: remove some columns?
  % check and create directory
  final_dir = [ props.docDir filesep traceset_id ];
  if ~ exist(final_dir, 'dir')
    mkdir(props.docDir, traceset_id);
  end
  save(db_file, 'a_db');
  % TODO: also save a csv file of DB
else
  disp(['Found existing DB in ''' db_file '''. Loading...']);  
  load(db_file);
  % Check the TraceNums in DB to make sure it has all, and do the
  % subtracted subset
  remain_traces = ...
      setdiff(traceset.protocols.cip, ...
              get(onlyRowsTests(unique(a_db(:, 'TraceNum')), ':', 'TraceNum'), ...
                  'data'));
  if ~isempty(remain_traces)
    disp([ 'Processing remaining traces: ' num2str(remain_traces) ]);
    b_db = params_tests_db(setProp(set(traceset, 'list', ...
                                                 num2cell(remain_traces)), ...
                                   'loadItemProfileFunc', ...
                                   @loadCCprof));
    a_db = [a_db; b_db];
    save(db_file, 'a_db');
  end
  
end

end

function a_cc_prof = loadCCprof(traceset, trace_index)
traceset_props = get(traceset, 'props');

a_cc = ...
    current_clamp(setProp(getItemVC(traceset, trace_index, ...
                                              mergeStructs(traceset_props, ...
                                                  struct('iSteps', 1))), ...
                          'lowPassFreq', 1000, ...
                          'threshold', 2.5, ...
                          'downThreshold', -1, ...
                          'minInit2MaxAmp', 2, ...
                          'minMin2MaxAmp', 2));

[a_cc_res profs] = getResults(a_cc);

a_cc_prof = results_profile(a_cc_res, get(traceset, 'id'));

end
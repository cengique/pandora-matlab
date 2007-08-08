function cipList = ns_CIPlist(data_src, tracelist)

% Author: Dawid Kurzyniec

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.txt.

if ~ exist('tracelist') || isempty(tracelist)
  tracelist=1;
end
tr=min(tracelist);

file = ns_open_file(data_src, true);
hyp_name = file.Trials{tr}.StimulationData{1}.VChannel;
hyp_names = cellfun(@(x)x.Name, file.ExperimentControl.Hyperpackets, 'UniformOutput', false);
hyp_idx = strmatch(hyp_name, hyp_names, 'exact');

hyp_data = ns_read(file.ExperimentControl.Hyperpackets{hyp_idx});
trans = hyp_data.ParsedXML.HPElementProperties.TransitionsCluster;

amp = linspace(str2num(trans.StartingValue.Amplitude), ...
                  str2num(trans.EndingValue.Amplitude), ...
                  str2num(trans.TotalSteps.Amplitude));
dur = linspace(str2num(trans.StartingValue.Duration), ...
                  str2num(trans.EndingValue.Duration), ...
                  str2num(trans.TotalSteps.Duration));
on = linspace(str2num(trans.StartingValue.StartTime), ...
                  str2num(trans.EndingValue.StartTime), ...
                  str2num(trans.TotalSteps.StartTime));
finish = str2num(file.Trials{tr}.ExperimentControl.ParsedXML.MaxStimulusDuration);

cipList=struct('Amplitude',amp, 'StartTime',on, 'Duration',dur, 'MaxStimulusDuration', finish);
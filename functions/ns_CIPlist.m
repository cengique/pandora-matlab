function cipList = ns_CIPlist(data_src, tracelist)

% Author: Dawid Kurzyniec

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

vs = warning('query', 'verbose');
verbose = strcmp(vs.state, 'on');

if ~ exist('tracelist', 'var') || isempty(tracelist)
  tracelist=1;
end
tr=min(tracelist);

if isstruct(data_src)
  file = data_src;
else
  % unless already given
  file = ns_open_file(data_src, true);
end
hyp_name = file.Trials{tr}.StimulationData{1}.VChannel;
hyp_names = cellfun(@(x)x.Name, file.ExperimentControl.Hyperpackets, 'UniformOutput', false);
hyp_idx = strmatch(hyp_name, hyp_names, 'exact');

if isempty(hyp_idx)
  if verbose
    hyp_name
    format long
    hyp_names
    format
    warning(['ns_CIPlist: Cannot find hyperpacket in available names; will try removing ' ...
             'trailing parens.']);
  end
  hyp_name = regexprep(hyp_name, ' \([0-9]\)', '');
  hyp_idx = strmatch(hyp_name, hyp_names, 'exact');
  if isempty(hyp_idx)
    hyp_name
    format long
    hyp_names
    format
    error(['ns_CIPlist: Cannot find hyperpacket in available names; even after removing ' ...
             'trailing parens.']);
  end
end  

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

cipList=struct('Amplitude',amp, 'StartTime',on, 'Duration',dur, ...
               'MaxStimulusDuration', finish);

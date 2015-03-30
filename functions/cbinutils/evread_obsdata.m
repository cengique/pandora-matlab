function [daqdata, ad_freq] = evread_obsdata(filename, chan_spec)
% [daqdata, ad_freq] = read_obsdata(filename, chan_spec)
%
% READ_OBSDATA  Return one channel of data acquisition data from an msong,
% foosong, Observer, or IO_Stream trial. 
%
% FILENAME is the name of the desired datafile. If FILENAME ends with a '.'
% then it is treated as a msong/fosong file: the CHAN_SPEC param is the
% file extension to FILENAME in this case. 
%
% CHAN_SPEC is a numeric string possibly followed by an 'r' (e.g. '2' or  
% '5' or '0r') which specifies the data channel to retrieve. The number
% in CHAN_SPEC ranges from 0-15 with 0 being the first channel. If CHAN_SPEC
% has the form 'xr', then the channel is determined by subtracting the
% integer 'x' from the total number of channels acquired in the trial.
% The 'r' specification is only valid for Observer/IO_Stream datafiles.
%
% If the rec file for the trial does not exist then DAQDATA will be an
% empty vector and AD_FREQ will be -1. Otherwise the retrieved data will
% be returned in DAQDATA and the sampling frequency will be returned in
% AD_FREQ.
%

daqdata = [];
ad_freq = -1;

dot = findstr(filename, '.');
if (isempty(dot)),
   fmark_error(['Unknown filename type: ' filename]);
end

% error check the chan_spec
len = length(chan_spec);
if (chan_spec(len) == 'r'),
  if (len == 1),
    disp('CHAN_SPEC arg must have an integer preceding the "r".');
	 return;
  end
  direction = 'reverse';
  chan_spec = chan_spec(1:len-1);
else
  direction = 'normal';
end
ch_num = str2num(chan_spec);
if (isempty(ch_num)),
   disp('Incorrect format for CHAN_SPEC.');
   return;
end

if (filename(length(filename)) == '.'),
  ftype = 'sun';
  if strcmp(direction,'reverse'),
     disp('CHAN_SPEC cannot have "r" spec with msong/foosong files');
     return;
  end
else
  ftype = 'lview';
end

% get the DAQ data from the correct channel
if strcmp(ftype, 'sun'),
   ch_str = chan_spec;
   filename = [filename ch_str];
   [daqdata, ad_freq] = read_rawfile42c(filename, 'short');
elseif strcmp(ftype, 'lview'),
   [daqdata, ad_freq]=evread_labv_file(filename, ch_num, direction);
end
return;

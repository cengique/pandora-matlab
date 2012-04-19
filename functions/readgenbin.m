function [data, time_trace] = readgenbin(filename, start_time, end_time, endian)
%
% readgenbin - Reads a time-range of data from a binary GENESIS file.
%
% Usage:
% [data, time_trace] = readgenbin(filename, start_time, end_time, endian);
%
% Parameters: 
%   filename: Path to GENESIS file.
%   start_time, end_time: Time in milliseconds relative to the ACTUAL 
%           time of the experiment at which data adquisition started 
%           (if you start gathering data at 200 ms and you specify 0
%           start time it will not work). If either is [] or NaN, defaults
% 	    to beginning and end of trace, respectively. end_time is 
%	    not inclusive.
%   endian: (optional) Indicates file format; 'l' for little endian
%           and 'b' for big endian. See the "machineformat" option 
%	    in fopen for more information. Defaults to the native endian
%	    of this computer.
%
% Returns:
%   data: Data vector or matrix read.
%   time_trace: (Optional) Corresponding time range vector (in ms).
%
% Description:
%   Files should be created by the disk_out method in the GENESIS neural
% simulator. No checking for binary type is made, so if you want reliability please
% ensure the file is a binary. Files written by GENESIS on big-endian
% machines (like old Mac and Solaris machines with PowerPC architecture)
% must be loaded with the endian='b' option. There are sanity checks to
% flag that the file may be reverse-endian, but this is not automatically
% corrected.
%
% Example:
% Fully read a native-endian file:
% >> dat = readgenbin('mydir/myfile.bin');
% Specify a time range:
% >> dat = readgenbin('mydir/myfile.bin', 100, 1000);
% Get a time vector back:
% >> [dat, t] = readgenbin('mydir/myfile.bin', 100, 1000);
% >> figure; plot(t, dat);
% Force to fully load big-endian Mac file on PC platform:
% >> dat = readgenbin('mydir/mymacfile.bin', NaN, NaN, 'b');
%
% See also: fopen
%
% Author:
%   Alfonso Delgado-Reyes <adelgado@biology.emory.edu> original version based in open
%   binary from Simon Peron.
%   Cengiz Gunay <cengique@users.sf.net> for minor modifications and endian support.

% $Id$

if ~exist('endian', 'var') || isempty(endian) || isnan(endian) 
  [c,maxsize,endian] = computer;    
end

% Open the file with desired endianness
disp([ 'Reading ' filename ]);
fil = fopen(filename, 'r', endian);

% Figure out how many bytes we can read at most
fseek(fil, 0, 'eof');
length = ftell(fil);

% Determine the sampling freq. and number of channels from header
fseek(fil, 80, 'bof');
act_start_time = fread(fil, [1 1], 'float32');
timestep = fread(fil, [1 1], 'float32');
freq = 1/timestep;
disp([ 'File start time: ' num2str(act_start_time) ' ms' sprintf('\n') ...
       'Sampling frequency: ' num2str(freq) ' Hz' ]);
assert(freq > 1 && freq < 1e6, [ 'Frequency outside ' ...
                    'bounds  1 - 1,000,000 Hz. Make sure to  ' ...
                    'select the correct endian parameter!' ]);
adjustment_ratio = freq * 1e-3; 
num_cols = fread(fil, [1 1], 'int');
disp([ 'Number of data columns: ' num2str(num_cols) ]);
assert(num_cols > 0 && num_cols < 65536, [ 'Number of columns outside ' ...
                    'bounds of  1 - 65536. Make sure to  ' ...
                    'select the correct endian parameter!' ]);

if ~exist('start_time') || isempty(start_time) || isnan(start_time)
  ev_start_time = 0;
  start_time = 0;
else
  ev_start_time = round((start_time - act_start_time) * ...
                        adjustment_ratio);
end

% Check to make sure the user did not specify invalid time ranges
header_size = 96 + (3 * num_cols * 4);
read_start = header_size + (ev_start_time * 4 * num_cols);
total_data_length = (length - header_size) / (4 * num_cols);
disp([ 'Length: ' num2str(total_data_length) ' data points, up to ' ...
       num2str(total_data_length / adjustment_ratio - act_start_time) ' ms']);

if ~exist('end_time') || isempty(end_time) || isnan(end_time)
  ev_end_time = total_data_length;
else
  ev_end_time = round((end_time - act_start_time) * adjustment_ratio);
end

read_length = (ev_end_time - ev_start_time);
assert(read_length > 0, 'Must choose end_time > start_time!');
assert(read_length <= (total_data_length - ev_start_time), 'end_time is past end of file!');

% Read those data in
disp([ 'Reading ' num2str(read_length) ' points, or ' num2str(read_length/adjustment_ratio) ...
     ' ms of data.' ])
fseek(fil, round(read_start), 'bof');
[A, num_read] = fread(fil, [num_cols read_length], 'float32');
fseek(fil, round(read_start), 'bof');
fclose(fil);

if num_read < read_length, warning([ 'Short read! ' num2str(num_read) ' < ' ...
                      num2str(read_length)]), end

data = A';

% If requested, create the time_trace
if nargout > 1
    time_size = end_time - start_time;
    time_trace = (0:(read_length-1))/adjustment_ratio + start_time;
end
function writeNeuronVecAscii(filename, data, dt, dy, unit_y, label)

% writeNeuronVecAscii - Writes ascii file to be read by Neuron simulator as Vector object.
%
% Usage:
% writeNeuronVecAscii(filename, data, dt, dy, unit_y, label)
%
% Parameters: 
%   filename: Full path to Neuron file.
%   data: Column or row vector of data.
%   dt: Time resolution in [s].
%   dy: y-axis resolution in [A] or [V].
%   unit_y: Units of y-axis; 'A' or 'V'.
%   label: Text label to export to Neuron (spaces will be replaced with '_')
%
% Returns:
% 
% Description:
%   It's one line of code just to write the data: 
% dlmwrite(filename, ...
%         [(0:(num_samples - 1))'*dt*1e3, data*1e-3], '-append', ...
%         'delimiter', '\t')
% Data converted to Neuron units of nA and mV.
%
% Example:
%   writeNeuronVecAscii('myvec.dat', data, 1e-4, 1e-3, 'V', 'my membrane voltage');
%
% Also see: dlmread, http://www.neuron.yale.edu
%
% Author: Cengiz Gunay <cengique@users.sf.net> 2012/03/23
 
% Copyright (c) 2012 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% convert to column vector
  data = data(:);
  
  num_samples = length(data);
  
% create file and write label
string2File(sprintf('label:%s\n%d\n', strrep(label, ' ', '_'), num_samples), filename);

if strcmp(unit_y, 'A'), mult = dy*1e9; % nA
elseif strcmp(unit_y, 'V'), mult = dy*1e3; % mV
else 
  unit_y
  error(['unit_y must be ''A'' or ''V''.']);
end

% convert to ms and nA
dlmwrite(filename, ...
         [(0:(num_samples - 1))'*dt*1e3, data*mult], '-append', ...
         'delimiter', '\t')

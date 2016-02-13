function writeNeuronVecAscii(filename, datax, datay, dx, dy, unit_x, unit_y, label)

% writeNeuronVecAscii - Writes ascii file to be read by Neuron simulator as Vector object.
%
% Usage:
% writeNeuronVecAscii(filename, datax, datay, dx, dy, unit_x, unit_y, label)
%
% Parameters: 
%   filename: Full path to Neuron file.
%   datax: (Optional) X-axis points. Give empty vector to skip.
%   datay: Column or row vector of data.
%   dx: X-axis resolution in [s] or [V].
%   dy: y-axis resolution in [A] or [V].
%   unit_x: Units of x-axis; 'V' or 's'.
%   unit_y: Units of y-axis; 'A', 'V', or 's'.
%   label: Text label to export to Neuron (spaces will be replaced with '_')
%
% Returns:
%   Nothing.
% 
% Description:
%   It's one line of code just to write the data: 
% dlmwrite(filename, ...
%         [(0:(num_samples - 1))'*dx*1e3, datay*1e-3], '-append', ...
%         'delimiter', '\t')
% Data converted to Neuron units of nA, mV, and ms.
%
% Example:
%   writeNeuronVecAscii('myvec.dat', [], datay, 1e-4, 1e-3, 's', 'V', 'my membrane voltage');
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
  datay = datay(:);
  
  num_samples = length(datay);
  
% create file and write label
string2File(sprintf('label:%s\n%d\n', strrep(label, ' ', '_'), num_samples), filename);

if strcmp(unit_y, 'A'), dy = dy*1e9; % nA
elseif strcmp(unit_y, 'V'), dy = dy*1e3; % mV
elseif strcmp(unit_y, 's'), dy = dy*1e3; % ms
else 
  unit_y
  error(['unit_y must be ''A'', ''V'' or ''s''.']);
end

if strcmp(unit_x, 'V'), dx = dx*1e3; % mV
elseif strcmp(unit_x, 's'), dx = dx*1e3; % ms
else 
  unit_x
  error(['unit_x must be ''V'' or ''s''.']);
end

if isempty(datax)
  datax = (0:(num_samples - 1))';
else
  datax=datax(:); % convert to column vec
end

% convert to ms and nA
dlmwrite(filename, ...
         [datax*dx, datay*dy], '-append', ...
         'delimiter', '\t')

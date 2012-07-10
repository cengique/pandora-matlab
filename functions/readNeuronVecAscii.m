function [data, label] = readNeuronVecAscii(filename) 

% readNeuronVecAscii - Reads Neuron simulator Vector object data from ascii files.
%
% Usage:
% [data, label] = readNeuronVecAscii(filename) 
%
% Parameters: 
%   filename: Full path to Neuron file.
%
% Returns:
%   data: Row vector with two columns of data.
%   label: String denoting Vector contents.
% 
% Description:
%   It's one line of code just to read the data: dlmread(filename, '\t', 2, 0)
%
% Example:
%   data = readNeuronVecAscii('myvec.dat');
%
% Also see: dlmread, http://www.neuron.yale.edu
%
% Author: Cengiz Gunay <cengique@users.sf.net> 2012/03/02
 
% Copyright (c) 2012 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% read label
  [fid,errmsg] = fopen(filename,'r'); 
  if fid==-1 
    error([ 'Cannot open file "' filename '":' errmsg]);
  end 

  label = regexprep(fgetl(fid), 'label:', '');
  count = str2num(fgetl(fid));
  
  fclose(fid);
  
  % read data
  data = dlmread(filename, '\t', 2, 0);
  
  % sanity check
  assert(size(data, 1) == count, ...
         ['Number of rows in file (' num2str(count) ') does not ' ...
          'match expected size of Vector (' num2str(size(data, 1)) ').']);

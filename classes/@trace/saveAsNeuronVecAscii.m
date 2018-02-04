function saveAsNeuronVecAscii(a_t, filename)

% saveAsNeuronVecAscii - Writes trace in ASCII file in Neuron simulator Vector format.
%
% Usage:
% saveAsNeuronVecAscii(trace, filename)
%
% Parameters: 
%   a_t: A trace object.
%   filename: (optional) Full path to Neuron file. If omitted, 
%		a_t.id prefixed with 'neuron-vec-' is used as filename in current directory.
%
% Returns:
% 
% Description:
% Data converted to Neuron units of nA and mV. Uses writeNeuronVecAscii.
%
% Example:
%   saveAsNeuronVecAscii(a_trace_obj, 'myvec.dat');
%
% Also see: writeNeuronVecAscii, dlmread, http://www.neuron.yale.edu
%
% Author: Cengiz Gunay <cengique@users.sf.net> 2012/03/23
 
% Copyright (c) 2012 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

  filename = defaultValue('filename', [ 'neuron-vec-' a_t.id '.dat']);
  
  writeNeuronVecAscii(filename, (0:(size(a_t.data, 1) - 1)), a_t.data, ...
                      a_t.dt, a_t.dy, 's', a_t.props.unit_y, a_t.id);

function features = getFeatures(obj, data)

% getFeatures - Extract features from song waveform.
%
% Usage:
% features = getFeatures(obj, data)
%
%   Parameters:
% obj: Songify object
%	data: Raw waveform data
%
% Description:
%
%   Extracts desired features from some waveform.
%
% See also: songify

% Copyright (c) 2015 Benjamin Bolte <bkbolte18@gmail.com>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% Desired features:
%   Syllable duration
%   Mean amplitude
%   Mean pitch
%   Mean entropy
%   Mean pitch goodness
%   Mean mean frequency
%   Pitch variance
%   Entropy variance
%
% See:
%   cceps

features = struct;
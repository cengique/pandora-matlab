function params_row = getParams(dataset, index, a_profile)

% getParams - Get the parameter values of a dataset item.
%
% Usage:
% params_row = getParams(dataset, index)
%
% Description:
%
%   Parameters:
%	dataset: A params_tests_dataset.
%	index: Index of item in dataset.
%		
%   Returns:
%	params_row: Parameter values in the same order of paramNames
%
% See also: itemResultsRow, params_tests_dataset, paramNames, testNames
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/12/06

props = get(a_profile, 'props');

%# These are the order and names:
%#  { 'pulseOn', 'pulseOff', 'traceEnd' 'pAcip', 'pAbias' };
%# 'type', type, 'on', on, 'off', off, 'finish', finish, 'bias', bias, 'pulse',pulse
fnames = fieldnames(dataset.treatments);
tvec = [];
for n = 1:length(fnames)
	tvec(n) = getfield(dataset.treatments, fnames{n});
end
params_row = [props.on, props.off, props.finish, props.pulse, props.bias];
params_row = cat(2, params_row, tvec);


  

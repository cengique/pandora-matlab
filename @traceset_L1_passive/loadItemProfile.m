function [a_profile a_doc] = loadItemProfile(traceset, trace_index)

% loadItemProfile - Loads a cip_trace_profile object from a raw data file in the traceset.
%
% Usage:
% a_profile = loadItemProfile(traceset, trace_index)
%
% Description:
%
%   Parameters:
%	traceset: A physiol_cip_traceset object.
%	trace_index: Index of file in traceset.
%		
%   Returns:
%	a_profile: A profile object that implements the getResults method.
%
% See also: itemResultsRow, params_tests_fileset, paramNames, testNames
%
% $Id: loadItemProfile.m 896 2007-12-17 18:48:55Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/14

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

traceset_props = get(traceset, 'props');

basedir = getFieldDefault(traceset_props, 'baseDir', '');

a_trace = getItem(traceset, trace_index);

% use the template if provided
if isfield(traceset_props, 'fileTempl')
  a_trace = sprintf(traceset_props.fileTempl, a_trace);
end

% load the voltage_clamp object
if ischar(a_trace)
  a_trace = abf2voltage_clamp([ basedir a_trace ], ...
                              [ '-' num2str(trace_index) ], traceset_props);
end

assert(isa(a_trace, 'voltage_clamp'));

% get the results
[a_profile a_doc] = ...
    getResultsPassiveReCeElec(data_L1_passive(a_trace), ...
                              mergeStructs(struct('plotRelDir', [properTeXFilename(get(traceset, 'id')) '/' ]), ...
                                           traceset_props));

% pack it into a cell
a_profile = {results_profile(a_profile, [get(traceset, 'id') ' - Item=' ...
                    num2str(trace_index) ]) a_doc};

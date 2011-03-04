function a_db = params_tests_db(a_cc, props)

% params_tests_db - Extract measurement results.
%
% Usage:
% a_db = params_tests_db(a_cc, props)
%
% Parameters:
%   a_cc: A cip_trace object.
%   props: A structure with any optional properties.
%     stepNum: Current step to get results for (default=2).
%
% Returns:
%   a_db: A params_tests_db with results collected from getResults
%
% Description:
%   Selects cip_level_pA as the only parameter. 
%
% See also: getResults, cip_trace, trace, spike_shape
%
% $Id: params_tests_db.m 818 2007-08-28 20:28:51Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/02/23

% Copyright (c) 20011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

props = ...
    defaultValue('props', struct);

[res profs] = getResults(a_cc, props);

a_db = params_tests_db(1, struct2DB(res), props);

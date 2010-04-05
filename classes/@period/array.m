function an_array = array(period)

% array - Converts the period to an index array. 
%
% Usage:
%   an_array = array(period)
%
% Parameters:
%   period: A period object
%
% Description:
%
% Returns:
%   an_array: An array of dt indices contained within the period.
%
% See also: period, trace
%
% $Id: array.m 818 2007-08-28 20:28:51Z cengiz $
%
% Author: Cengiz Gunay <cengique@users.sf.net>, 2010/03/29

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

an_array = period.start_time:period.end_time;
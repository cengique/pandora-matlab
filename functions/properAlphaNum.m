function a_label = properAlphaNum(a_label)

%  properAlphaNum - Replaces characters in string to make it only alphanumeric.
%
% Usage:
% a_label = properAlphaNum( a_label )
%
% Parameters:
%   a_label: A label string.
%
% Returns:
%   a_label: The corrected proper a_label.
%
% Description:
%   It will only keep the character set 'A-Z a-z 0-9 _'. It will also
% prepend 'a_' if the label starts with a number.
%
% Example: 
% >> a_label = properAlphaNum('to \this _day+1 and ^5')
% ans = 'tothis_day1and5' 
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/01/19

% Copyright (c) 20011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

a_label = regexprep(a_label, '[^A-Za-z0-9_]', '');

% also make sure none start with numerals
a_label = regexprep(a_label, '^([0-9])', 'a_$1');

function a_label = properTeXLabel(a_label)

%  properTeXLabel - Replaces characters in string or cell array of strings to make it valid in TeX documents.
%
% Usage:
% a_label = properTeXLabel( a_label )
%
% Parameters:
%	a_label: A label string.
%
% Returns:
% 	a_label: The corrected proper a_label.
%
% Description:
%   It will replace characters like space, '/', '.', etc.
%
% Example: 
% >> a_label = properTeXLabel('this_day')
% ans = 'this\_day' 
%
% $Id: properTeXLabel.m,v 1.2 2006/08/11 16:53:45 cengiz Exp $
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/01/17

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

a_label = strrep(a_label, '_', ' ');

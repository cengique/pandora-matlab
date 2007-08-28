function handles = fillederrorbar(varargin)

% fillederrorbar - Plots an errorbar with the middle points filled with the pen color.
%
% Usage:
% handles = fillederrorbar(...)
%
% Description:
%
%   Parameters:
%	(see errorbar)
%		
%   Returns:
%	handles: Handles to graphics objects.
%
% See also: 
%
% $Id: fillederrorbar.m,v 1.3 2005/06/16 19:01:22 cengiz Exp $
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/13

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

handles = errorbar(varargin{:});

pairs = reshape(handles, floor(length(handles)/2), 2)';
for h = pairs
  pen_color = get(h(1), 'Color');
  set(h(2), 'MarkerFaceColor', pen_color);
end
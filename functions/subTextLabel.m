function handle = subTextLabel(x, y, text_str, props)

%  subTextLabel - Draws a text label on a plot.
%
% Usage:
% handle = subTextLabel(x, y, text_str, props)
%
% Parameters:
%	x, y: 2D coordinates.
%	text_str: String to be drawn on plot.
%	props: A structure with any optional properties.
%	  Units: position units for the coordinates (see Units in axes properties).
%
% Returns:
%	handle: Text object handle.
%
% Description:
%
% Example: 
%
% $Id: subTextLabel.m,v 1.1 2005/05/08 00:14:01 cengiz Exp $
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/04/11

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props')
  props = struct([]);
end

handle = text(x, y, text_str);

prop_names = fieldnames(props);
num_props = length(prop_names);

% Send all properties to graphics handle
for prop_num=1:num_props

  prop_name = prop_names{prop_num};
  prop_val = props.(prop_name);

  if strcmp(prop_name, 'Units')
    set(handle, 'Units', props.Units);
    set(handle, 'Position', [x y]);
  else
    set(handle, prop_name, prop_val);
  end
end

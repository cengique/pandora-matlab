function h = plotColormap(data, a_colormap, num_colors, props)

% plotColormap - Colormap plot that requires displaying a colorbar.
%
% Usage:
% h = plotColormap(data, a_colormap, num_colors, props)
%
% Parameters:
%   data: 2D matrix with image data or cell array to be passed as
%   	arguments to arbitrary plot command (see props).
%   a_colormap: Colormap vector, function name or handle to colormap (e.g., 'jet').
%   num_colors: Parameter to be passed to the a_colormap.
%   props: A structure with any optional properties.
%     command: Plot command to interpret data (default='image').
%     colorbar: If given, show colorbar on plot.
%     colorbarProps: Set colorbar axis properties.
%     colorbarLabel: Set colorbar y-axis label.
%     truncateDecDigits: Truncate labels to this many decimal digits.
%     maxValue: Maximal value at num_colors to annotate the colorbar.
%     reverseYaxis: If 1, display y-axis values in reverse (default=0).
%		
% Returns:
%   h: Handle to main plot object (e.g., image).
%
% Description:
%   Mainly serves to format the colorbar, which can only be plotted after
% we prepare the main axis. Thus it cannot be easily integrated into
% plot_stack. 
%
% See also: colormap, colorbar
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2006/06/05

% Copyright (c) 2007-2015 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

  props = defaultValue('props', struct);
    
  % run the plot command
  command = getFieldDefault(props, 'command', 'image');
  
  if ~ iscell(data)
    h = feval(command, data);
  else
    h = feval(command, data{:});
  end    

if ~ isfield(props, 'reverseYaxis')
  set(gca, 'yDir', 'normal');
end

% Show up to num_colors
if isa(a_colormap, 'function_handle') || ischar(a_colormap)
  colormap(feval(a_colormap, num_colors)); 
elseif isnumeric(a_colormap) && size(a_colormap, 2) == 3
  colormap(a_colormap);
else
  error('Argument a_colormap not recognized.');
end

% Truncate some digits to unify parameter values estranged by numerical error
if isfield(props, 'truncateDecDigits')
  mult_factor = 10^props.truncateDecDigits;
else
  mult_factor = 10^3;
end

if isfield(props, 'colorbar')
  hc = colorbar;
  
  if isfield(props, 'maxValue')
      max_val = props.maxValue;
  else
      max_val = num_colors;             % Default normalized display
  end
  set(hc, 'YTickMode', 'manual');
  set(hc, 'YTickLabelMode', 'manual');
  if ~ isfield(props, 'colorbarProps') || ~isfield(props.colorbarProps, 'YTickLabel')
    yticks = get(hc, 'YTick');
    set(hc, 'YTickLabel', round(yticks .* max_val .* mult_factor ./ ...
                                num_colors) ./ mult_factor);
  elseif isfield(props, 'colorbarProps')
    % set all passed props
    for prop_field = fieldnames(props.colorbarProps)'
      prop_field = prop_field{1};
      if strcmp(prop_field, 'YTickLabel')
        % round values for display as rquested
        props.colorbarProps.(prop_field) = ...
            round(props.colorbarProps.(prop_field) .* mult_factor) ./ mult_factor;
      end
      set(hc, prop_field, props.colorbarProps.(prop_field));
    end
  end
  
  if isfield(props, 'colorbarLabel')
    % get and set the text object property
    set(get(hc,'YLabel'), 'String', props.colorbarLabel);
  end
end

% scale font to fit measure names on y-axis
num_rows = max(100, size(data, 1));
%set(gca, 'FontUnit', 'normalized', 'FontSize', 1/num_rows);

end

function updateErrorBars(h, w, xtype)
% by Chris Rodgers
% modified from
% http://www.mathworks.com/matlabcentral/fileexchange/33734-update-error-bar-widths-automatically-on-figure-resize/content//updateErrorBars.m
%
% Parameters:
%   h: (Optional) Handle to figure or axis where to find errorbars (default=gca).
%   w, xtype: (Optional) Passed to errorbar_tick.
%
% See: errorbar_tick
%
% Description:
% Code covered by the BSD License.

if ~ exist('h', 'var')
  h = gca;
end

args = {};
if exist('w', 'var')
  args = [ args, {w} ];

  if exist('xtype', 'var')
    args = [ args, {xtype} ];
  end

end

% find all errorbars under handle (figure, axis, etc.)
ch = findobj(h, 'Type', 'hggroup');

for idx=1:numel(ch)
  ui_props = get(ch(idx));
  % skip if not a real errorbar
  if ~ isfield(ui_props, 'UData') continue; end
  errorbar_tick(ch(idx), args{:});
end
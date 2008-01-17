function boxplotp(x,g,notch,sym,vert,whis,props)
% BOXPLOTP - Display boxplots of a data sample.
% 
% Description:
%   BOXPLOTP(X,NOTCH,SYM,VERT,WHIS,PROPS) produces a box and whisker plot for
%   each column of X. The box has lines at the lower quartile, median, 
%   and upper quartile values. The whiskers are lines extending from 
%   each end of the box to show the extent of the rest of the data. 
%   Outliers are data with values beyond the ends of the whiskers.
%
%   NOTCH = 1 produces a notched-box plot. Notches represent a robust 
%   estimate of the uncertainty about the medians for box to box comparison.
%   NOTCH = 0 (default) produces a rectangular box plot. 
%   SYM sets the symbol for the outlier values if any (default='+'). 
%   VERT = 0 makes the boxes horizontal (default: VERT = 1, for vertical).
%   WHIS defines the maximum length of the whiskers as a function of the
%   IQR (default = 1.5).  The whisker extends to the most extreme data
%   value within WHIS*IQR of the box.  If WHIS = 0 then BOXPLOTP displays
%   all data values outside the box using the plotting symbol, SYM.   
%
%   PROPS contains optional information:
%	nooutliers: Does not indicate any outliers on the plot.
%	noXLabel: No X-axis label.
%	noYLabel: No Y-axis label.
%
%   BOXPLOTP(X,G,NOTCH,...) produces a box and whisker plot for the vector
%   X grouped by G.  G is a grouping variable defined as a vector, string
%   matrix, or cell array of strings.  G can also be a cell array of 
%   several grouping variables (such as {G1 G2 G3}) to group the values
%   in X by each unique combination of grouping variable values.
% 
%   BOXPLOTP calls BOXUTILP to do the actual plotting.

%   If there are no data outside the whisker, then, there is a dot at the 
%   bottom whisker, the dot color is the same as the whisker color. If
%   a whisker falls inside the box, we choose not to draw it. To force
%   it to be drawn at the right place, set whissw = 1.

% Modified by Cengiz Gunay <cgunay@emory.edu>, 2004/11/12
%   Made outlier display optional. Also some plot decorations are now optional.

%   Copyright 1993-2002 The MathWorks, Inc. 
%   $Revision: 1.2 $  $Date: 2004/11/15 23:20:51 $

if (nargin==1 & length(x(:))==1 & ishandle(x)), resizefcn(x); return; end

whissw = 0; % don't plot whisker inside the box.

if ~ exist('props')
  props = struct([]);
end

[m n] = size(x);
if min(m,n) > 1 
    xx = x(:,1);
    yy = xx;
else
    n = 1;
    xx = x;
    yy = x;
end

% If the 2nd arg is not a grouping variable, shift arguments
nargs = nargin;
if (nargin<2)
   g = [];
elseif (nargin>1 & (isequal(g,1) | isequal(g,0)))
   if (nargin>5), props = whis; end
   if (nargin>4), whis = vert; end
   if (nargin>3), vert = sym; end
   if (nargin>2), sym = notch; end
   notch = g;
   g = [];
else
   nargs = nargin - 1;
end

if (nargs < 2 | isempty(notch)), notch = 0; end
if (nargs < 3 | isempty(sym)), sym = 'r+'; end
if (nargs < 4 | isempty(vert)), vert = 1; end
if (nargs < 5 | isempty(whis)), whis = 1.5; end

% Deal with grouping variable
xorig = x;
gorig = g;
xvisible = NaN*ones(size(x));
included = 1:prod(size(x));
if (~isempty(g))
   x = x(:);
   
   if (vert)
      sep = '\n';
   else
      sep = ',';
   end

   [g,glabel,gname,multigroup] = mgrp2idx(g,size(x,1),sep);
   n = size(gname,1);
   gorig = g;
   
   k = (isnan(g) | isnan(x));
   if (any(k))
      x(k) = [];
      g(k) = [];
      included(k) = [];
   end
end

lb = 1:n;

xlims = [0.5 n + 0.5];

k = find(~isnan(x));
ymin = min(min(x(k)));
ymax = max(max(x(k)));
dy = (ymax-ymin)/20;
ylims = [(ymin-dy) (ymax+dy)];

lf = n*min(0.15,0.5/n);

% Scale axis for vertical or horizontal boxes.
cla
set(gca,'NextPlot','add','Box','on');
if vert
    axis([xlims ylims]);
    set(gca,'XTick',lb);
    if ~isfield(props, 'noYLabel'), set(gca,'YLabel',text(0,0,'Values')); end
    if (isempty(g) && ~isfield(props, 'noXLabel'))
      set(gca,'XLabel',text(0,0,'Column Number')); end
else
    axis([ylims xlims]);
    set(gca,'YTick',lb);
    if ~isfield(props, 'noXLabel'), set(gca,'XLabel',text(0,0,'Values')); end
    if (isempty(g) && ~isfield(props, 'noYLabel')), 
      set(gca,'YLabel',text(0,0,'Column Number')); end
end

if (~isempty(g))
   for i=1:n
      thisgroup = (g==i);
      z = x(thisgroup);
      pts = included(thisgroup);
      pts = pts(boxutilp(z,notch,lb(i),lf,sym,vert,whis,whissw,props));
      xvisible(pts) = xorig(pts);
   end

   if (multigroup & vert)
      % Turn off tick labels and axis label
      set(gca, 'XTickLabel','','UserData',size(gname,2));
      xlabel('');
      ylim = get(gca, 'YLim');
      
      % Place multi-line text approximately where tick labels belong
      for j=1:n
         ht = text(j,ylim(1),glabel{j,1},'HorizontalAlignment','center',...
              'VerticalAlignment','top', 'UserData','xtick');
      end

      % Resize function will position text more accurately
      set(gcf, 'ResizeFcn', sprintf('boxplotp(%d)', gcf), ...
               'Interruptible','off', 'PaperPositionMode','auto');
      resizefcn(gcf);
   elseif (vert)
      set(gca, 'XTickLabel',glabel);
   else
      set(gca, 'YTickLabel',glabel);
   end

elseif n==1
   thisgroup = ~isnan(yy);
   vec = find(thisgroup);
   if ~isempty(vec)
      pts = included(thisgroup);
      pts = pts(boxutilp(yy(vec),notch,lb,lf,sym,vert,whis,whissw,props));
      xvisible(pts) = xorig(pts);
   end
else
   g = repmat(1:n,size(x,1),1);
   notnan = ~isnan(x);
   for i=1:n
      thisgroup = (g==i) & notnan;
      z = x(thisgroup);
      if ~isempty(z)
         pts = included(thisgroup);
         pts = pts(boxutilp(z,notch,lb(i),lf,sym,vert,whis,whissw,props));
         xvisible(pts) = xorig(pts);
      end
   end
end
set(gca,'NextPlot','replace');

% Store information for gname
set(gca, 'UserData', {'boxplotp' xvisible gorig vert});


function resizefcn(f)
% Adjust figure layout to make sure labels remain visible
h = findobj(f, 'UserData','xtick');
if (isempty(h))
   set(f, 'ResizeFcn', '');
   return;
end
ax = get(f, 'CurrentAxes');
nlines = get(ax, 'UserData');

% Position the axes so that the fake X tick labels have room to display
set(ax, 'Units', 'characters');
p = get(ax, 'Position');
ptop = p(2) + p(4);
if (p(4) < nlines+1.5)
   p(2) = ptop/2;
else
   p(2) = nlines + 1;
end
p(4) = ptop - p(2);
set(ax, 'Position', p);
set(ax, 'Units', 'normalized');

% Position the labels at the proper place
xl = get(gca, 'XLabel');
set(xl, 'Units', 'data');
p = get(xl, 'Position');
ylim = get(gca, 'YLim');
p2 = (p(2)+ylim(1))/2;
for j=1:length(h)
   p = get(h(j), 'Position') ;
   p(2) = p2;
   set(h(j), 'Position', p);
end

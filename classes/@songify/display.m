function s = display(t)

% Generic object display method.
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/04

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

num = size(t);
if max(num) > 1
  s = [ '[' sprintf('%dx', num(1:(end-1))) num2str(num(end)) ' ' class(t) ']' ];
  disp(s);
  displayHelperFunction(t(1));
else
  s = sprintf('%s, id=%s', class(t), t.id);
  disp(s);
  displayHelperFunction(t);
end

function displayHelperFunction(t)

% m = '   ';
% 
% for i=1:n
%   m = [m, '   '];
% end
% 
% f = fields(t);
% 
% if numel(f) == 0
%   fprintf('%s<Empty>\n', m);
% else
%   for i=1:numel(f)
%     if isa(t.(f{i}), 'struct')
%       fprintf('%s--> %s\n', m, f{i});
%       displayHelperFunction(t.(f{i}), n+1);
%     else
%       fprintf('%s--> %s\n', m, f{i});
%     end
%   end
% end

f = fields(t);

disp(struct(t))

for i=1:numel(f)
  if isa(t.(f{i}), 'struct')
    disp(f{i});
    disp('----------------------');
    displayHelperFunction(t.(f{i}));
  end
end

function s = display(t)

% Generic object display method.
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/04

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% Handle differently if an array of DBs
if length(t) > 1
  disp(t);
  return;
end

disp(sprintf('%s, %s', class(t), get(t, 'id')));

display(t.param_func)

disp(sprintf('\nComposed of subfunctions: '));

disp(t.f)

disp('{');

funcs_cell = struct2cell(t.f);
funcs_names = fieldnames(t.f);
for num_f = 1:length(funcs_names)
  disp([ '*** ' funcs_names{num_f} ' *** => ' ]);
  display(funcs_cell{num_f})
end

disp('}')


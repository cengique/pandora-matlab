function s = displayXPP(a_pm, props)

% displayXPP - Export the function in a format compatible with XPPAUTO.
%
% Usage:
%   s = displayXPP(a_pm, props)
%
% Parameters:
%   a_pm: A param_func, or subclass, object.
%   props: A structure with any optional properties.
%     trans2XPP: Use this function to translate the parameters into the
%               XPP format (e.g., '@(a_fs) getParams(a_fs)'. It is
%               inherited from a_pm.props
%
% Returns:
%   s: A string that can be written in a XPPAUTO input file.
%
% Description:  
%   
% Example:
% >> string2File(displayXPP(a_pm), 'myxppfile.ode')
%
% $Id: param_func.m 129 2010-06-10 22:36:44Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/01/19

% Copyright (c) 2011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

props = defaultValue('props', struct);
s = { displayXPP(a_pm.param_func, props) };

funcs_cell = struct2cell(a_pm.f);
funcs_names = fieldnames(a_pm.f);
for num_f = 1:length(funcs_names)
  s = [s; {displayXPP(funcs_cell{num_f}, props)} ];
end

% convert to vertical string array by aligning widths
s = char(s);

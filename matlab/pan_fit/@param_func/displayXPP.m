function s = displayXPP(a_pf, props)

% displayXPP - Export the function in a format compatible with XPPAUTO.
%
% Usage:
%   s = displayXPP(a_pf, props)
%
% Parameters:
%   a_pf: A param_func, or subclass, object.
%   props: A structure with any optional properties.
%     trans2XPP: Use this function to translate the parameters into the
%               XPP format (e.g., '@(a_fs) getParams(a_fs)'. It is
%               inherited from a_pf.props
%
% Returns:
%   s: A string that can be written in a XPPAUTO input file.
%
% Description:  
%   This is a placeholder method that just returns the function name or
% the description of the anonymous function. Subclasses or specific
% instances should overwrite this function or put a translator in props.trans2XPP
%   
% Example:
% >> string2File(displayXPP(a_pf), 'myxppfile.ode')
%
% $Id: param_func.m 129 2010-06-10 22:36:44Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/01/19

% Copyright (c) 2011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% Accept vector input and treat it differently.
% (This should be copied into subclasses for convenience.)
num_pfs = length(a_pf);
if num_pfs > 1
  s = [];
  for pf_num = 1:num_pfs
    s = [s, displayXPP(a_pf(pf_num))];
  end
  return;
end

props = defaultValue('props', struct);

% inherit props
props = mergeStructs(props, get(a_pf, 'props'));

if isfield(props, 'trans2XPP') % props highest prio
  s = feval(props.trans2XPP, a_pf);
elseif ismethod(a_pf, 'trans2XPP') % class method 2nd choice
  s = trans2XPP(a_pf);
else
  % default is to display the function and parameter values
  label = getFieldDefault(props, 'label', get(a_pf, 'id'));
  s = [ properAlphaNum(label) ' = ' func2str(get(a_pf, 'func')) ];
  params = getParamsStruct(a_pf);
  if length(params) > 0
    s = strcat(s, evalc('display(params)'));
  end
end

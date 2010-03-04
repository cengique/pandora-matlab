function a_ps = setParams(a_ps, param_vals, props)

% setParams - Sets the parameters of all contained functions.
%
% Usage:
%   a_ps = setParams(a_ps, param_vals, props)
%
% Parameters:
%   a_ps: A param_mult object.
%   param_vals: Vector of new parameter values.
%   props: A structure with any optional properties.
%     (rest passed to param_func/setParams)
%		
% Returns:
%   a_ps: Object with new parameter values.
%
% Description:
%
% Example:
% Set absolute parameter values:
%   >> a_ps = setParams(a_ps, [10 20])
% Set relative ratios:
%   >> a_ps = setParams(a_ps, [.4 .7], struct('direct', 1))
%
% See also: param_func, param_mult
%
% $Id: func.m 1174 2009-03-31 03:14:21Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2009/12/09

% Copyright (c) 2009 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if ~ exist('props', 'var')
  props = struct;
end

param_ind = 1;
a_ps_props = get(a_ps, 'props');
if isfield(props, 'onlySelect') && props.onlySelect == 1 ...
      && isfield(a_ps_props, 'selectParams')
  f_size = length(a_ps_props.selectParams);
else
  f_size = dbsize(a_ps.param_func, 2);
end
a_ps.param_func = ...
    setParams(a_ps.param_func, ...
              param_vals(param_ind:(param_ind - 1 + f_size)), props);
param_ind = param_ind + f_size;

new_fs = struct2cell(a_ps.f)';
fs_names = fieldnames(a_ps.f);
for f_num = 1:length(new_fs)
  a_f = new_fs{f_num};
  a_f_props = get(a_f, 'props');
  if isfield(props, 'onlySelect') && props.onlySelect == 1 ...
      && isfield(a_f_props, 'selectParams')
    f_size = length(a_f_props.selectParams);
  else
    f_size = dbsize(a_f, 2);
  end
  new_fs{f_num} = ...
      setParams(a_f, param_vals(param_ind:(param_ind - 1 + f_size)), ...
                     props);
  param_ind = param_ind + f_size;
end

% update list of functions
a_ps = set(a_ps, 'f', cell2struct(new_fs', fs_names, 1));
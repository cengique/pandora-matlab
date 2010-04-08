function a_pf = param_func_nil(value, id, props)
  
% param_func_nil - A null function, returns constant value.
%
% Usage:
%   a_pf = param_func_nil(value, id, props)
%
% Parameters:
%   value: Constant value to return.
%   id: An identifying string for this function.
%   props: A structure with any optional properties.
% 	   (Rest passed to param_func)
%		
% Returns: 
%   a_pf: A a param_func object that always returns a constant value.
%
% Description:
%
% Example:
% >> m_ClCa = param_func_nil(1, 'm_ClCa');
%
% See also: param_func
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/01/17

  if ~ exist('props', 'var')
    props = struct;
  end

  if ~ exist('value', 'var')
    value = 0;
  end
  
  if ~ exist('id', 'var')
    id = ['Constant (' num2str(value) ') function'];
  end
  
  a_pf = ...
    param_func({'undefined', 'constant'}, [], {}, ...
               @(p, c) deal(value, NaN), ...
               id, props);
end

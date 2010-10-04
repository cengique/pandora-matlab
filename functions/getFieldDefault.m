function value = getFieldDefault(strc, f, def_val)

% getFieldDefault - Get a field from a struct and return the default_value if field does not exist.
%
% Usage:
% value = getFieldDefault(structure, fieldname, default_value)
%
% Parameters:
%   fieldname: Field name.
%   default_value: Value to return if field doesn't exist.
%
% Author: Li, Su - 2007
% Modified: Cengiz Gunay - 2009
  
  try
    value = strc.(f);
  catch err
    if strcmp(err.identifier, 'MATLAB:nonExistentField')
      value = def_val;
    else 
      throw(err);
    end      
  end
% $$$   
% $$$   
% $$$   if isfield(strc, f)
% $$$     if exist('props', 'var') && isfield(props, 'fuzzy')
% $$$       value = getfuzzyfield(strc, f);
% $$$     else
% $$$       value = strc.(f);
% $$$     end
% $$$   else
% $$$     value = def_val;
% $$$   end
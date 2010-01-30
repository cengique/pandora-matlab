function value=getFieldDefault(strc, f, def_val)
% value = getFieldDefault(structure, fieldname, default_value)
%
% get a field from a struct and return the default_value if field does
% not exist. fieldname is case insensitive, can also be
% the beginning part. If there is no field begin with the fieldname, it
% returns a empty string ''.
%
% Author: Li, Su - 2007
% Modified: Cengiz Gunay - 2009
  
  if isfield(strc, f)
    value = getfuzzyfield(strc, f);
  else
    value = def_val;
  end
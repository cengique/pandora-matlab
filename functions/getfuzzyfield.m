function value=getfuzzyfield(strc, f, def_val)

% value = getfuzzyfield(structure, fieldname, def_val)
%
% get a field from a struct. fieldname is case insensitive, can also be
% the beginning part. If there is no field begin with the fieldname, it
% returns def_val or empty string is not provided.
%
% Author: Li, Su - 2007
  
  def_val = defaultValue('def_val', '');
  
    if ~isstruct(strc)
        error('Invalid input argument.');
    end

    f=lower(f);
    FS=fieldnames(strc);
    fs=lower(FS);
    idx=strmatch(f,fs);
    if isempty(idx)
        value=def_val;
    else
        value=strc.(FS{idx(1)});
    end
end
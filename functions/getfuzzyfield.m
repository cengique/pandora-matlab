function value=getfuzzyfield(strc, f)
% value = getfuzzyfield(structure, fieldname)
%
% get a field from a struct. fieldname is case insensitive, can also be
% the beginning part. If there is no field begin with the fieldname, it
% returns a empty string ''.
%
% Author: Li, Su - 2007
  
    if ~isstruct(strc)
        error('Invalid input argument.');
    end

    f=lower(f);
    FS=fieldnames(strc);
    fs=lower(FS);
    idx=strmatch(f,fs);
    if isempty(idx)
        value='';
    else
        value=strc.(FS{idx(1)});
    end
end
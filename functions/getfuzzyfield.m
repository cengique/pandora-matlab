function value=getfuzzyfield(strc, f, def_val, isexact)

% value = getfuzzyfield(structure, fieldname, def_val, isexact)
%
% get a field from a struct. fieldname is case insensitive, can also be
% the beginning part. If there is no field begin with the fieldname, it
% returns def_val or empty string is not provided. If isexact is 1, only
% return exact matches.
%
% Author: Li, Su - 2007
  
  def_val = defaultValue('def_val', '');
  
    if ~isstruct(strc)
        error('Invalid input argument.');
    end

    f=lower(f);
    FS=fieldnames(strc);
    fs=lower(FS);
    if defaultValue('isexact', 0) == 1
      idx = find(strcmp(f, fs));
    else
      idx=strmatch(f,fs);
    end
    if isempty(idx)
      value=def_val;
    elseif length(idx) > 1
      error([ 'Ambiguous match for ''' f ''' between field names: ' ...
              sprintf('''%s'', ', FS{idx}) '. Meant to use argument isexact?' ]);
    else
      value=strc.(FS{idx(1)});
    end
end
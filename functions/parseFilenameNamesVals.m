function names_vals = parseGenesisFilename(raw_filename)

% parseGenesisFilename - Parses the GENESIS filename to get names and values of simulation parameters.
% Usage:
% names_vals = parseGenesisFilename(filename)
%
% Description:
%	Parameters:
%		filename: GENESIS filename (no need to exist)
%		
%	Returns:
%		names_vals: A two-column cell array with names and values.
%
% Available methods:
%	See methods('cip_profile_brute')
%
% See also: cip_profile
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/03/10

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

[path, filename, ext] = fileparts(raw_filename);

sep_indices = [ 0 strfind(filename, '_') ];

% skip initial word tokens
for word_num=1:length(sep_indices)
  valstr = filename(sep_indices(word_num) + 1 : sep_indices(word_num + 1) - 1);
  if isstrprop(valstr(1), 'digit') || valstr(1) == '+' || valstr(1) == '-' || ...
    (valstr(1) == 'm' && isstrprop(valstr(2), 'digit'))
    % break if first letter is a digit or arithmetic sign
    %all(isstrprop(valstr, 'digit')) % is all digits?
    break;
  end
end

for param_num=1:floor((length(sep_indices) - word_num + 1) / 2)
  % Get the value from here to the first separator
  index = 2 * param_num + word_num - 1;
  valstr = filename(sep_indices(index - 1) + 1 : sep_indices(index) - 1);
  val = getVal(valstr);
  try 
    % find the second separator
    param_name = ...
	filename(sep_indices(index) + 1 : sep_indices(index + 1) - 1);
  catch
    errstr = lasterror;

    if strcmp(errstr.identifier, 'MATLAB:exceedsdims') || ...
       strcmp(errstr.identifier, 'MATLAB:badindex') || ... % Changed in Matlab R14
       strcmp(errstr.identifier, 'MATLAB:badsubscript') % Changed *again* in R14 SP3 ??
      % Try to find a dot if the final '_' is missing
      dot_indices = strfind(filename(sep_indices(index) + 1 : end), '.');

      if length(dot_indices) > 0 
	param_name = ...
	    filename(sep_indices(index) + 1 : ...
		     sep_indices(index) + dot_indices(1) - 1);
      else
	% Then simply use the end of the filename
	param_name = filename(sep_indices(index) + 1 : end);
      end
    end
  end
  names_vals(param_num, :) = {param_name, val};
end

% If value starts with an 'm', it means minus
function val = getVal(str)
  if str(1) == 'm'
    str(1) = '-';
  end
  val = str2num(str);

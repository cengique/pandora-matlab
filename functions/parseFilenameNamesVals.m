function [names_vals, pre_name] = parseFilenameNamesVals(raw_filename, props)

% parseFilenameNamesVals - Parses filename to extract names and values of parameters.
% 
% Usage:
% names_vals = parseFilenameNamesVals(filename, props)
%
% Parameters:
%   filename: file name (no need to exist)
%   props: Structure with optional properties:
%     namesFirst: If 1, names precede values (default=1).
%     skipNum: Number of words to skip (default=0). If -1, all
%     		words are skipped until a number is found. this
%     		makes sense when namesFirst=0.
%		
% Returns:
%   names_vals: A two-column cell array with names and values.
%   pre_name: (Optional) Skipped prefix words in the filename.
%
% Description:
%   Parses the given string (e.g., filename) that has names and
% values separated by underscores (_). 
%
% Example:
% Names first:
% >> nv = parseFilenameNamesVals('hello_boys_6_girls_4.txt', struct('skipNum', 1))
% nv = 
%    'girls'    [6]
%    'boys'     [4]
% Same result with values first:
% >> nv = parseFilenameNamesVals('data/hello_6_girls_4_boys.txt',
% 		struct('namesFirst', 0, 'skipNum', -1))
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/03/10
% Modified: CG <cengique@users.sf.net>, 2014/03/17
% 		Added optional properties for order of name-val
% 		pairs, number of words to skip, and return prefix words.

% Copyright (c) 2007-2014 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

  props = defaultValue('props', struct);
  names_first = getFieldDefault(props, 'namesFirst', 1);
  skip_num = getFieldDefault(props, 'skipNum', 0);
  
[path, filename, ext] = fileparts(raw_filename);

sep_indices = [ 0 strfind(filename, '_') ];

if (skip_num == -1)
  % special for namesFirst == 0: skip initial word tokens
  for word_num=1:length(sep_indices)
    valstr = filename(sep_indices(word_num) + 1 : sep_indices(word_num + 1) - 1);
    if isstrprop(valstr(1), 'digit') || valstr(1) == '+' || valstr(1) == '-' || ...
          (valstr(1) == 'm' && isstrprop(valstr(2), 'digit'))
      % break if first letter is a digit or arithmetic sign
      %all(isstrprop(valstr, 'digit')) % is all digits?
      break;
    end
  end
else
  % otherwise point to next
  word_num = skip_num + 1;
end

pre_name = filename(1:max(1, sep_indices(word_num) - 1));

for param_num=1:floor((length(sep_indices) - word_num + 1) / 2)
  % Get the value from here to the first separator
  index = 2 * param_num + word_num - 1;
  leftstr = ...
      filename(sep_indices(index - 1) + 1 : sep_indices(index) - 1);
  
  if (index < length(sep_indices))
    rightlimit = sep_indices(index + 1) - 1;
  else
    rightlimit = length(filename);
  end
  rightstr = ...
      filename(sep_indices(index) + 1 : rightlimit);
  
  if (names_first == 1)
    param_name = leftstr;
    val = getVal(rightstr);
  else
    param_name = rightstr;
    val = getVal(leftstr);
  end
  
  names_vals(param_num, :) = {param_name, val};
end

% If value starts with an 'm', it means minus
function val = getVal(str)
  if str(1) == 'm'
    str(1) = '-';
  end
  val = str2num(str);

  % obsolete:
  % $$$   try 
% $$$     % find the second separator
% $$$     param_name = ...
% $$$ 	filename(sep_indices(index) + 1 : sep_indices(index + 1) - 1);
% $$$   catch
% $$$     errstr = lasterror;
% $$$ 
% $$$     if strcmp(errstr.identifier, 'MATLAB:exceedsdims') || ...
% $$$        strcmp(errstr.identifier, 'MATLAB:badindex') || ... % Changed in Matlab R14
% $$$        strcmp(errstr.identifier, 'MATLAB:badsubscript') % Changed *again* in R14 SP3 ??
% $$$       % Try to find a dot if the final '_' is missing
% $$$       dot_indices = strfind(filename(sep_indices(index) + 1 : end), '.');
% $$$ 
% $$$       if length(dot_indices) > 0 
% $$$ 	param_name = ...
% $$$ 	    filename(sep_indices(index) + 1 : ...
% $$$ 		     sep_indices(index) + dot_indices(1) - 1);
% $$$       else
% $$$ 	% Then simply use the end of the filename
% $$$ 	param_name = filename(sep_indices(index) + 1 : end);
% $$$       end
% $$$     end
% $$$   end

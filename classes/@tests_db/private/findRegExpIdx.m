function idx = findRegExpIdx(a_regexp, all_names)

% findRegExpIdx - Find name indices from a regular expression.
%
% Usage:
% idx = findRegExpIdx(a_regexp, all_names)
%
% Description:
%
%   Parameters:
%	a_regexp: A regular expression string quoted with slashes (e.g. '/a.*/')
%	all_names: Cell array of strings to match.
%		
%   Returns:
%	idx: Array of column indices, or NaN if a_regexp is not a properly quoted.
%
% See also: tests_db/tests2idx
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2008/04/16

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% It's a regular expression if starts and ends with slashes
  a_regexp = regexp(a_regexp, '^\/(.*)\/$', 'tokens');
  if ~isempty(a_regexp)
    a_regexp = a_regexp{1};
    idx = find(cellfun(@(x)(~isempty(x)), ...
                       regexp(all_names, a_regexp)));
  else
    idx = NaN;
  end

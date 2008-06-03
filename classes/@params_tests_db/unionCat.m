function a_db=unionCat(db, varargin)
% unionCat - Vertically concatenate two or more databases with different parameters or tests.
%
% Usage:
% a_db = unionCat(db, with_db, ...)
%
% Parameters:
%	db, with_db, ...: tests_db objects to be concatenated together.
%
% Description:
%   The parameters and tests in the result are a union of both. Adds 0 for
% parameter and NaN for tests in the rows which didn't have the additional
% columns before.
%
% $Id$
%
% Author: Li Su, 2008-04-10

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if length(varargin)>1
  with_db = unionCat(varargin{1}, varargin{2:end});
elseif isempty(varargin)
  a_db = db;
  return;
else
  with_db = varargin{1};
end

a_db = unionCatTwo(db, with_db, struct('offsetTracesets', 1));

function results = mergeStructs(varargin)

%  mergeStructs - Merges all the structures given as arguments and makes a single structure.
%
% Usage:
% results = mergeStructs( struct1 [, struct2, ...] )
%
% Parameters:
%	struct(n): A structure.
%
% Returns:
% 	results: The merged structure.
%
% Description:
%   The fields will in earlier arguments will have priority. So, while merging two
% structs, if there are duplicate fields, the fields in the first will be preserved.
%
% Example: 
% mergeStructs( struct('hello', 1), struct('bye', 2) );
%  => struct('hello', 1, 'bye', 2)
%
% $Id: mergeStructs.m,v 1.4 2006/08/11 16:53:26 cengiz Exp $
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/13

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

valcell = {};
fieldcell = {};

for k=1:nargin
  % Be nice
  if ~isempty(varargin{k})
    fields = fieldnames(varargin{k});
    [newfields newidx] = setdiff(fields, fieldcell);
    fieldcell = { fieldcell{:}, newfields{:}};
    val = struct2cell(varargin{k});
    valcell = { valcell{:}, val{newidx}};
  end
end

% Be even nicer
if nargin > 0
  results = cell2struct(valcell, fieldcell, 2);
else
  results = struct([]);
end

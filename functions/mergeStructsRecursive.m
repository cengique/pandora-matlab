function results = mergeStructsRecursive(varargin)

%  mergeStructsRecursive - Merges given structures into a single structure, merging substructures recursively.
%
% Usage:
% results = mergeStructsRecursive( struct1 [, struct2, ...] )
%
% Parameters:
%	struct(n): A structure.
%
% Returns:
% 	results: The merged structure.
%
% Description:
%   The fields will in earlier arguments will have priority. So, while merging two
% structs, if there are duplicate fields, the fields in the first will be
% preserved. If a common field is a structure, then mergeStructsRecursive
% is called to merge their contents.
%
% Example: 
% >> mergeStructsRecursive( struct('hello', struct('a', 1), 
%			    struct('hello', struct('b', 2)) );
%  => struct('hello', struct('a', 1, 'b', 2)
%
% $Id: mergeStructsRecursive.m,v 1.4 2006/08/11 16:53:26 cengiz Exp $
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
    % find common fields and look for structures
    [commonfields common_idx] = intersect(fieldcell, fields);
    if ~isempty(common_idx)
      for common_id = common_idx
        left_struct = valcell{common_id};
        if isstruct(left_struct)
          valcell{common_id} = ...
              mergeStructsRecursive(left_struct, getfield(varargin{k}, fieldcell{common_id}));
        end
      end
    end
    % find new fields on right-hand-side argument
    [newfields newidx] = setdiff(fields, fieldcell);
    % add to existing fields and values
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

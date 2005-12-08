function b = subsref(a,index)
% subsref - Defines generic indexing for objects.

  %# INCONSISTENCY WARNING: If builtin subsref is used, the syntax "struct_arr.field"
  %# produces a cell array of the field contents in each of the structure array indices.
  %# However, here we return a regular array of tests_dbs. TODO: Maybe change this 
  %# to return cell array to be consistent with matlab convention. -CG 2005/12/08

if size(index, 2) > 1
  %# if a sequence of indexing operators present
  first = subsref(a, index(1));
  %# recursive
  b = subsref(first, index(2:end));
else
  switch index.type
    case '()'
      if length(index.subs) == 1
	b = a(index.subs{1});
      else
	b = onlyRowsTests(a, index.subs{:});
      end
    case '.'
      num_dbs = length(a);
      %# If multiple DBs addressed at the same time
      if num_dbs > 1
	%# Do one to learn the return type
	tmp = subsref(a(1), index);
	b(1) = tmp;			%# meaningless, but the only way to make it work
	%# allocate space
	[b(2:num_dbs)] = deal(tmp); 
	%# and time
	for db_num=2:num_dbs
	  %# Recurse
	  b(db_num) = subsref(a(db_num), index);
	end
      else
	%# Ground case: only one DB, only one index
	b = get(a, index.subs); 
      end
    case '{}'
      b = a{index.subs{:}};
  end
end

function b = get(a, attr)
% get - Defines generic attribute retrieval for objects.
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/14

%# If input is an array, then also return array
num_items = length(a);
if num_items > 1 
  %# Create array of outputs
  for item_num = 1:num_items
    b(item_num) = get(a(item_num), attr);
  end
  return;
end

try
  b = getfield(struct(a), attr);
catch
  rethrow(lasterror);
end

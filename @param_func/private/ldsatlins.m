function m = ldsatlins(n) 

% recurse if the input is an array
num_items = length(n);
if num_items > 1
  m = repmat(NaN, size(n));
  for i=1:num_items
    m(i) = ldsatlins(n(i));
  end
  return;
end

% else it is the single input case
if n <= 0
     m=0;
elseif 0 <= n && n <= 1
         m=n;
elseif 1 <= n
         m=1;
end
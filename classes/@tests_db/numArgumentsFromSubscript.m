% required for subsref to work in Matlab R2016+
function n = numArgumentsFromSubscript(obj,s,indexingContext)
   if indexingContext == matlab.mixin.util.IndexingContext.Expression
     n = 1;
   else
     n = length(s(1).subs{:});
   end
end
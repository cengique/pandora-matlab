function traceset_index = item2TracesetIndex( a_pbundle, an_item )
  if isa(an_item, 'tests_db')
    if ismember(getColNames(an_item), 'TracesetIndex') 
      traceset_index = get(onlyRowsTests(an_item, ':', 'TracesetIndex'), ...
                           'data');
      if ~ isnan(traceset_index), return, end
    end        

    % if no traceset, use all other parameters to find a match
    p_db = get(a_pbundle, 'db');
    common_cols = ...
        checkConsistentCols(p_db, an_item, ...
                            struct('useCommon', 1));
    % make a for loop for each row, or use anyRows
    traceset_index = ...
        get(onlyRowsTests(p_db, ...
                          anyRows(onlyRowsTests(p_db, ':', common_cols), ...
                                  onlyRowsTests(an_item, ':', common_cols)), ...
                          'TracesetIndex'), 'data');
  else
    traceset_index = an_item;
  end
  
end
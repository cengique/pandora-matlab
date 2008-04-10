function a_db=unionCat(db, with_db)
% vertically concatenate two databases with different parameters or tests.
% The parameters and tests in the result are a union of both. Add 0 for
% parameter and NaN for tests in the rows which didn't have the additional
% columns before.

% deal with different columns
with_names=getColNames(with_db);
names=getColNames(db);

% add columns in db but not in with_db.
dif_names = setdiff(names,with_names);
col_idx=get(db, 'col_idx');
dif_idx = cellfun(@(x)col_idx.(x), dif_names);
dif_params = dif_names(dif_idx <= db.num_params);
if ~isempty(dif_params)
    with_db = addParams(with_db, dif_params, zeros(dbsize(with_db,1),length(dif_params)));
end
dif_columns = dif_names(dif_idx > db.num_params);
if ~isempty(dif_columns)
    with_db = addColumns(with_db, dif_columns, zeros(dbsize(with_db,1),length(dif_columns))+NaN);
end
% take the maximum of tracesetIndex
data=get(db,'data');
max_idx=max(data(:,col_idx.TracesetIndex));

% add columns in with_db but not in db.
dif_names=setdiff(with_names,names);
col_idx=get(with_db, 'col_idx');
dif_idx=cellfun(@(x)col_idx.(x),dif_names);
dif_params=dif_names(dif_idx<=with_db.num_params);
if ~isempty(dif_params)
    db=addParams(db, dif_params, zeros(dbsize(db,1),length(dif_params)));
end
dif_columns=dif_names(dif_idx>with_db.num_params);
if ~isempty(dif_columns)
    db=addColumns(db, dif_columns, zeros(dbsize(db,1),length(dif_columns))+NaN);
end
% change TracesetIndex
data = get(with_db, 'data');
data(:, col_idx.TracesetIndex)=data(:, col_idx.TracesetIndex)+max_idx;
with_db = set(with_db,'data',data);

a_db=[db; with_db];

% merge props
props=get(db,'props');
with_props=get(with_db,'props');
commonfield=intersect(fieldnames(props), fieldnames(with_props));
for field={commonfield{:}}
    if isstruct(props.(field{1}))
        props.(field{1})=mergeStructs(props.(field{1}),with_props.(field{1}));
    elseif iscell(props.(field{1})) || isnumeric(props.(field{1}))
        props.(field{1})=[props.(field{1}), with_props.(field{1})];
    end
end
props=mergeStructs(props, with_props); % a union of both fields.

a_db = set(a_db, 'props', props );


function a_db = reIndexNeurons(a_db, startNum, colName)
% Re-index neurons with accending numbers. This is useful for avoiding
% NeuronId conflicts when concatenating two databases. It can also remove
% the unused number 'hole' (e.g. after deleting rows) and make the
% indices continuous.
% 
%  new_db = reIndexNeurons(a_db, startNum, colName)
% 
% a_db: a tests_db object
% startNum: the starting index number (default = 1)
% colName: the column name or number of neuron index. (default = 'NeuronId')
% new_db: a new database with new neuron index.
%
% SEE ALSO 

% Li Su. 03/21/2008

startNum = default('startNum',1);
colName = default('colName','NeuronId');

data = get(a_db, 'data');
col_name_cell = fieldnames(get(a_db, 'col_idx'));
colIdx = strmatch(colName, col_name_cell);
old_idx = data(:,colIdx);
[sort_idx, order] = sort(old_idx);
new_sort_idx = cumsum(sign(diff(sort_idx([1 1:end])))) + startNum;
new_idx = zeros(size(old_idx));
new_idx(order) = new_sort_idx;
data(:,colIdx) = new_idx;
a_db = set(a_db, 'data', data);

props=get(a_db, 'props');
if isfield(props, 'neuron_idx')
    for k=fieldnames(props.neuron_idx)'
        id=props.neuron_idx.(k{1});
        props.neuron_idx.(k{1})=new_sort_idx(find(sort_idx==id,1));
    end
    a_db = set(a_db, 'props', props);
end
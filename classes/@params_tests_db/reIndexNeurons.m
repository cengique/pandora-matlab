function a_db = reIndexNeurons(a_db, startNum, colName)

% reIndexNeurons - Re-index neurons with accending numbers. 
%
% Description: 
%   This is useful for avoiding NeuronId conflicts when concatenating two
% databases. It can also remove the unused number 'hole' (e.g. after
% deleting rows) and make the indices continuous.
% 
% Usage:
%  new_db = reIndexNeurons(a_db, startNum, colName)
%
% Parameters:
%   a_db: a tests_db object
%   startNum: the starting index number (default = 1)
%   colName: the column name or number of neuron index. (default = 'NeuronId')
%
% Returns:
%   new_db: a new database with new neuron index.
%
% See also: physiol_bundle, tests_db/physiol_bundle 
%
% Author: Li Su. 03/21/2008

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

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
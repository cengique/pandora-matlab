function [ rprof ] = birdsong_mat_profile(dataset, index, paramRow, props)
filename = getItem(dataset, index);
file = load(fullfile(dataset.path, filename));
stim = false;
if strcmpi(file.type, 'stim')
    stim = true;
end
rprof = results_profile(struct('entropy', entropy(file.sonogram), 'stim', stim), [dataset.id, 'item=', num2str(index)]);
end
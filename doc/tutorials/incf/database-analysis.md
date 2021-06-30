# Tutorial: Database analysis

# Load example data
First download the example Matlab data file [from here](supp_mat_2_dat.mat) and load it like this:

```matlab
load('supp_mat_2_dat.mat')
```

This will load a small experimental measurements dataset in several `tests_db` objects.

# Example for averaging rows

Display example database contents before averaging 
(see Table 3A in manuscript):

```matlab
displayRows(sortrows(raw_example1_db, 'pAcip'))

% average the rows
avg_example1_db = meanDuplicateParams(raw_example1_db);

% display contents after averaging
displayRows(sortrows(avg_example1_db, 'pAcip'))

% optionally, generate a formatted LaTeX table (see Table 3B in manuscript)
string2File(displayRowsTeX(sortrows(avg_example1_db, 'pAcip'), ...
                           'Parameter in the raw cell database.', ...
                           struct('rotate', 0, 'width', '\textwidth', ...
                                  'label', 'tbl:ttx-cells')), 'example-table.tex')
```

# Example for combining (merging) rows

Display example database contents before merging (see Table S1A in manuscript)

```matlab
displayRowsTeX(sortrows(merge_example_db, 'NeuronId'))
```

Merge columns into rows

```matlab
merged_db = ...
   mergeMultipleCIPsInOne(delColumns(merge_example_db(:, :, 1), ...
				     {'NumDuplicates', 'RowIndex'}), ...
			  {'_0pA', 9, ...
			      '_D100pA', 9, '_D200pA', 9})
```

Display after merging

```matlab
displayRowsTeX(sortrows(merged_db, 'NeuronId'))
```

Optionally, generate a formatted LaTeX table (see Table S1B in manuscript)

```matlab
string2File(displayRowsTeX(sortrows(merged_db, 'NeuronId'), ...
                           'Parameter in the raw cell database.', ...
                           struct('rotate', 0, 'width', '\textwidth', ...
                                  'label', 'tbl:ttx-cells')), ['example-' ...
                    'table.tex'])
```

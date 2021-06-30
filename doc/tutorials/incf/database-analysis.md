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


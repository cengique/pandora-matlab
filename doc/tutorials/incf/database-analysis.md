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

# Example for invariant parameter effects

Display database contents of TTX cells (see Table 4 in manuscript)

```matlab
displayRows(sortrows(ttx_example1_db, 'NeuronId'))
```

% select two TTX concentrations and three neurons
```matlab
ttx_reduced_db = ttx_example1_db(anyRows(ttx_example1_db(:, 'TTX'), [0; ...
                    7e-9]) & anyRows(ttx_example1_db(:, 'NeuronId'), [107; ...
                   108; 110]), :)
```

% find invariant parameter effects on extracted characteristics
```matlab
ttx_invar_reduced_db = invarParam(delColumns(ttx_reduced_db, 'TracesetIndex'), 'TTX')
```

% Find differential effects of TTX on rate
```matlab
ttx_diffed_db = diff2D(ttx_invar_reduced_db, 'D100pA_steady_rate');
```

% Plot as a bar plot (Figure 8C in manuscript)
```matlab
plotFigure(plotBox(ttx_diffed_db(:, 'd1_2'), '', ...
                   struct('quiet', 1, 'putLabels', 1, 'fixedSize', ...
                          [2.5 2], 'colormap', [0 0 0])))
```


% Find statistics of parameter effects
```matlab
ttx_stats_db = statsMeanSE(swapRowsPages(ttx_invar_reduced_db));
```

% plot bar plot showing parameter effects (see Figure 8B in manuscript)
```matlab
plotFigure(plot_bars(ttx_stats_db(:, {'TTX', 'D100pA_steady_rate'}, :), ...
                     '', ...
                     struct('pageVariable', 'TTX', 'axisLimits', [NaN NaN ...
                    20 30], 'quiet', 1, 'fixedSize', [2.5 2], 'colormap', ...
                            [0 0 0])))
```

%% divide into two grups
non_sim_rows = ...
    a_allsyns_bundle.joined_db(:, 'synS_mult_HE8_HN3_HE8') == 0;
non_sim_db = a_allsyns_bundle.joined_db(non_sim_rows, :);
sim_db = a_allsyns_bundle.joined_db(~non_sim_rows, :);

%% plot statistics

% calculate mean, min, max into a stats_db
a_ns_stats_db = statsBounds(non_sim_db, 'peri_freq_Hz_HE8');

% display
displayRows(a_ns_stats_db)

% plot errorbars
plotFigure(plot_abstract(a_ns_stats_db, 'Non stimulated'))

plotFigure(plot_bars(a_ns_stats_db, 'Non stimulated'))

% test negative peaks
non_sim_db_neg = -non_sim_db;
non_sim_db_neg_stats = statsMeanStd(non_sim_db_neg, 'peri_freq_Hz_HE8');
displayRows(non_sim_db_neg_stats);
plotFigure(plot_bars(non_sim_db_neg_stats))

%% create the database

my_data_set = params_tests_fileset('/Users/judgingmoloch/Documents/School/Pandora/tutorials/birdsong_dataset/01_21_15_data_simple/*.mat', 1/32000, 1, 'gr79pu85_1_20_15', ...
    struct('fileParamsRegexp', '(?<name>onset)-(?<val>[\d\.]+)', 'loadItemProfileFunc', @birdsong_mat_profile));
my_db = params_tests_db(my_data_set); % This step could take a while

%% for tutorial

stims = my_db(my_db(:, 'stim') == true, :);
catches = my_db(my_db(:, 'stim') == false, :);

% plot

stim_ns_stats_db = statsBounds(catches, 'entropy');
catch_ns_stats_db = statsBounds(stims, 'entropy');

plotFigure(plot_bars(stim_ns_stats_db, 'Stimulated'));
plotFigure(plot_bars(catch_ns_stats_db, 'Unstimulated'));

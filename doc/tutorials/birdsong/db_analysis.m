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
% => weird!!!! broken!

plotFigure(plot_bars(a_ns_stats_db, 'Non stimulated'))

% test negative peaks
non_sim_db_neg = -non_sim_db;
non_sim_db_neg_stats = statsMeanStd(non_sim_db_neg, 'peri_freq_Hz_HE8');
displayRows(non_sim_db_neg_stats);
plotFigure(plot_bars(non_sim_db_neg_stats))
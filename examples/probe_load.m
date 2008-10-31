%load('R:\Cengiz\pyloric-sensordb\temp\example_for_pandora.mat')
load('example_for_pandora.mat')

if exist('filtfilt', 'file') == 2
    % using the signal processing toolbox
    a_trace = trace(probe.values, 1e-4, 1e-3, 'natalia probe trace');
    a_spikes = spikes(a_trace);
else
    % using the signal processing toolbox
    a_trace = trace(probe.values, 1e-4, 1e-3, 'natalia probe trace', ...
        struct('spike_finder', 2, 'threshold', -85));
    a_spikes = spikes(a_trace);
end

[results period_spikes a_spikes_db spikes_stats_db spikes_hists_dbs]= ...
  analyzeSpikesInPeriod(a_trace, a_spikes, periodWhole(a_trace), '');

% display info about spikes DB extracted from data
a_spikes_db %#ok<NOPTS>

% plot all spikes annottaed on the trace (takes a long time for the
% 10-second trace!
plot(a_spikes_db);

% plot some histograms
plot(histogram(a_spikes_db, 'InitVm')); % threshold voltage
plot(histogram(a_spikes_db, 'MaxAHP')); % AHP magnitude
plot(histogram(a_spikes_db, 'MinVm')); % minimum of AHP voltage

% make an example plot for Pandora

% extract an interesting part of the trace and save it
small_trace = withinPeriod(a_trace, period(1, 50000))

test_data = small_trace.data;

save -v6 ~/Documents/writings/brute-force/pandora/supp_mat_2_dat.mat ...
  test_data

[results period_spikes a_spikes_db spikes_stats_db spikes_hists_dbs]= ...
  analyzeSpikesInPeriod(small_trace, a_spikes, periodWhole(a_trace), '');

plotFigure(plot_abstract(a_spikes_db, 'annotated spike characteristics', ...
           struct('fixedSize', [2 2], 'axisLimits', [1450 1555 -100 -60], ...
                  'quiet', 1)))
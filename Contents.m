% DJLAB General Purpose Matlab Classes
%
% The following classes are designed as generic templates that can be 
% subclassed to take specific tasks. They should not be modified for
% more specialized tasks.
%
% Basic data wrapper classes that define the measurements:
%   trace		- A voltage/current trace.
%   spikes		- Spike times of a trace. 
%   spike_shape		- Averaged spike shape from a trace.
%   period		- Defines time periods to operate on trace or spikes objects.
%
% Classes specialized for CIP experiments tests:
%   cip_trace		- A voltage trace with a CIP applied.
%
% Profile classes that hold test results:
%   result_profile	- Base class that holds a results structure.
%   trace_profile	- Generic example class for holding a trace profile.
%   cip_trace_profile	- Holds cip_trace results. Template class designed 
%			only for subclassing.
%   cip_trace_allspikes_profile 
%			- Created by cip_trace/getProfileAllSpikes, contains statistics
%			  of spike shape measures from individual spikes.
%   params_tests_profile- Collects both intermediate and result data structures 
%			from analysis of a params_tests_db.
%
% Dataset classes that point to or hold raw data:
%   params_tests_dataset - Base class for datasets.
%   params_tests_fileset - Holds a list of filenames and associated information,  
%			   capable of creating a params_tests_db.
%   params_cip_trace_fileset - Fileset from which cip_trace objects can be created. 
%   physiol_cip_traceset - Dataset of a traceset from a single file.
%   physiol_cip_traceset_fileset - Dataset of a tracesets from many files.
% 
% Database classes created from datasets:
%   tests_db		- Base class for databases. Contains many utilities.
%   params_tests_db	- DB extended to hold parameter values 
%			associated with results.
%   spikes_db		- Holds measures from each individual spike in a trace.
%   test_3D_db		- 3D database of tests that vary with a third variable.
%   corrcoefs_db	- Holds correlation coefficients.
%   histogram_db	- Holds histogram bins.
%   stats_db		- Holds statistical measurements.
%   ranked_db		- Database ranked for a criterion, holds error values or distances.
%
% Bundle classes that bridge the gap between database and it's ancestral dataset:
%   dataset_db_bundle	- Base class of bundles. Puts a processed and raw DBs with datasets.
%   model_ct_bundle	- Bundle for model databases.
%   physiol_bundle	- Bundle for physiology databases.
%
% Plotting classes:
%   plot_abstract	- Base class that holds information sufficient to generate any plot.
%   plot_simple		- Simple extension that works for most simple plots.
%   plot_stack		- Holds horizontal or vertical stack of plot_abstract objects.
%   plot_inset		- Places multiple plots at absolute locations in a figure. Good for insets, etc.
%   plot_superpose	- Allows superposing different plot_abstract's in the same axis.
%   plot_bars		- Multi-axis bar plot with extended errorbars.
%   plot_errorbar	- Errorbar plot.
%   plot_errorbars	- Multi-axis errorbar plot.
%
% Classes for generating formatted printable or presentable documents:
%   doc_generate	- Base class for all document classes.
%   doc_plot		- Holds a plot_abstract and captions, etc.
%   doc_multi		- Combines multiple doc_generate objects.
%
% Script control classes for cluster computing:
%   script_factory	- Generates a set of scripts based on a recipe.
%   script_array	- Designed to execute an array job serially on a computer.
%   script_array_for_cluster - Executes an array job on a cluster computer.
%
% Notes:
%
% See also: subclasses under classes/cengiz
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/14

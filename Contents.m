% DJLAB General Purpose Matlab Classes
%
% The following classes are designed as generic templates that can be 
% subclassed to take specific tasks. They should not be modified for
% more specialized tasks.
%
% Basic data wrapper classes that define tests:
%   trace		- A voltage/current trace.
%   spikes		- Spike times of a trace. 
%   spike_shape		- Averaged spike shape from a trace.
%   period		- Define time periods.
%
% Classes specialized for CIP experiments tests:
%   cip_trace		- A voltage trace with a CIP applied.
%   cip_traces		- Traces with a set of CIPs applied (from /Lab/matlab/cengiz).
%
% Profile classes that hold test results:
%   result_profile	- Base class that holds a results structure.
%   trace_profile	- Generic example class for holding a trace profile.
%   cip_trace_profile	- Holds cip_trace results. Template class designed 
%			only for subclassing.
%   cip_traces_profile	- Vector/polynomial results profile from a 
%			cip_traces.
%   params_tests_profile- Collects both intermediate and result data structures 
%			from analysis of a params_tests_db.
%
% Dataset classes that point to or hold raw data:
%   params_tests_dataset - Base class for datasets.
%   params_tests_fileset - Holds a list of filenames and associated information,  
%			   capable of creating a params_tests_db.
%   params_cip_trace_fileset - Fileset from which cip_trace objects can be created. 
%   cip_traces_dataset  - Dataset of cip_traces objects.
%   physiol_cip_traceset - Dataset of a traceset from a single file.
%   physiol_cip_traceset_fileset - Dataset of a tracesets from many files.
% 
% Profile database classes created from datasets:
%   tests_db		- General test results database class that 
%			contains many utilities.
%   params_tests_db	- DB extended to hold parameter values 
%			associated with results.
%   test_3D_db		- 3D database of tests that vary with a third variable.
%
% Notes:
% N/I: Not implemented (yet).
%
% See also: subclasses under classes/cengiz
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/14

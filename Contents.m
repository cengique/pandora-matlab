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
%   cip_traces		- Traces with a set of CIPs applied (N/I).
%
% Profile classes that hold test results:
%   result_profile	- Base class that holds a results structure.
%   trace_profile	- Generic example class for holding a trace profile.
%   cip_trace_profile	- Holds cip_trace results. Template class designed 
%			only for subclassing.
%   cip_traces_profile	- Vector/polynomial results profile from a 
%			cip_traces (N/I).
%
% Profile database classes:
%   tests_db		- General test results database class that 
%			contains many utilities.
%   params_tests_db	- DB extended to hold parameter values 
%			associated with results.
%   params_tests_fileset 	
%			- Manages a fileset and can create a 
%			params_tests_db from it.
%   params_cip_trace_fileset	
%			- Fileset of cip_trace style data.
%   test_variable_db	- Database of tests that vary with a variable (N/I).
%   test_cip_db		- Database of tests that vary with the CIP magnitude (N/I).
%
% Notes:
% N/I: Not implemented (yet).
%
% See also: subclasses under classes/cengiz
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/14

function a_pt_profile = getProfile(a_db, props)

% getProfile - Create a profile object from a params_tests_db by collecting
%			 statistics.
%
% Usage:
% a_pt_profile = getProfile(a_db, props)
%
%   Parameters:
%	a_db: A params_tests_db object.
%	props: A structure with any optional properties.
%
% Description:
%   Calculates the following results items:
%	idx: Name-index pairs for accessing results arrays.
%	t_hists: Cell array of histograms of each test.
%	p_t3ds: Cell array of invariant relations of each parameter with all tests.
%	pt_hists: Cell array of separate test value histograms 
%		for uniques value of each parameter.
%	p_stats: Cell array of test stats for each param.
%	p_coefs: Cell array of correlation coefficients 
%		for each parameter with all tests.
%	pt_coefs_hists: Cell matrix of histograms of coefficients from 
%		correlations of each parameter with each test.
%	pp_coefs: Cell 3D matrix of mean coefficients from 
%		correlations of each parameter with correlation 
%		coefficients of each parameter with each test.		
%
%   Returns a params_tests_profile object.
%
% See also: params_tests_profile, results_profile, params_tests_db, params_tests_fileset, 
%		tests_db, tests_3D_db, histogram_db, stats_db, corrcoefs_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/10/13

%# TODO: 
%# - param and test bounds
%# - plotting funcs in a subclass?
%# - Feed test-reduced database?

if ~ exist('props')
  props = struct([]);
end

num_params = a_db.num_params;
num_tests = size(a_db, 2) - num_params - 1; %# Except the file indices

%# Setup lookup tables
col_names = fieldnames(get(a_db, 'col_idx'));

%# Create the param and test number structure  
results.idx.NaN = NaN;
for param_num=1:num_params
  results.idx = setfield(results.idx, col_names{param_num}, param_num);
end
for test_num=1:num_tests
  results.idx = setfield(results.idx, col_names{num_params + test_num}, test_num);
end

very_start_time = cputime;

%# Create the test_hists
start_time = cputime;
disp('Calculating test histograms.');
results.t_hists = testsHists(a_db);
disp(sprintf('Elapsed time took %.2f seconds.', cputime - start_time));

%# Create the p_t3ds
start_time = cputime;
disp('Calculating invariant relations of tests to each parameter.');
results.p_t3ds = invarParams(a_db);
disp(sprintf('Elapsed time took %.2f seconds.', cputime - start_time));

%# Create the pt_hists and p_stats
start_time = cputime;
disp('Calculating histograms and mean/std stats of tests for each value of the invariant parameter.');
[results.pt_hists, results.p_stats] = paramsTestsHistsStats(a_db, results.p_t3ds);
disp(sprintf('Elapsed time took %.2f seconds.', cputime - start_time));

%# Create the p_coefs
start_time = cputime;
disp('Calculating invariant correlation coefficients of all tests with each parameter.');
results.p_coefs = paramsCoefs(a_db, results.p_t3ds);
disp(sprintf('Elapsed time took %.2f seconds.', cputime - start_time));

%# Create the pt_coefs_hists
start_time = cputime;
disp(['Calculating histograms of coefficients from correlations ' ... 
      'of each parameter with each test.']);
results.pt_coefs_hists = paramsTestsCoefsHists(a_db, results.p_coefs);
disp(sprintf('Elapsed time took %.2f seconds.', cputime - start_time));

%# Create the pp_coefs
start_time = cputime;
disp(['Calculating mean coefficients from correlations of each parameter '...
      'with correlation coefficients of each parameter with each test.']);
results.pp_coefs = paramsParamsCoefs(a_db, results.p_t3ds, results.p_coefs);
disp(sprintf('Elapsed time took %.2f seconds.', cputime - start_time));

disp(sprintf('Total time took %.2f seconds.', cputime - very_start_time));

%# Create the object
a_pt_profile = params_tests_profile(results, a_db, props);


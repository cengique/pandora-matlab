function a_pt_profile = params_tests_profile(a_db, props)

% params_tests_profile - Collect statistics from a params_tests_fileset based db.
%
% Usage:
% a_pt_profile = 
%   params_tests_profile(a_db, props)
%   Parameters:
%	a_db: A params_tests_db object.
%	props: A structure with any optional properties.
%
% Description:
%		
%   Returns a structure object with the following fields:
%	results_profile: Results structure?
%	t_hists: Cell array of histograms of each test.
%	p_t3ds: Cell array of invariant relations of each parameter with all tests.
%	pt_hists: Cell array of separate test value histograms 
%		for uniques value of each parameter.
%	pt_coefs: Cell array of correlation coefficients 
%		for each parameter with all tests.
%	pt_coefs_hists: Cell matrix of histograms of coefficients from 
%		correlations of each parameter with each test.
%	ppt_coefs: Cell 3D matrix of mean coefficients from 
%		correlations of each parameter with correlation 
%		coefficients of each parameter with each test.
%	props.
%
% General methods of params_tests_profile objects:
%   params_tests_profile- Construct a new params_tests_profile object.
%   plot		- Graph the params_tests_profile.
%   display		- Returns and displays the identification string.
%   get			- Gets attributes of this object and parents.
%   subsref		- Allows usage of . operator.
%
% Additional methods:
%   See methods('params_tests_profile')
%
% See also: results_profile, params_tests_db, params_tests_fileset, 
%		tests_db, tests_3D_db, histogram_db, stats_db, corrcoefs_db
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/08/25

%# TODO: 
%# - add idx structs for pointing from param and test names to indices.
%# - param and test bounds
%# - plotting funcs in a subclass?
%# - Feed test-reduced database?

if nargin == 0 %# Called with no params, creates empty object
  a_pt_profile.db = params_tests_db;
  a_pt_profile.idx = struct([]);
  a_pt_profile.t_hists = {};
  a_pt_profile.p_t3ds = {};
  a_pt_profile.pt_hists = {};
  a_pt_profile.pt_coefs = {};
  a_pt_profile.pt_coefs_hists = {};
  a_pt_profile.ppt_coefs = {};
  a_pt_profile.props = struct([]);
  a_pt_profile = class(a_pt_profile, 'params_tests_profile', results_profile);
elseif isa(a_db, 'params_tests_profile') %# copy constructor?
  a_pt_profile = a_db;
else 
  if ~ exist('props')
    props = struct([]);
  end

  num_params = a_db.num_params;
  num_tests = size(a_db, 2) - num_params;
  a_pt_profile.db = a_db;

  %# Setup lookup tables
  col_names = fieldnames(a_db.col_idx);

  %# Create the param and test number structure
  
  idx.NaN= NaN;
  for param_num=1:num_params
    idx = setfield(idx, col_names{param_num}, param_num);
  end
  for test_num=1:num_tests
    idx = setfield(idx, col_names{num_params + test_num}, test_num);
  end
  a_pt_profile.idx = idx;

  %# Create the test_hists
  tic;
  disp('Calculating test histograms.');
  a_pt_profile.t_hists = cell(1, num_tests);
  for test_num=1:num_tests
    a_pt_profile.t_hists{test_num} = histogram(a_db, num_params + test_num);
  end
  toc

  %# Create the p_t3ds
  tic;
  disp('Calculating invariant relations of tests to each parameter.');
  a_pt_profile.p_t3ds = cell(1, num_params);
  for param_num=1:num_params
    a_pt_profile.p_t3ds{param_num} = invarParam(a_db, param_num);
  end
  toc

  %# Create the pt_hists
  tic;
  disp('Calculating histograms of tests invariant with each parameter.');
  a_pt_profile.pt_hists = cell(num_tests, num_params);
  for param_num=1:num_params
    a_t3d = swapRowsPages(a_pt_profile.p_t3ds{param_num});
    %# Sort the param column first
    a_t3d = sortrows(a_t3d, 1);
    for test_num=1:num_tests
      a_pt_profile.pt_hists{test_num, param_num} = histograms(a_t3d, test_num + 1);
    end
  end
  toc

  %# Create the pt_coefs
  tic
  disp('Calculating invariant correlation coefficients of all tests with each parameter.');
  a_pt_profile.pt_coefs = cell(1, num_params);
  for param_num=1:num_params
    a_pt_profile.pt_coefs{1, param_num} = ...
	corrCoefs(a_pt_profile.p_t3ds{param_num}, 1, 2:(num_tests + 1));
  end
  toc

  a_pt_profile.pt_coefs_hists = {};
  a_pt_profile.ppt_coefs = {};
  a_pt_profile.props = props;

  %# Create the object
  a_pt_profile = class(a_pt_profile, 'params_tests_profile', ...
		       results_profile(struct([]), a_db.id));
end

function makeGenesisParFile(a_db, filename, props)

% makeGenesisParFile - Creates a Genesis parameter file with all the parameter values in a_db.
%
% Usage:
% makeGenesisParFile(a_db, filename, props)
%
% Description:
%   For each a_db row, print the parameter names in a
% file formatted for Genesis.
%
%   Parameters:
%	a_db: A params_tests_db object.
%	filename: Genesis parameter file to be created.
%	props: A structure with any optional properties.
%	  trialStart: If given, adds/replaces the trial parameter and counts forward.
%	  makeParamDesc: If 1, put the parameter names in a parameter description file with
%	  	 with a .txt extension.
%
%   Returns:
%	nothing.
%
%   Example:
%>> naf_rows_db = scanParamAllRows(a_db(desired_rows, :), 'NaF', 0, 1000, 100);
%>> makeGenesisParFile(naf_rows_db, 'naf.par')
%
% See also: scanParamAllRows, scaleParamsOneRow
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/03/13

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% TODO: read paramRanges.txt to verify parameter sequence

if ~exist('props', 'var')
  props = struct;
end

% Add/replace a trial column and count forward
if isfield(props, 'trialStart')
  start_trial = props.trialStart;
  trial_col = (start_trial:(start_trial - 1 + dbsize(a_db, 1)))';
  try 
    a_db = addParams(a_db, {'trial'}, trial_col);
  catch
    lerr = lasterror;
    % If column already exists, it's ok
    if strcmp(lerr.identifier, 'tests_db:col_exists')
      a_db = assignRowsTests(a_db, trial_col, ':', 'trial');
    else
      rethrow(lerr);      
    end
  end
end

% Create a parameter description file for database generation
if isfield(props, 'makeParamDesc')
  param_desc_filename = strrep(filename, '.par', '.txt');
  param_names = [strvcat(getColNames(a_db)), repmat(sprintf('\n'), a_db.num_params, 1)];
  string2File(reshape(param_names', 1, prod(size(param_names))), param_desc_filename);
end

num_rows = dbsize(a_db, 1);

% First row of par file contains info
first_row = [ num2str(num_rows) ' ' num2str(a_db.num_params) sprintf('\n') ];

% Rest contains param values and zeros appended at the end of row
data_rows = [num2str( [get(onlyRowsTests(a_db, ':', 1:a_db.num_params), 'data'), ...
			   zeros(num_rows, 1) ]), ...
	     repmat(sprintf('\n'), num_rows, 1) ];

data_str = reshape(data_rows', 1, prod(size(data_rows)));

string2File([first_row, data_str], filename);

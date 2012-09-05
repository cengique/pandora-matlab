function obj = tests_db(test_results, col_names, row_names, id, props)

% tests_db - Construct a numeric database organized in a matrix format.
%
% Usage:
% obj = tests_db(test_results, col_names, row_names, id, props)
%
% Parameters:
%   test_results: Either a CSV file name or a matrix that contains
%   		measurement columns and separate observations as rows.
%   col_names: Cell array of column names of test_results.
%   row_names: Cell array of row names of test_results.
%   id: An identifying string.
%   props: A structure with any optional properties.
%     csvArgs: Cell array of arguments passed to csvread function (e.g.,
%     	{R, C, [r1 c1 r2 c2]}).
%     csvReadColNames: If 1, first row of the file is used to read column
%     	names.
%		
% Returns a structure object with the following fields:
%   data: The data matrix.
%   row_idx, col_idx: Structure associating row/column names to indices.
%   id, props.
%
% Description:
%   This is the base database class. 
%
% General operations on tests_db objects:
%   tests_db		- Construct a new tests_db object.
%   allocateRows	- Preallocate rows before filling the DB.
%   setRows		- Fill the DB with rows.
%   addRow		- Add a single row to DB.
%   addLastRow		- Add a single row to the end of DB.
%   display		- Returns and displays the identification string.
%   displayRows		- Display one row of data from the DB.
%   subsref		- Allows referencing rows/cols via () to get new 
%			  tests_db objects and allows usage of . operator.
%   eq			- Overloaded == operator that returns row indices.
%   ne			- Overloaded ~= operator that returns row indices.
%   lt			- Overloaded < operator that returns row indices.
%   gt			- Overloaded > operator that returns row indices.
%   le			- Overloaded <= operator that returns row indices.
%   ge			- Overloaded >= operator that returns row indices.
%   size		- Overloaded, returns size of database.
%   isnan		- Overloaded, returns non-NaN elements logical array.
%   get			- Gets attributes of this object and parents.
%   kcluster		- Returns k tests_db objects, one for each cluster 
%			  found in this one (N/I).
%   rankMatching	- Returns a tests_db object having an additional
%			  rank column and sorted according to relevance to 
%			  given query (N/I).
%   sort		- Sort rows and return new object and scrambling 
%			  order (N/I).
%   pca			- Returns a new tests_db object with the principal
%			  components of this one (N/I).
%   ica			- Returns a new tests_db object with the independent
%			  components of this one (N/I).
%   valDistributions - Returns mean and STDs of all values and 
%			  boundaries to be plotted (N/I).
%   withinValRange	- Returns a tests_db object with data within the range
%			  requested (N/I).
%   onlyTests		- Returns a tests_db object which contains only 
%			  the requested test columns (N/I).
%   histogram		- Returns histogram of given test.
%
% Additional methods:
%	See methods('tests_db')
%
% See also: params_tests_db, params_db, test_variable_db (N/I)
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2004/09/01

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 % Called with no params
   obj.data = [];
   obj.col_idx = struct([]);
   obj.row_idx = struct([]);
   obj.id = '';
   obj.props = struct([]);
   obj = class(obj, 'tests_db');
 elseif isa(test_results,'tests_db') % copy constructor?
   obj = test_results;
 else

   if ~ exist('props', 'var')
     props = struct([]);
   end

   % Is CSV file name?
   if ischar(test_results) 
     [path, filename, ext] = fileparts(test_results);
     % assert file has correct extension? [not necessary]
     %strcmpi(ext, '.csv')
     csv_args = getFieldDefault(props, 'csvArgs', {});
     
     % read column names from 1st row
     if isfield(props, 'csvReadColNames')
       fid = fopen(test_results);
       oneline = fgetl(fid);
       col_names = textscan(oneline, '"%[^"]"', 'Delimiter', ',');
       if isempty(col_names)
         col_names = textscan(oneline, '%s', 'Delimiter', ',');
       end
       fclose(fid);
       col_names = properAlphaNum(col_names{1}');
       
       if length(csv_args) == 0 
         csv_args{1} = 1; % skip 1st row
       end
     end
     
     test_results = ...
         csvread(test_results, csv_args{:});
   end     

   % Only allow numeric arrays as test_results
   % TODO: add cell arrays?
   if ~ isnumeric(test_results) 
     error('Only numeric arrays allowed as test_results.');
   end

   if size(test_results, 1) > 0 && ~ isempty(col_names) && ...
	 size(test_results, 2) ~= length(col_names)
     error([ 'Number of columns in test_results (' ...
             num2str(size(test_results, 2)) ') and items in col_names (' ...
             num2str(length(col_names)) ') must match.']);
   end

   obj.data = test_results;


   % Prepare *_idx
   obj.col_idx = makeIdx(col_names);
   obj.row_idx = makeIdx(row_names);
   obj.id = id;
   obj.props = props;

   obj = class(obj, 'tests_db');
end


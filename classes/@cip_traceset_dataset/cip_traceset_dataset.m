function obj = cip_traceset_dataset(cts, cip_mags, dy, id, props)

% cip_traceset_dataset - Dataset of multiple cip magnitudes from cip_traces objects .
%
% Usage:
% obj = cip_traceset_dataset(cts, cip_mags, dy, id, props)
%
% Description:
%   This is a subclass of params_tests_dataset. Designed to extract a trace
% for each cip magnitude from the cip_traceset objects contained. Uses cip_traceset
% objects to extract multiple traces from each cip_traces object.
%
%   Parameters:
%	cts: Array or cell array of cip_traces objects.
%	cip_mags: An array of cip magnitudes to select from each cip_traces object.
%	dy: y-axis resolution, [V] or [A] (default = 1e-3).
%	id: An identification string.
%	props: A structure with any optional properties passed to cip_traceset.
%		
%   Returns a structure object with the following fields:
%	params_tests_dataset, cip_mags
%
% General operations on cip_traceset_dataset objects:
%   cip_traceset_dataset - Construct a new object.
%   params_tests_db - Loops over traceset objects and concatenates to form database
%
% Additional methods:
%	See methods('cip_traceset_dataset'), and 
%	    methods('params_tests_dataset').
%
% See also: physiol_cip_traceset, params_tests_dataset, params_tests_db
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/01/28
%	  Based on physiol_cip_traceset_fileset created with Tom Sangrey.

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 %# Called with no params
  obj.cip_mags = [];
  obj.props = struct([]);
  obj = class(obj, 'cip_traceset_dataset', params_tests_dataset);
elseif isa(cts, 'cip_traceset_dataset') %# copy constructor?
  obj = cts;
else

  if ~ exist('props')
    props = struct([]);
  end

  if ~ exist('dy')
    dy = 1e-3;
  end
   
  obj.cip_mags = cip_mags;
  obj.props = props;

  %# Loop in cts entries and create cip_traceset objects
  listlength=length(cts);
  [list(1:listlength)] = deal(cip_traceset); 
  for i=1:listlength
    if iscell(cts)
      ct = cts{i};
    else
      ct = cts(i);
    end
    list(i) = cip_traceset(ct, cip_mags, dy, props);
  end

  %# Create the object

  params_tests_dataset(list, get(list(1), 'dt'), dy, ...
		       ['dataset of tracesets from cips ', ...
			sprintf('%.2f ', cip_mags) ], props)
  obj = class(obj, 'cip_traceset_dataset', ...
	      params_tests_dataset(num2cell(list), get(list(1), 'dt'), dy, ...
				   [ id ' with cips ', ...
				    sprintf('%.2f ', cip_mags) ], props));

end

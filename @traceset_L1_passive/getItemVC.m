function a_vc = getItemVC(traceset, trace_index)

% getItemVC - Loads and returns a voltage_clamp object.
%
% Usage:
% a_vc = getItemVC(traceset, trace_index)
%
%   Parameters:
%	traceset: A traceset object.
%	trace_index: Index of item in traceset.
%		
%   Returns:
%	a_vc: A voltage_clamp object.
%
% Description:
%
% See also: traceset_L1_passive
%
% $Id: getItemVC.m 818 2007-08-28 20:28:51Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/02/04

% Copyright (c) 2011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

traceset_props = get(traceset, 'props');

basedir = getFieldDefault(traceset_props, 'baseDir', '');

a_vc = getItem(traceset, trace_index);

% use the template if provided
if isfield(traceset_props, 'fileTempl')
  a_vc = sprintf(traceset_props.fileTempl, a_vc);
end

% load the voltage_clamp object
if ischar(a_vc)
  a_vc = abf2voltage_clamp([ basedir a_vc ], ...
                              [ '-' num2str(trace_index) ], traceset_props);
end

assert(isa(a_vc, 'voltage_clamp'));

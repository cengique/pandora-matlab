function [gL, EL, offset] = calcSteadyLeak(pas, props)

% calcSteadyLeak - Calculates passive parameter values based on initial and steady-state values after pulse.
%
% Usage:
% [gL, EL, offset] = calcSteadyLeak(pas, props)
%
% Parameters:
%   pas: A data_L1_passive object.
%   props: Structure with optional properties.
%     EL: Specify EL value [mV] (default=-80).
%
% Returns:
%   gL: Leak conductance [pA].
%   EL: Leak reversal [mV].
%   offset: Manual current offset applied [pA].
%
% Description:
%   Calculates gL, EL and offset values.
%
% See also: 
%
% $Id: calcSteadyLeak.m 896 2007-12-17 18:48:55Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/12/30

% Copyright (c) 2010 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 % Called with no params
  error('Need object.');
end

props = defaultValue('props', struct);
EL = getFieldDefault(props, 'EL', -80);

% calculate gL from initial and after pulse steady levels
gL = diff(pas.data_vc.i_steps(1:2))/diff(pas.data_vc.v_steps(1:2));

% resolve offset last
offset = pas.data_vc.i_steps(1) - (pas.data_vc.v_steps(1) - EL) * gL;

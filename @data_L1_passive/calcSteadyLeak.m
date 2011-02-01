function res = calcSteadyLeak(pas, props)

% calcSteadyLeak - Calculates passive parameter values based on initial and steady-state values after pulse.
%
% Usage:
% results = calcSteadyLeak(pas, props)
%
% Parameters:
%   pas: A data_L1_passive object.
%   props: Structure with optional properties.
%     calcOffsetWithEL: Calculate a manual offset using this EL value [mV]. 
%     calcSealLeakWithEL: Calculate a separate electrode seal leak
%     		 using this EL value [mV].
%     offset: Specify manual offset [nA] (default=0).
%
% Returns:
%  results: a structure with the following:
%   gL: Leak conductance [uS].
%   EL: Leak reversal [mV].
%   offset: Manual current offset applied [nA].
%
% Description:
%   Calculates membrane and electrode seal leak gL, EL and manual offset values.
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

res = struct;

% calculate gL from initial and after pulse steady levels
res.gL = diff(pas.data_vc.i_steps(1:2))/diff(pas.data_vc.v_steps(1:2));

% effective EL
res.EL = pas.data_vc.v_steps(1) - pas.data_vc.i_steps(1) / res.gL;

% default
res.offset = 0;

if isfield(props, 'calcOffsetWithEL')
  res.EL = props.calcOffsetWithEL;

  % resolve offset last
  res.offset = pas.data_vc.i_steps(1) - (pas.data_vc.v_steps(1) - res.EL) * res.gL;
elseif isfield(props, 'calcSealLeakWithEL')
  res.ELm = props.calcSealLeakWithEL;
    
  % see k-channel.lyx/pdf appendix
  res.gLm = res.gL * res.EL / res.ELm;
  res.gS = res.gL - res.gLm;
end

% by default return effective EL


end



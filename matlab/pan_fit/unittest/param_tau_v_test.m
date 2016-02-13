function param_tau_v_test
  
% param_tau_v_test - Unit test for @param_tau_v.
%
% Usage:
%   param_tau_v_test
%
% Parameters:
%		
% Returns:
%
% Description:  
%   Uses the xunit framework by Steve Eddins downloaded from Mathworks
% File Exchange.
%
% See also: xunit
%
% $Id: param_tau_v_test.m 168 2010-10-04 19:02:23Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/29

  [a b c d] = deal(1, 2, 3, 4);
  
  f_right = @(x) a + b/(1+exp((x+c)/d));
  
% make a param act and test values  
tau = param_tau_v([a b c d]);

% test midpoint and extremes
assertElementsAlmostEqual(f(tau, inf), a);
assertElementsAlmostEqual(f(tau, -inf), a + b);
assertElementsAlmostEqual(f(tau, -c+d), a + b/(1+exp(1)));
assertElementsAlmostEqual(f(tau, -c-d), a + b/(1+exp(-1)))

function param_act_test
  
% param_act_test - Unit test for @param_act.
%
% Usage:
%   param_act_test
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
% $Id: param_act_test.m 168 2010-10-04 19:02:23Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/29

% make a param act and test values
  
a = param_act([-50 1]);

% test midpoint and extremes
assert(f(a, -50) == 0.5);
assert(f(a, inf) == 0);
assert(f(a, -inf) == 1);

% test one random value
b = f(a, 0);
b_right = 1.9287e-22;
assert(b >= b_right - eps && b <= b_right + eps);

% better, use the xunit function
assertElementsAlmostEqual(b, b_right);
  

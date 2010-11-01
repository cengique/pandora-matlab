function param_act_deriv_v_test
  
% param_act_deriv_v_test - Unit test for @param_act_deriv_v.
%
% Usage:
%   param_act_deriv_v_test
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
% $Id: param_act_deriv_v_test.m 168 2010-10-04 19:02:23Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/29
  
% make an object
  m_inf = param_act([-80 6]);
  m_tau = param_tau_v([10 20 50 5]);

  m = param_act_deriv_v(m_inf, m_tau);
  
  % two traces:
  % -90 mV for 10 ms -> 10 mV for 100 ms
  % -90 mV for 10 ms -> -50 mV for 100 ms
  ideal_v = [ [repmat(-90, 100, 1); repmat(10, 1000, 1)], ...
              [ repmat(-90, 100, 1); repmat(-50, 1000, 1)] ];

  % TODO: convert all times to [ms]?
  dt = 1e-1; % [ms]
  
  m_int = f(m, struct('v', ideal_v, 'dt', dt));

  % test points
  assertElementsAlmostEqual(m_int(1, :), repmat(f(m_inf, -90), 1, 2));
  assert(m_int(end, 1) < f(m_inf, -20));
  assert(m_int(end, 2) < f(m_inf, -55));
  
  % ideal solution for one step:
  time = (0:(1000 - 1))*dt;
  m_ideal = [repmat(f(m_inf, -90), 100, 1); f(m_inf, -90) .* exp(-time'/f(m_tau, 10))];

  % test whole solution
  assert(max(abs(m_int(:, 1) - m_ideal)) < 1e-1);

    % vector tests are not adequate for euclidian distance?
  %assertVectorsAlmostEqual(, 'absolute', );
% $$$   plot(m_inf);
% $$$   plot(m_tau);
% $$$ 
% $$$   figure; plot([m_int, m_ideal])


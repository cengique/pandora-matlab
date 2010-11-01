function param_I_int_v_test
  
% param_I_int_v_test - Unit test for param_I_int_v.
%
% Usage:
%   param_I_int_v_test
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
% $Id: param_I_int_v_test.m 168 2010-10-04 19:02:23Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/11/01
  
% make an object
  m_inf = param_act([-50 -6]);
  m_tau = param_tau_v([1 2 50 5]);
  m = param_act_deriv_v(m_inf, m_tau);

  h_inf = param_act([-80 10]);
  h_tau = param_tau_v([20 40 70 5]);
  h = param_act_deriv_v(h_inf, h_tau);

  % test only m
  gmax = 10;
  Erev = -80;
  I = param_I_int_v([1 0 gmax Erev], m, h);

  % two ideal voltage steps:
  % -90 mV for 10 ms -> 10 mV for 100 ms
  % -90 mV for 10 ms -> -50 mV for 100 ms
  ideal_v = [ [repmat(-90, 10, 1); repmat(10, 1000, 1)], ...
              [ repmat(-90, 10, 1); repmat(-50, 1000, 1)] ];

  dt = 1e-1; % [ms]

  % integrate
  I_int = f(I, struct('v', ideal_v, 'dt', dt));
  %figure; plot(I_int)

  % init & steady tests
  assertElementsAlmostEqual(I_int(1, :), ...
                            gmax * repmat(f(m_inf, -90), 1, 2) * (-90 - Erev));
  assertElementsAlmostEqual(I_int(end, 1)/(10 - Erev), ...
                            gmax * f(m_inf, 10), 'absolute', 1e-3);
  assertElementsAlmostEqual(I_int(end, 2) / (-50 - Erev), ...
                            gmax * f(m_inf, -50), 'absolute', 1e-3);
    
  % test m & h
  I = param_I_int_v([1 1 gmax Erev], m, h);
  I_int = f(I, struct('v', ideal_v, 'dt', dt));
  %figure; plot(I_int)

  % init test
  assertElementsAlmostEqual(I_int(1, :), ...
                            gmax * repmat(f(h_inf, -90)*f(m_inf, -90), 1, 2) * (-90 - Erev));  
  
  % simulate explicit solutions
  time = (1:1000)*dt;

  checkPeaks(I_int(:, 1), calc_I_ideal(10));
  checkPeaks(I_int(:, 2), calc_I_ideal(-50));
  
  
  
  function I_ideal = calc_I_ideal(v_step)
    I_ideal = [repmat(gmax*f(m_inf, -90)*f(h_inf, -90) *(-90 - Erev), 10, 1); ...
             gmax*(f(m_inf, -90) + (f(m_inf, v_step) - f(m_inf, -90)) .* (1 - exp(-time'/f(m_tau, v_step)))) ...
             .* (f(h_inf, -90) + (f(h_inf, v_step) - f(h_inf, -90)) .* (1 - exp(-time'/f(h_tau, v_step))))*(v_step - Erev)];
    %figure; plot([I_int(:, 2), I_ideal])
  end
  
  function checkPeaks(I_int, I_ideal)
    % test whole solution (quite big error exists :(
    assert(max(abs(I_int - I_ideal)) < 40);
    %figure; plot(abs(I_int - I_ideal))

    % check peaks of first voltage step
    [z peak_int] = max(I_int(:, 1));
    [z peak_ideal] = max(I_ideal(:, 1));
    
    % 1 dt of tolerance
    assertElementsAlmostEqual(peak_int, peak_ideal, 'absolute', 1);

    % compare steady state against ideal solution
    assertElementsAlmostEqual(I_int(end, 1), ...
                              I_ideal(end, 1), 'absolute', 1e-1);

  end
  end
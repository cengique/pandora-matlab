function param_I_2tauh_int_v_test
  
% param_I_2tauh_int_v_test - Unit test for param_I_2tauh_int_v.
%
% Usage:
%   param_I_2tauh_int_v_test
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
% $Id: param_I_2tauh_int_v_test.m 168 2010-10-04 19:02:23Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/11/01
  
% make an object
  m_inf = param_act([-50 -6]);
  m_tau = param_tau_v([1 2 50 5]);
  m = param_act_deriv_v(m_inf, m_tau);

  h_inf = param_act([-80 10]);
  h_tau = param_tau_v([5 10 70 5]);
  h = param_act_deriv_v(h_inf, h_tau);

  % keep same h_inf, only add h2_tau
  h2_tau = param_tau_v([40 60 70 5]);
  h2 = param_act_deriv_v(h_inf, h2_tau);

  dt = 1e-1; % [ms]
  time = (1:1000)*dt;
  
  gmax = 10;
  Erev = -80;

  % two ideal voltage steps:
  % -90 mV for 10 ms -> 10 mV for 100 ms
  % -90 mV for 10 ms -> -50 mV for 100 ms
  v_steps = [10 -50];
  ideal_v = [ [repmat(-90, 10, length(v_steps)); repmat(v_steps, 1000, 1)] ];

  % initialize, so it's part of outer scope
  I_int_all = [];
  I_int = [];
  
  is_plot = false;
  
  % when only h2_tau is used
  fh = 0;
  checkI();
  
  % when only h_tau is used
  fh = 1;
  checkI();

  % when both h_taus are used
  fh = 0.5;
  checkI();

  
  function checkI()
    I = param_I_2tauh_int_v([1 gmax Erev fh], m, h, h2);

    I_int_all = f(I, struct('v', ideal_v, 'dt', dt));
    if is_plot
      figure; plot(I_int_all); title([ 'fh=' num2str(fh) ])
    end

    % init test (redundant!)
    assertElementsAlmostEqual(I_int_all(1, :), ...
                              gmax * repmat(f(m_inf, -90)*f(h_inf, -90), 1, length(v_steps)) * (-90 - Erev));  
  
    % simulate explicit solutions for diff v_steps
    checkPeaks(1);
    checkPeaks(2);
  end
  
  function checkPeaks(v_step_num)
    I_ideal = calc_I_ideal(v_step_num);
    I_int = I_int_all(:, v_step_num);
    if is_plot
      figure; plot([I_int, I_ideal]); title([ 'v\_step=' num2str(v_steps(v_step_num)) ]);
    end
    
    % test whole solution (quite big error exists :(
    assert(max(abs(I_int - I_ideal)) < 40);
    %figure; plot(abs(I_int - I_ideal))

    % check peaks of first voltage step
    [z peak_int] = max(I_int);
    [z peak_ideal] = max(I_ideal);
    
    % 1 dt of tolerance
    assertElementsAlmostEqual(peak_int, peak_ideal, 'absolute', 1);

    % compare steady state against ideal solution
    assertElementsAlmostEqual(I_int(end, 1), ...
                              I_ideal(end, 1), 'absolute', 1e-1);
  end

  function I_ideal = calc_I_ideal(v_step_num)
    v_step = v_steps(v_step_num);
    I_ideal = [repmat(gmax*f(m_inf, -90)*f(h_inf, -90) *(-90 - Erev), 10, 1); ...
             gmax*(f(m_inf, -90) + (f(m_inf, v_step) - f(m_inf, -90)) .* (1 - exp(-time'/f(m_tau, v_step)))) ...
             .* (f(h_inf, -90) + (f(h_inf, v_step) - f(h_inf, -90)) .* ...
                 ( fh * (1 - exp(-time'/f(h_tau, v_step))) + ...
                   (1 - fh) * (1 - exp(-time'/f(h2_tau, v_step)))))*(v_step - Erev)];

  end    
end
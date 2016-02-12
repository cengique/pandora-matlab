function param_act_deriv_ab_v_test(ifplot)
  
% param_act_deriv_ab_v_test - Unit test for @param_act_deriv_ab_v.
%
% Usage:
%   param_act_deriv_ab_v_test
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
% $Id: param_act_deriv_ab_v_test.m 168 2010-10-04 19:02:23Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2015/05/22
  
  ifplot = defaultValue('ifplot', 0);

  % Make two version to test convertion between two parameter sets
  params = ...
      struct('V_half', -40, 'k', 4, 'delta', 0.8, 'tau0', 10);
  m1 = param_act_deriv_ab_v(params, 'act');

  m_inf = param_act([params.V_half params.k]);
  m_tau = param_tau_skewbell_v(params);

  % convert from half-act to delta param for alpha/beta  
  m2 = param_act_deriv_ab_v([3.3546e-5 0.7389 params.delta params.k], 'act');
  
  % two traces:
  % -90 mV for 10 ms -> 10 mV for 100 ms
  % -90 mV for 10 ms -> -50 mV for 100 ms
  ideal_v = [ [repmat(-90, 100, 1); repmat(10, 1000, 1)], ...
              [ repmat(-90, 100, 1); repmat(-50, 1000, 1)] ];

  % TODO: convert all times to [ms]?
  dt = 1e-1; % [ms]
  
  m1_int = f(m1, struct('v', ideal_v, 'dt', dt));
  m2_int = f(m2, struct('v', ideal_v, 'dt', dt));

  % test points
  assertElementsAlmostEqual(m1_int(1, :), repmat(f(m_inf, -90), 1, 2));
  assertElementsAlmostEqual(m2_int(1, :), repmat(f(m_inf, -90), 1, 2));
  assert(m1_int(end, 1) < f(m_inf, -20));
  assert(m1_int(end, 2) < f(m_inf, -55));
  
  % ideal solution for one step:
  time = (0:(1000 - 1))*dt;
  m_ideal = [repmat(f(m_inf, -90), 100, 1); f(m_inf, -90) .* exp(-time'/f(m_tau, 10))];

  % test whole solution
  assert(max(abs(m1_int(:, 1) - m_ideal)) < 1e-1);
  assert(max(abs(m2_int(:, 1) - m_ideal)) < 1e-1);

  % vector tests are not adequate for euclidian distance?
  %assertVectorsAlmostEqual(, 'absolute', );
  if ifplot
    plot(m_inf);
    plot(m_tau);

    plotFigure(plot_abstract({[(0:(1100 - 1))'*dt], [m1_int, m2_int(:, 1), m_ideal]}, ...
                             {'time [ms]', 'act'}, ...
                             '', {'integrated1 (-90 to +10)', ...
                        'integrated1 (-90 to -50)', ...
                        'integrated2 (-90 to +10)', ...
                        'calculated (-90 to +10)'}, 'plot'));
  end

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

  % Convert between two parameter sets
  Vh = -40;
  s = 4;
  a0 = 1e-5; % arbitrary
  b0 = a0 / exp(Vh)^(1/s);
  delta = 0.8;
  tau0 = 1 / ( a0^(1-delta) * b0^delta);

  m_inf = param_act([Vh s]);
  m_tau = param_tau_skewbell_v([tau0 delta Vh s]);

  % convert from half-act to delta param for alpha/beta
  
  m = param_act_deriv_ab_v([a0 b0 delta s], 'act');
  
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
  if ifplot
    plot(m_inf);
    plot(m_tau);

    plotFigure(plot_abstract({[(0:(1100 - 1))'*dt], [m_int, m_ideal]}, ...
                             {'time [ms]', 'act'}, ...
                             '', {'integrated (-90 to +10)', ...
                        'integrated (-90 to -50)', 'calculated (-90 to +10)'}, 'plot'));
  end

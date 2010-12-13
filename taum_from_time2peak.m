function taum_solved = taum_from_time2peak(tauh, ttp, props)

% taum_from_time2peak -  Approximate taum from tauh and time to peak.
%
% Usage:
% taum_solved = taum_from_time2peak(tauh, ttp, props)
%
% Parameters:
%   tauh: Vector of inactivation time constant, tauh, values.
%   ttp: Vector of time to peak values.
%   props: A structure with any optional properties.
%     p: The power of the activation gate (default=3).
%     taumInit: Initial value for fitting taum (default=0.5)
%     taumBounds: [min max] bounds for taum (default=[0 1]).
%
% Returns:
%   taum_solved: Numerical approximation to taum values.
%
% Description:
%
% Example:
% >> taum = taum_from_time2peak([1.2 1.5], [.5 .7], 
%             struct('taumInit', .1,'taumBounds', [0 10]))
% 
% See also: 
%
% $Id: plotVclampAbf.m 234 2010-10-21 22:06:52Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu> and
%         Logesh Dharmar <ldharma@emory.edu>, 2010/12/07
props = defaultValue('props', struct);
p = getFieldDefault(props, 'p', 3);
taum_init = ...
    repmat(getFieldDefault(props, 'taumInit', 0.5), ...
           1, length(tauh));
taum_bounds = ...
    repmat(getFieldDefault(props, 'taumBounds', [0 1]), ...
           length(tauh), 1);

minfunc = ...
    @(taum) sum(((taum+p*tauh)./taum - exp(ttp./taum)).^2);
taum_solved = ...
    fmincon(minfunc, taum_init, [], [], [], [], ...
            taum_bounds(:, 1), taum_bounds(:, 2), [], ...
            optimset('MaxFunEvals', 1000, 'MaxIter', 2000, ...
                     'Algorithm', 'interior-point'));

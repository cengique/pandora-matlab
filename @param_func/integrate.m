function var_int = integrate(a_ps, x, props)

% integrate - Integrates function over given data.
%
% Usage:
%   var_int = integrate(a_ps, x, props)
%
% Parameters:
%   a_ps: A param_func object.
%   x: input data (may include a structure with time step dt in [ms] and
%      voltage v in [mV]).
%   props: A structure with any optional properties.
%
% Returns:
%   var_int: Integrated variables.
%
% Description:
%   A param_func can be integrated if props.isIntable == 1. It must
% initiate the integration if it is not the toplevel function.
%
% Example:
%
% See also: 
%
% $Id: optimize.m 423 2011-03-24 20:37:15Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/05/16

% Copyright (c) 2009-2011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

props = defaultValue('props', struct);

s = solver_int({}, x.dt, [ 'solver for ' get(a_ps, 'id') ] );
s = initSolver(a_ps, s, struct('initV', x.v(1)));
var_int = integrate(s, x.v, props);

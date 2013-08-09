% MatHHsim is a module of the Pandora Toolbox for simulating arbitrary
% non-linear functions. It has built in Hodgkin-Huxley (HH) type ion channel
% current model functions. It simulates channel currents both by time
% functions and numerical integration. It is designed for fitting channel
% parameters to voltage-clamp data by defining channel currents as
% differential equations and integrating them with a general solver. See the
% Pandora voltage_clamp module for the parameter fitting functionality.
%
% Basic functionality:
% param_func - Base class for all parameterized functions.
% param_mult - Class composed of multiple param_func objects.
%
% Parameterized utility functions:
% param_func_nil - A null function, returns constant value.
% param_func_const - Same as param_func_nil, but has units.
% param_spline_func - Parameterized spline function to match an arbitrary shape.
%
% Internal functions:
% param_func_compiled - Compiled version of param_func without parameters
% 	used internally for speeding up integration.
%
% HH functions for simulating ideal voltage steps (no integration):
% act_inact_cur 	- Parameterized function for HH current.
% param_act_t		- An (in)activation function response to a voltage step.
% param_I_t 		- Current with activation (uses act_inact_cur and param_act_t).
%
% HH functions integrated over changing membrane voltage (Vm) (e.g, in voltage
% clamp):
% param_act		- Activation gate steady-state function of Vm.
% param_act_deriv_v 	- Derivative of an (in)activation function that uses param_act.
% param_act_int_v 	- (OBSOLETE) Same as param_act_deriv_v, but buggy.
% param_I_Neurofit 	- Convert Neurofit parameters to a param_I_int_v.
% param_tau_v 		- Time constant function as shifted and scaled logsig.
% param_tau_2sigmoids_v - Time constant function as product of two logsigs.
% param_tau_exp_v 	- Time constant function as exponential.
% param_tau_skewbell_v	-  Time constant function as skewed bell shape.
% param_act_int_v 	- Activation/inactivation gate function.
% param_I_v 		- (OBSOLETE?) An (non)inactivating current.
% param_I_int_v		- An (non)inactivating current (runs integration).
% param_HH_chan_int_v	- An (non)inactivating current with optional 2nd
% 			inactivation gate (runs integration).
% Integrator:
% solver_int - Solver for integrating a system of differential equations, dy/dt = A*x+b.
%
% Passive neuronal circuit parameter functions:
% param_Re_Ce_cap_leak_act_int_t - Membrane capacitance and leak
% 	integrated over time with a model of electrode resistance and
% 	capacitance.
% param_Rs_cap_leak_int_t - (OBSOLETE) Membrane capacitance and leak
% 	integrated over time.


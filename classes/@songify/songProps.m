function obj = songProps(obj)

% songProps: Get properties of a particular song
%
% Usage:
% obj = songProps(obj)
%
% Description:
%
%   Adds a bunch of properties to the props attribute of the object
% 
% See also: songify, plot_abstract

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% Find particular features
obj.features.entropy = entropy(abs(obj.sgram.data));
plot(obj.props.entropy, '.');

disp(obj.props);
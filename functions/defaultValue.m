function value = defaultValue(varname, a_defaultvalue)

% defaultValue - If variable unset (either nonexistent or empty), assign it
% a default value. Otherwise the variable remains unchanged.
%
% Usage:
%   var = defaultValue(varname, a_defaultvalue)
%
% Description:
%   If the variable has already been defined, it keeps unchanged. If the
% variable doesn't exist or is an empty matrix, it will be assigned a
% default value to it.
%
% Parameters: 
%   varname: a string. the name of the variable.
%   a_defaultvalue: value for the variable.
% 
% Example:
%   SamplingRate = defaultValue('SamplingRate', 10);
%
% Author: Li, Su

% Modified: Cengiz Gunay, 2008/04/11 - naturalized name and documentation
% for Pandora.

if evalin('caller', ['~exist(''' varname ''',''var'') || isempty(' varname ')'])
    value=a_defaultvalue;
else
    value=evalin('caller', varname);
end

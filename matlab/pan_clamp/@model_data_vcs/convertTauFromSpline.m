function a_md = convertTauFromSpline(a_md, props)

% convertTauFromSpline - Converts m and h tau functions from spline to Hodgkin-Huxley form.
%
% Usage:
% a_md = convertTauFromSpline(a_md, props)
%
% Parameters:
%   a_md: A model_data_vcs object.
%   props: A structure with any optional properties.
%     vRange: Voltage values to evaluate spline function (default=-30:60)
%		
% Returns:
%   a_md: (updated)
%
% Description:
%
% Example:
% >> a_test_md = convertTauFromSpline(a_md)
%
% See also: model_data_vcs, voltage_clamp, plot_abstract, plotFigure
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/05/31

if ~ exist('props', 'var')
  props = struct;
end

v_range = getFieldDefault(props, 'vRange', -30:60);

model_f = get(a_md, 'model_f');

% correct paramRanges after conversion
model_f = ...
    setProp(param_HH_chan_int_v(model_f), ...
            'parfor', 1, 'paramRanges', [0 4; 0 10e3; -200 200; 0 1]');

model_f.m.tau = ...
    convertTauFromSpline(model_f, 'm', ...
                         struct('vValues', v_range, 'ifPlot', 1));
model_f.h.tau = ...
    convertTauFromSpline(model_f, 'h', ...
                         struct('vValues', v_range, 'ifPlot', 1));

% TODO 
% add h2 here

% update
a_md = updateModel(a_md, model_f);
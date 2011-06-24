function a_md = convertTauFromSpline(a_md, props)

% convertTauFromSpline - Converts m and h tau functions from spline to Hodgkin-Huxley form.
%
% Usage:
% a_md = convertTauFromSpline(a_md, name_append, props)
%
% Parameters:
%   a_md: A model_data_vcs_DmNavTPS object.
%   props: A structure with any optional properties.
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
% $Id: convertTauFromSpline.m 276 2010-11-09 23:30:35Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/05/31

if ~ exist('props', 'var')
  props = struct;
end

v_range = getFieldDefault(props, 'vRange', -30:60);

model_nat_nap = get(a_md, 'model_f');

% correct paramRanges after conversion
I_NaT = ...
    setProp(param_HH_chan_int_v(model_nat_nap.nat), ...
            'parfor', 1, 'paramRanges', [0 4; 0 10e3; -200 200; 0 1]');


I_NaT.m.tau = ...
    convertTauFromSpline(I_NaT, 'm', ...
                         struct('vValues', v_range, 'ifPlot', 1));
I_NaT.h.tau = ...
    convertTauFromSpline(I_NaT, 'h', ...
                         struct('vValues', v_range, 'ifPlot', 1));

% update
model_nat_nap.nat = I_NaT;
model_nat_nap.nap.m = I_NaT.m;
a_md = updateModel(a_md, model_nat_nap);
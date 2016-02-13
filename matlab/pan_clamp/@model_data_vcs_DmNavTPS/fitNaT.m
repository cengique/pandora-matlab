function a_md = fitNaT(a_md, props)

% fitNaT - Fits only by optimizing NaT parameters.
%
% Usage:
% a_md = fitNaT(a_md, props)
%
% Parameters:
%   a_md: A model_data_vcs_DmNavTPS object.
%   props: A structure with any optional properties.
%	   (passed to model_data_vcs/fit)
%		
% Returns:
%   a_md: (updated)
%
% Description:
%
% Example:
% >> a_test_md = fitNaT(a_md)
%
% See also: model_data_vcs, voltage_clamp, plot_abstract, plotFigure
%
% $Id: fitNaT.m 276 2010-11-09 23:30:35Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/05/31

if ~ exist('props', 'var')
  props = struct;
end

v_range = getFieldDefault(props, 'vRange', -30:60);

model_nat_nap = get(a_md, 'model_f');
md_id = get(a_md, 'id');
md_name = get(a_md, 'name');

% make md object just for NaT since NaP component is negligible
nat_fit_md = ...
    fit(model_data_vcs(model_nat_nap.nat, a_md.filt_vc, [ 'fit NaT: ' md_id ]), '', ...
        mergeStructs(props, struct('dispParams', 1, 'dispPlot', 1, ...
                                   'vLimits', [-80 60], ...
                                   'saveModelFile', [ 'splice/' md_name ...
                    '/' md_id '-fit-NaT-skewbell-v%d.mat'], ...
                                   'saveModelAutoNum', 1, ...
                                   'savePlotFile', ...
                                   [ 'doc/' md_name ...
                    '/' md_id '-vclamp-fit-NaT-model-taus.eps'], ...
                                   'noLegends', 1, ...
                                   'fitRangeRel', [1 -10 130], 'fitLevels', 3:15, ...
                                   'outRangeRel', [1 .1 10; 2 .3 10], ...
                                   'optimset', struct('Display', 'iter', 'TolFun', 1e-2, 'TolX', ...
                                                  1e-2))));

% update
model_nat_nap.nat = nat_fit_md.model_f;
model_nat_nap.nap.m = model_nat_nap.nat.m;
a_md = updateModel(a_md, model_nat_nap);
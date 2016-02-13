function a_md = fitNaPgmaxE(a_md, props)

% fitNaPgmaxE - Only fit NaP gmax and E parameters to data.
%
% Usage:
% a_md = fitNaPgmaxE(a_md, props)
%
% Parameters:
%   a_md: A model_data_vcs_DmNavTPS object.
%   props: A structure with any optional properties.
%		
% Returns:
%   a_md: Updated object.
%
% Description:
%   To make the fit fast, subtracts NaT from data and fits NaP properties
% to subtracted data. Updates NaP model and returns original a_md.
%
% Example:
% >> a_md = fitNaPgmaxE(a_md))
%
% See also: model_data_vcs_DmNavTPS
%
% $Id: fitNaPgmaxE.m 234 2010-10-21 22:06:52Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/05/31

if ~ exist('props', 'var')
  props = struct;
end

a_model = get(a_md, 'model_f');

a_model.nap = ...
    selectFitParams(a_model.nap, '.*', 0, struct('recursive', 1));
a_model.nap = ...
    selectFitParams(a_model.nap, 'gmax|E', 1);

disp('free params:')
getParamsStruct(a_model.nap, struct('onlySelect', 1))

%getParamsStruct(a_model.nap)

% make a new md for NaT here
nat_md = ...
    model_data_vcs(a_model.nat, a_md.filt_vc, 'nat');

% subtract NaT model so can fit only NaP
vc_sub_NaT = a_md.filt_vc;
vc_sub_NaT.i = ...
    vc_sub_NaT.i - nat_md.model_vc.i;
plot(vc_sub_NaT, [ 'sub NaT, ' get(a_md, 'id') ]);

% for fitting nap
nap_md = ...
    model_data_vcs(a_model.nap, vc_sub_NaT, [ 'NaP fit to sub NaT, ' get(a_md, 'id') ]);

splice_dir = ...
    create_dir([ 'splice/' a_md.name ]);
doc_dir = ...
    create_dir([ 'doc/' a_md.name ]);

    

nap_md = ...
    fit(nap_md, '', ...
        mergeStructs(props, ...
                     struct('dispParams', 1, 'dispPlot', 1, ...
                            'vLimits', [-80 60], ...
                            'saveModelFile', [ splice_dir filesep get(a_md, 'id') '-fit-NaP-v%d.mat' ], ...
                            'saveModelAutoNum', 1, ...
                            'savePlotFile', ...
                            [doc_dir filesep get(a_md, 'id') '-fit-NaP-model.eps' ], 'noLegends', 1, ...
                            'fitRangeRel', [1 -10 45], 'fitLevels', 3:15, ...
                            'outRangeRel', [1 10 20], ...
                            'optimset', ...
                            struct('Display', 'iter', ...
                                   'TolFun', 1e-4, 'TolX', 1e-2))));

disp('Updating model...')
a_model.nap = nap_md.model_f;
a_md = updateModel(a_md, a_model);
end

function dirname = create_dir(dirname)
if ~ exist(dirname, 'dir')
  mkdir(dirname);
end
end
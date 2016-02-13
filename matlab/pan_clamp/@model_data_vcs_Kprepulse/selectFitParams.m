function a_md = selectFitParams(a_md, select_what, fit_nofit, props)

% selectFitParams - Constrain or release model parameters for fast current.
%
% Usage:
% a_md = selectFitParams(a_md, select_what, fit_nofit, props)
%
% Parameters:
%   a_md: A model_data_vcs object.
%   select_what: One of 'passive', 'fast', 'fastInact'
%   fit_nofit: 1 for including in fits and 0 for not.
%   props: A structure with any optional properties.
% 
% Returns:
%   a_md: Updated object.
%
% Description:
%
% Example:
% >> a_md = selectFitParams(model_data_vcs(model, data_vc))
%
% See also: model_data_vcs, model_data_vcs/fit, voltage_clamp, plot_abstract, plotFigure
%
% $Id: selectFitParams.m 234 2010-10-21 22:06:52Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/23

% TODO: move these to param_func and param_mult to have a better
% selection system.

a_m = a_md.model_data_vcs.model_f;

switch (select_what)
  case 'fast'
    a_m.I.Kf = fitNoFit(a_m.I.Kf);
    a_m.I.Kf.m.inf = fitNoFit(a_m.I.Kf.m.inf);
    a_m.I.Kf.m.tau = fitNoFit(a_m.I.Kf.m.tau);
    a_m.I.Kf.h.inf = fitNoFit(a_m.I.Kf.h.inf);
    a_m.I.Kf.h.tau = fitNoFit(a_m.I.Kf.h.tau);
    a_m.I.Kf.h2.inf = fitNoFit(a_m.I.Kf.h2.inf);
    a_m.I.Kf.h2.tau = fitNoFit(a_m.I.Kf.h2.tau);
  case 'fastInactInf'
    a_m.I.Kf.h.inf = fitNoFit(a_m.I.Kf.h.inf);
  case 'slow'
    a_m.I.Ks = fitNoFit(a_m.I.Ks);
    a_m.I.Ks.m.inf = fitNoFit(a_m.I.Ks.m.inf);
    a_m.I.Ks.m.tau = fitNoFit(a_m.I.Ks.m.tau);
  case 'passive'
    a_m = fitNoFit(a_m, fit_nofit);
  case 'pq'
    if fit_nofit == 1
      a_m.I.Kf = removeSelect(a_m.I.Kf);
      a_m.I.Ks = removeSelect(a_m.I.Ks);
    else
      a_m.I.Kf = setProp(a_m.I.Kf, 'selectParams', {'gmax', 'fh'});
      a_m.I.Ks = setProp(a_m.I.Ks, 'selectParams', {'gmax'});      
    end
  case 'onlyTaus'
    a_m.I.Kf = removeSelect(a_m.I.Kf);
    a_m.I.Ks = removeSelect(a_m.I.Ks);
    
  otherwise
    error('Select what?');
end
% write back
a_md.model_data_vcs.model_f = a_m;
a_md.md_pre.model_f = a_m;
% end of main func

function m = fitNoFit(m)
if fit_nofit == 1
  m = removeSelect(m);
else 
  m = selectNone(m);
end
end

function m = removeSelect(m)
if isfield(m.props, 'selectParams')
  m.props = rmfield(m.props, 'selectParams');
end
end

function m = selectNone(m)
m = setProp(m, 'selectParams', {});
end

end
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
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/23

% TODO: move these to param_func and param_mult to have a better
% selection system.

a_m = a_md.model_f;

switch (select_what)
  case 'passive'
    a_m = fitNoFit(a_m);
  case 'pq'
    if fit_nofit == 1
      a_m.I = removeSelect(a_m.I);
    else
      a_m.I = setProp(a_m.I, 'selectParams', {'gmax'});
    end
  case 'all'
    a_m.I = fitNoFit(a_m.I);
    a_m.I.m.inf = fitNoFit(a_m.I.m.inf);
    a_m.I.h.inf = fitNoFit(a_m.I.h.inf);
    a_m.I.h2.inf = fitNoFit(a_m.I.h2.inf);    
    a_m.I.m.tau = fitNoFit(a_m.I.m.tau);
    a_m.I.h.tau = fitNoFit(a_m.I.h.tau);
    a_m.I.h2.tau = fitNoFit(a_m.I.h2.tau);
  case 'taus'
    a_m.I.m.tau = fitNoFit(a_m.I.m.tau);
    a_m.I.h.tau = fitNoFit(a_m.I.h.tau);
    case 'infs'
        a_m.I.m.inf = fitNoFit(a_m.I.m.inf);
    a_m.I.h.inf = fitNoFit(a_m.I.h.inf);
%     a_m.I.h2.inf = fitNoFit(a_m.I.h2.inf);            
  otherwise
    error('Select what?');
end
% write back
a_md.model_f = a_m;
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
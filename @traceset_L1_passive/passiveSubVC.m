function [sub_vc pas_doc] = passiveSubVC(traceset, avg_vc, prot_name, props)

% passiveSubVC - Subtract passive currents.
%
% Usage:
% [sub_vc pas_doc] = passiveSubVC(traceset, avg_vc, prot_name, props)
%
% Parameters:
%   traceset: A traceset object.
%   avg_vc: A VC to subtract from.
%   prot_name: Name of protocol to choose from traceset treatments. Also
%   	added to saved file name.
%   props: Structure with optional parameters.
%
% Returns:
%   sub_vc: Subtracted VC object
%   pas_doc: The plot document.
%
% Description:
%   Also generates statistics and saves a lot of files. Will create a
% LaTeX document in the proper directory.
%
% See also: traceset_L1_passive, data_L1_passive
%
% $Id: passiveSubVC.m 896 2007-12-17 18:48:55Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/02/04

% Copyright (c) 2011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% TODO: make it only for avg and save it permanently?

props = mergeStructs(defaultValue('props', struct), get(traceset, 'props'));
traceset_id = get(traceset, 'id');
prot_zoom = ...
    getFieldDefault(getFieldDefault(props, 'protZoom', struct), ...
                    prot_name, repmat(NaN, 1, 4));

% leak & passive subtract (TODO: make it optional!)
ts_db_file = [ props.docDir filesep traceset_id filesep 'passive_params_db.mat' ];
load(ts_db_file); % a_db
ts_stats_db = statsMeanSE(a_db);
      
% create a passive params object, simulate and subtract
capleakReCe_f = ...
    param_Re_Ce_cap_leak_act_int_t(...
      struct('Re', ts_stats_db('mean', 'fit_Re_MO').data, ...
             'Ce', ts_stats_db('mean', 'fit_Ce_pF').data * 1e-3, ...
             'gL', ts_stats_db('mean', 'fit_gL_nS').data * 1e-3, ...
             'EL', ts_stats_db('mean', 'fit_EL_mV').data, ...
             'Cm', ts_stats_db('mean', 'fit_Cm_pF').data * 1e-3, ...
             'delay', ts_stats_db('mean', 'fit_delay_ms').data, ...
             'offset', ts_stats_db('mean', 'fit_offset_pA').data * 1e-3), ...
      ['cap, leak, Re and Ce (int)'], ...
      struct('parfor', 1));
      
a_md = ...
    model_data_vcs(capleakReCe_f, avg_vc, ...
                   [ avg_vc.id ': capleak, Re, Ce est']);

% make plot of simulated passive
pas_plot_title = ...
    [ 'Estimated passive component compared to average ' properTeXLabel(prot_name) ' protocol of ' ...
      properTeXLabel(traceset_id) '.' ];
pas_plot_name = ['compare-est-passive-to-average-' ...
                       properTeXFilename(prot_name)];
% HACK:
vc_prot_zoom = prot_zoom;
vc_prot_zoom(3:4) = vc_prot_zoom(3:4) * 1e6;
pas_doc = doc_plot(plotDataCompare(a_md, [ ' - ' pas_plot_title], ...
                                   struct('showSub', 1, 'noTitle', 1, ...
                                          'axisLimits', vc_prot_zoom, ...
                                          'fixedSize', [6 6])), ...
                   pas_plot_title, ...
                   [ pas_plot_name ], struct('width', '.7\columnwidth'), ...
                   properTeXLabel([ properTeXFilename(traceset_id) '-' pas_plot_name ]), ...
                   mergeStructs(props, ...
                                struct('plotRelDir', ...
                                       [properTeXFilename(traceset_id) '/' ])));

% actual subtraction here
sub_vc = avg_vc - a_md.model_vc;
sub_vc.i = set(sub_vc.i, 'id', [get(avg_vc.i, 'id') '[LS]' ]);

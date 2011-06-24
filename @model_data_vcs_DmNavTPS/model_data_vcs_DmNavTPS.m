function a_md = model_data_vcs_DmNavTPS(model_nat, model_nap, data_vc, ...
                                        name, id, props)

% model_data_vcs_DmNavTPS - Contains separate transient and persistent DmNav models and oocyte data.
%
% Usage:
% a_md = model_data_vcs_DmNavTPS(model_nat, model_nap, data_vc, name, id, props)
%
% Parameters:
%   model_nat: Can be a param_func or a NeuroFit file name. Make sure to specify
%   		required paramsNeurofit props below.
%   model_nap: Can be empty or a param_func. If empty, it a default will
%   		be created from model_nat.
%   data_vc: Data file name or voltage_clamp data object (unfiltered).
%   name: The DmNav name (e.g., 'DmNav43')
%   id: Identification string used for display and in file names
%   	generated. Use date, cell identification and leak subtration like
%   	'WHL Cell 2 2011-02-18 LS'. Do not add the DmNav name (see above).
%   props: A structure with any optional properties.
%
% Returns a structure object with the following fields:
%   model_data_vcs, 
%   filt_vc: 1kHz lowpass filtered version of data_vc.
%
% Description:
%   Transient and persistent models are kept separate (and thus "TPS")
% under param_mult object model_f as nat and nap, respectively.
%
% General methods of model_data_vcs_DmNavTPS objects:
%   model_data_vcs_DmNavTPS		- Construct a new model_data_vcs_DmNavTPS object.
%
% Additional methods:
%   See methods('model_data_vcs_DmNavTPS')
%
% See also: voltage_clamp, param_func
%
% $Id: model_data_vcs_DmNavTPS.m 451 2011-04-18 09:54:33Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2011/05/31

% Copyright (c) 2007-2011 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 % Called with no params
  a_md = struct;
  a_md.md_pre = model_data_vcs;
  a_md = class(a_md, 'model_data_vcs_DmNavTPS', model_data_vcs);
elseif isa(model_nat, 'model_data_vcs_DmNavTPS') % copy constructor?
  a_md = model_nat;
else
  props = defaultValue('props', struct);
  
  if ischar(model_nat)
    % assume Neurofit filename
    model_nat = ...
        param_I_Neurofit(paramsNeurofit(model_nat), ...
                         name, ...
                         mergeStructs(props, ...
                                      struct('name', 'nat', 'tauDt', 1, ...
                                             'gmaxDS', 1e-6, 'parfor', ...
                                             1)));
  else
    model_nat = ...
        setProp(model_nat, 'name', 'nat');
  end

  if isempty(model_nap)
    model_nap = ...
        param_HH_chan_int_v(struct('p', 3, 'gmax', 1, 'E', 40, 'fh', 1), ...
                            model_nat.m, ...
                            param_func_nil(1), [ 'I_{' name '}' ], ...
                            struct('name', [ 'nap' ], 'parfor', 1));
  end
  
  % load data if necessary
  if ischar(data_vc)
    s = load(data_vc);
    data_vc = s.sub_vc;
  end
  
  % filter data
  filt_vc = data_vc;
  filt_vc.i = lowpassfilt(filt_vc.i, 4, 1000);

  % create object
  a_md = struct;
  a_md.name = name;
  a_md.filt_vc = filt_vc;
  a_md = class(a_md, 'model_data_vcs_DmNavTPS', ...
               model_data_vcs(model_nat + model_nap, data_vc, [ id ], props));
end

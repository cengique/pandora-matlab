function a_md = model_data_vcs(model_f, data_vc, id, props)

% model_data_vcs - Combines model description that fits a voltage clamp data.
%
% Usage:
% a_md = model_data_vcs(model_f, data_vc, id, props)
%
% Parameters:
%   model_f: Model as a param_func object or a NeuroFit file name. 
%	     Make sure to specify required param_I_Neurofit props below. 
%   data_vc: Data as a voltage_clamp object directly or in a MAT file or
%   	     from an ABF file.
%   id: Identification string.
%   props: A structure with any optional properties.
%
% Returns a structure object with the following fields:
%   model_f, data_vc,
%   model_vc: Obtained by simulating model.
%
% Description:
%   For tasks such as plotting comparison of model to data and generating
% initial fits for model. Can also have a GUI here for fitting.
%
% General methods of model_data_vcs objects:
%   model_data_vcs		- Construct a new model_data_vcs object.
%
% Additional methods:
%   See methods('model_data_vcs')
%
% See also: voltage_clamp, param_func
%
% $Id$
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/11

% Copyright (c) 2007-2010 Cengiz Gunay <cengique@users.sf.net>.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

if nargin == 0 % Called with no params
  a_md = struct;
  a_md.model_f = param_func;
  a_md.model_vc = voltage_clamp;
  a_md.data_vc = voltage_clamp;
  a_md.id = '';
  a_md.props = struct;
  a_md = class(a_md, 'model_data_vcs');
elseif isa(model_f, 'model_data_vcs') % copy constructor?
  a_md = model_f;
else
  if ~ exist('props', 'var')
    props = struct;
  end

  % load model if necessary
  if ischar(model_f)
    [pathstr, filename, ext] = fileparts(model_f);
    if strcmpi(ext, '.txt')
      % assume Neurofit filename
      model_f = ...
          param_I_Neurofit(paramsNeurofit(model_f), ...
                           'I', ...
                           mergeStructs(props, ...
                                        struct('tauDt', 1, 'gmaxDS', 1e-6, ...
                                               'parfor', 1)));
    elseif strcmpi(ext, '.mat')
        model_f = getfield(load(model_f), 'a_model');
    else
      error(['Model data file ''' model_f ''' not recognized. Only Neurofit ' ...
             'reports (.txt) and Matlab (.mat) files accepted.']);
    end
  end
  
  % load data if necessary
  if ischar(data_vc)
    [pathstr, filename, ext] = fileparts(data_vc);
    if strcmpi(ext, '.abf')
      data_vc = ...
          abf2voltage_clamp(data_vc, [ ', ' name]);
      elseif strcmpi(ext, '.mat')
        s = load(data_vc);
        data_vc = s.sub_vc;
    else
      error([ 'Format of data file ''' data_vc ''' not recognized. Only know ' ...
              '.MAT or .ABF files.']);
    end
  end
  
  a_md = struct;
  a_md.model_f = model_f;
  a_md.model_vc = simModel(data_vc, model_f, props);  % simulate model
  a_md.data_vc = data_vc;
  a_md.id = defaultValue('id', [ get(a_md.model_f, 'id') ' vs. ' get(a_md.data_vc, 'id')]);
  a_md.props = props;
  
  a_md = class(a_md, 'model_data_vcs');
end

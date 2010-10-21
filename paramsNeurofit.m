function params = paramsNeurofit(file_name, props)

% paramsNeurofit - Extract Hodgkin-Huxley type ion channel parameters from a Neurofit report file.
%
% Usage:
% params = paramsNeurofit(file_name, props)
%
% Parameters:
%   file_name: Full path to filename.
%   props: A structure with any optional properties.
%		
% Returns:
%   params: A structure with Neurofit parameters. tau_m and tau_h
%     contains matrices with 3 rows: v values, tau values and logical
%     values if they are included in the fits.
%
% Description:
%   Extracts parameters from fits obtained by Neurofit to voltage clamp
% data. Use File->Save report in Neurofit after you copy all the fitted
% values as actual parameters. See Neurofit web page for more information
% (http://www.uoguelph.ca/~awillms/neurofit/). Data units are preserved
% from Neurofit since they are not annotated in the report file.
%
% Example:
% >> params = paramsNeurofit('my-fit-Na-chan_Report.txt')
%
% See also: 
%
% $Id: paramsNeurofit.m 172 2010-10-06 00:38:29Z cengiz $
%
% Author: Cengiz Gunay <cgunay@emory.edu>, 2010/10/13

% read the whole file at once
nfit_str = fileread(file_name);

% get p & q
pq_val = regexp(nfit_str, '\n\s+(p|nh|nnonh)\s*=\s*(\d+)', 'tokens');

params = struct;
addParams(pq_val);

% rename 'nh' => 'q'
% $$$ params.q = params.nh;
% $$$ params = rmfield(params, 'nh');

% model section 
act_inf_str = ...
    regexp(nfit_str, '\n\s+Model Parameters.*Fit\?\s*(\n.*)\n\s*Time', 'tokens');

% get params
act_inf_val = regexp(act_inf_str{1}{1}, '\n\s+(\w+)\s*(-?\d+\.?\d*)', 'tokens');

addParams(act_inf_val);

% time constants
tau_str = ...
    regexp(nfit_str, '\n\s+Time Constants:\s*(\n.*)$', 'tokens');

%disp(tau_str{1}{1})

% get tau, volt, fitted value and is fitted answer

addTau(tau_str, 'm');
addTau(tau_str, 'h1');

% check for a 2nd tauh
if ~isempty(regexp(tau_str{1}{1}, '\n\s+Th2\('))
  addTau(tau_str, 'h2');
end

% function ends here

% convert cell of param-value pairs to a structure
  function addParams(cell_str)
  for par_num = 1:length(cell_str)
    params.(cell_str{par_num}{1}) = str2num(cell_str{par_num}{2});
  end
  end

% gate= 'm' or 'h'
  function addTau(tau_str, gate)
  cell_str = ...
    regexp(tau_str{1}{1}, ['\n\s+T' gate '\((-?\d+)\)\s*(-?\d+\.?\d*)\s[^\n]*(yes|no)'], ...
           'tokens');

  num_taus = length(cell_str);
  tau_v = repmat(NaN, 1, num_taus);
  tau_t = tau_v;
  tau_fit = false(1, num_taus);
  for par_num = 1:num_taus
    tau_v(par_num) = str2num(cell_str{par_num}{1});
    tau_t(par_num) = str2num(cell_str{par_num}{2});
    tau_fit(par_num) = strcmp(cell_str{par_num}{3}, 'yes');
  end
  params.([ 'tau_' gate ]) = [tau_v; tau_t; tau_fit];
  end
end


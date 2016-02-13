function an_addedcols_db = addPostDBColumns(a_db)

% addPostDBColumns - Adds measures based on raw measures of a db.
%
% Usage:
% an_addedcols_db = addPostDBColumns(a_db)
%
% Description:
%   Adds PulsePotSagDivMin, InputResGOhm, and InputCappF columns.
%
%   Returns:
%	an_addedcols_db: New db object.
%
% See also: tests_db/addColumn
%
% $Id$
% Author: Cengiz Gunay <cgunay@emory.edu>, 2005/10/04

test_names = fieldnames(get(a_db, 'col_idx'));

if ismember('PulsePotSag', test_names)
  sag_name = 'PulsePotSag';
  min_name = 'PulsePotMin';
  tau_name = 'PulsePotTau';
  spontavg_name = 'IniSpontPotAvg';
  spontisi_name = 'IniSpontSpikeRateISI';
  cip_levels = a_db(:, 'pAcip').data;
  sagdiv_name = 'PulsePotSagDivMin';
  inputres_name = 'InputResGOhm';
  inputcap_name = 'InputCappF';
  recfirstisi_name = 'RecSpontFirstISI';
  inirec_isiratio_name = 'IniRecISIRatio';
  recini_rateratio_name = 'RecIniSpontRateRatio';
  sfa_rateratio_name = 'PulseSFARatio';
  pulse_inirate_name = 'PulseIni100msSpikeRateISI';  
  pulse_lastrate_name = 'PulseIni100msRest2SpikeRateISI';  
else
  sag_name = 'PulsePotSag_H100pA';
  min_name = 'PulsePotMin_H100pA';
  tau_name = 'PulsePotTau_H100pA';

  if ismember('IniSpontPotAvg_0pA', test_names)
    spont_suffix = '_0pA';
  else
    % if no spont trace, then take it from +100 pA
    spont_suffix = '_D100pA';
  end
  spontavg_name = [ 'IniSpontPotAvg' spont_suffix ];
  spontisi_name = [ 'IniSpontSpikeRateISI'  spont_suffix ];
  cip_levels = repmat(-100, dbsize(a_db, 1), 1);
  sagdiv_name = 'PulsePotSagDivMin_H100pA';
  inputres_name = 'InputResGOhm_HpA';
  inputcap_name = 'InputCappF_HpA';
  recfirstisi_name = 'RecSpontFirstISI_H100pA';
  inirec_isiratio_name = 'IniRecISIRatio_H100pA';
  recini_rateratio_name = 'RecIniSpontRateRatio_H100pA';
  recini_drateratio_name = 'RecIniSpontRateRatio_D100pA';
  sfa_rateratio_name = 'PulseSFARatio_D100pA';
  pulse_inirate_name = 'PulseIni100msSpikeRateISI_D100pA';
  pulse_lastrate_name = 'PulseIni100msRest2SpikeRateISI_D100pA';  
end

% Add some new measures
input_res = (a_db(:, min_name).data - a_db(:, spontavg_name).data) ./ cip_levels;

an_addedcols_db = ...
    addColumns(a_db, {sagdiv_name, inputres_name, inputcap_name, ...
		      inirec_isiratio_name, sfa_rateratio_name}, ...
	       [-a_db(:, sag_name).data ./ a_db(:, min_name).data, ...
		input_res, a_db(:, tau_name).data ./ input_res, ...
		(1e3 ./ a_db(:, recfirstisi_name).data + 1) ./ ...
		(a_db(:, spontisi_name).data + 1), ...
		a_db(:, pulse_inirate_name).data ./ a_db(:, pulse_lastrate_name).data ]);

% Maybe add this one, too, if it's a model db
if ~ismember(recini_rateratio_name, test_names)
  spont_rate_data = (an_addedcols_db(:, [ 'IniSpontSpikeRate'  spont_suffix ]).data + 1);
  spont_amp_data = an_addedcols_db(:, [ 'SpontSpikeAmplitudeMean'  spont_suffix ]).data;
  spont_pot_data = an_addedcols_db(:, [ 'IniSpontPotAvg'  spont_suffix ]).data;
  an_addedcols_db = ...
      addColumns(an_addedcols_db, ...
		 {recini_rateratio_name, recini_drateratio_name, 'PulseSpontAmpRatio_D100pA', ...
		  'RecIniSpontPotRatio_H100pA', 'RecIniSpontPotRatio_D100pA'}, ...
		 [(an_addedcols_db(:, 'RecSpont1SpikeRate_H100pA').data  + 1) ./ ...
		  spont_rate_data, ...
		  (an_addedcols_db(:, 'RecSpont1SpikeRate_D100pA').data  + 1) ./ ...
		  spont_rate_data, ...
		  an_addedcols_db(:, 'PulseSpikeAmplitudeMean_D100pA').data ./ spont_amp_data, ...
		  an_addedcols_db(:, 'RecSpontPotAvg_H100pA').data ./ spont_pot_data, ...
		  an_addedcols_db(:, 'RecSpontPotAvg_D100pA').data ./ spont_pot_data, ...
		  ]);
  if ismember('PulseSpontAmpRatio_D40pA', test_names)
    an_addedcols_db = ...
	addColumns(an_addedcols_db, ...
		   {'PulseSpontAmpRatio_D40pA', 'PulseSpontAmpRatio_D200pA'}, ...
		   [ an_addedcols_db(:, 'PulseSpikeAmplitudeMean_D40pA').data ./ spont_amp_data, ...
		    an_addedcols_db(:, 'PulseSpikeAmplitudeMean_D200pA').data ./ spont_amp_data ]);
  end
end


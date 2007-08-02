function [ciptype, on, off, finish, bias, pulse] = ns_CIPform(traceset,trace_index)

% CIPform - Extracts current bias and pulse information from the current channel.
%
% Usage:
% [ciptype, on, off, finish, bias, pulse] = ns_CIPform(traceset,trace_index)
%
% Description:
%
%   Parameters:
%	traceset: A physiol_cip_traceset object.
%	trace_index: Index of item in traceset
%
% See also: cip_traces, params_tests_dataset, params_tests_db
%
% $Id$
%
% Author: Thomas Sangrey, 2005
 
% Modified by: 
%   Jeremy Edgerton, 2005.
%   Cengiz Gunay, 2005/08/15. Added property to specify cipList externally.
%   Li, Su, 2007/06/10. Parses HDF5 info from the cipList structure.
  
% TODO:
% - if current level is way off, this script should signal an error. Currently 
% there is no way to tell how much it was off.

  warning off MATLAB:divideByZero;
  warning off MATLAB:polyfit:PolyNotUnique;

  %#sprintf('data file: %s, trace number: %d', traceset.data_src, trace_index)

  % Create list of all available cip step amplitudes.
  traceset_props = get(traceset, 'props');
  if isfield(traceset_props, 'cip_list') 
    cipList = traceset_props.cip_list; %# get it from props
  else
    %# static list of cips
    cipList = [-200,-150,[-100:10:100],150,200,250,300,400,500];
  end
  %	cipList = [-200:100:500];


  if isstruct(cipList)
    % method 1: read cip information from the meta data
    idx = mod(traceset_props.Trials{trace_index}.InChainIndex, length(cipList.Amplitude)) + 1;
    pulse = cipList.Amplitude(idx);
    on = cipList.StartTime/traceset.params_tests_dataset.dt;
    off = on + cipList.Duration/traceset.params_tests_dataset.dt;
    ciptype = sign(pulse);
    bias = 0;
    current = ns_read(traceset_props.Trials{trace_index}.AcquisitionData{traceset.ichan});
    finish = current.Samples;
    if ciptype == 0
      bias = round(median(current.Y)*10)/10;
    else
      bias = round(median(current.Y(1:on-10))*10)/10;
    end

  else
    nSD = 10;	% number of standard deviations for transition threshold
    hfig = 1;	% figure number on which to plot
    current = 100 * loadtraces(traceset.data_src, ...
                               num2str(getItem(traceset, trace_index)), ...
                               traceset.ichan, 1) / traceset.igain;
    % method 2, calculate cip from the actual stim trace
    
    % Multiplication by 1000 converts current from nA to pA.
    windowsize = 100;	% size of sliding window for moving average.
    if length(current) < 3*windowsize
      error('The current trace does not have enough data points.');
    end
    filtcurr = filter(ones(1, windowsize)/windowsize, 1, current);	
    % remove ends of filtered trace
    filtcurr = filtcurr(windowsize + 1:length(filtcurr) - windowsize);
    dt = get(traceset, 'dt');
    maxc = max(filtcurr);
    minc = min(filtcurr);
    stdev = std(filtcurr(1:100));	
    bsln = median(filtcurr(1:100));
    if (maxc - minc) < 10 % No cip found.
                          %		sprintf('0 cip')
      on = length(current);
      off = length(current);
      ciptype = 0;
    elseif (maxc - bsln) > (bsln - minc)	% is +cip trace
                                                %		sprintf('+ cip')
      tmp = find(filtcurr > (bsln + 0.5*(maxc - minc)));
      ciptype = 1;
    else	% is -cip trace
                %		sprintf('- cip')
      tmp = find(filtcurr < (bsln - 0.5*(maxc - minc)));
      ciptype = -1;
    end
    
    % extract pulse start & end times (to nearest 10 msec)
    if ciptype ~= 0
      on = 1 + windowsize + floor(tmp(1)*(dt*1000/10)) / (dt*1000/10);
      off = ceil(tmp(length(tmp))*(dt*1000/10)) / (dt*1000/10);
    end
    
    % diagnostics
    %	sprintf('maxc: %g, minc: %g, stdev: %g, bsln: %g', maxc, minc, stdev, bsln)
    %	sprintf('ciptype: %d, on: %g, off: %g', ciptype,  on, off)
    if on > 1 & on < 10001
      warning('Unexpected pulse start time.');
      sprintf('ciptype: %d, on: %g, off: %g', ciptype,  on, off)
    elseif off > 20000 & off < 30000
      warning('Unexpected pulse end time.');
      sprintf('ciptype: %d, on: %g, off: %g', ciptype,  on, off)
    end
    %	figure(hfig); plot(filtcurr, '-green'); hold on;
    %	figure; plot(current, '-blue'); hold on; plot(filtcurr, '-green');
    
    if ciptype == 0
      bias = round(median(current));
      pulse = 0;
    else
      bias=round(median(current(1:on-10)));
      %# If we don't round here, it may be more accurate -CG
      pulse = round(maxc-minc) * ciptype;
      %    	pulse = round(median(current(on+10:off-10)) - bias);
      %		sprintf('raw pulse: %g', pulse)
      tvec = sort([cipList, pulse]);
      pulseidx = find(tvec == pulse);
      if length(pulseidx) > 1
        pulse = tvec(pulseidx(1));
      elseif pulseidx == 1
        pulse = tvec(2);
      elseif pulseidx == length(tvec)
        pulse = tvec(pulseidx - 1);
      elseif abs(tvec(pulseidx + 1) - pulse) > abs(pulse - tvec(pulseidx - 1))
        pulse = tvec(pulseidx - 1);
      else
        pulse = tvec(pulseidx + 1);
      end
    end
    %	sprintf('max - min: %g', (maxc - minc))
    %	sprintf('on: %g, off: %g, bias: %g, pulse: %g', on, off, bias, pulse)
    finish = length(current);
  end
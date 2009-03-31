function [spikeTime, spikePeak, n] = findspikes(traces, fs, thres, varargin)
% 
% FINDSPIKES: This function performs spike discrimination on 
% single tips exceeding or within a threshold and/or time window range.
%
% Syntax:
%
%  spikeTime = findspikes(traces, fs, threshold)
%  [spikeTime spikePeak n] = findspikes(traces, fs, threshold [,direction] [,win_range] [,'plot'])
% 
% Description:
%
%  traces   : Multiple traces of signal. each trace in a column
%  fs       : Sampling frequency, in KHz
%  threshold: Either a scalar, or [thres1 thres2] to define a range
%  direction: Optional. 
%             A positive number to find positive-going spikes, and vice versa. 
%             The default value is +1 when threshold is a scalar,
%             is sign(thres2-thres1) when threshold is a vector.
%  win_range: Optional. 
%             [win_min win_max] to define a time window range of the width at threshold. in ms.
%  'plot'   : Optional. Plot the result. Not to plot by default.
%  (optional parameters: direction, win_range and 'plot' can be in any order)
%
%  spikeTime: Returns a cell array, each cell is a vector of spike times in each trial.
%  spikePeak: Returns the peak values of each spikes.
%  n        : the total number of spikes
% 
% Samples:
%
%  spikeTime=findspikes(signal, 10, 0.25);
%  spikeTime=findspikes(signal, 10, 0.25, 'plot');
%  spikeTime=findspikes(signal, 10, [-0.2 -0.5]);
%  spikeTime=findspikes(signal, 10, [-0.5 -0.2], -1);
%  spikeTime=findspikes(signal, 10, [-0.2 -0.3], [0.1 2], 'plot');
%
% Author: Li, Su based on the original of Alfonso Delagado-Reyes

% Copyright (c) 2007 Cengiz Gunay <cengique@users.sf.net>; Li, Su.
% This work is licensed under the Academic Free License ("AFL")
% v. 3.0. To view a copy of this license, please look at the COPYING
% file distributed with this software or visit
% http://opensource.org/licenses/afl-3.0.php.

% assign the arguments========================
error(nargchk(3,6,nargin))

for k=1:nargin-3
    if ischar(varargin{k})
        plotit=varargin{k};
    elseif isnumeric(varargin{k})
        if length(varargin{k})==1
            direction=varargin{k};
        else
            win_range=varargin{k};
        end
    else
        error('error')
    end
end

if ~exist('plotit', 'var')
    plotit = '';
end

if ~exist('direction', 'var')
    if length(thres)==1
        direction = 1;
    else
        direction=thres(2)-thres(1);
    end
end

direction=sign(direction); 
if direction==0
    error('threshold range or direction is zero')
end

% start to find spikes ===========================
thres = thres*direction;
thresh_min=min(thres);
n = 0;

for idx = 1:size(traces,2)

    trace = traces(:,idx);

    % flip the trace and threshold up-side-down to find the down-pointing spikes.
    trace = trace*direction;

    left_edges = find(trace(1:end-1) < thresh_min & trace(2:end) >= thresh_min);  % find rising slopes across the threshold
    right_edges = find(trace(1:end-1) >= thresh_min & trace(2:end) < thresh_min);  % find falling slopes across the threshold
    timeidx=[]; tips=[]; spike_num=0;
    
    not_empty=(~isempty(left_edges) && ~isempty(right_edges));
    while not_empty
        if right_edges(1) < left_edges(1)    % match the left and right edges of each window.
            right_edges(1)=[];
        end
        spike_num=min(length(left_edges), length(right_edges));
        if spike_num==0; break; end
        left_edges=left_edges(1:spike_num);
        right_edges=right_edges(1:spike_num);

        % eliminate the time windows out of the range.
        if exist('win_range', 'var')
            data_range=win_range.*fs;
            left_time=left_edges + (thresh_min - trace(left_edges)) ./ (trace(left_edges+1) - trace(left_edges));
            right_time=right_edges + (thresh_min - trace(right_edges)) ./ (trace(right_edges+1) - trace(right_edges));
            win_width=right_time-left_time;
            out_of_data_range_idx=find(win_width < data_range(1) | win_width > data_range(2));
            left_edges(out_of_data_range_idx)=[];
            right_edges(out_of_data_range_idx)=[];                
            spike_num=min(length(left_edges), length(right_edges));
        end
        if spike_num==0; break; end

        % merge the neighbor windows too close to each other.
        refractory=1;
        interval=left_edges(2:end)-right_edges(1:end-1);
        smallInterval=find(interval < refractory*fs);
        count=0; realSmallInterval=[];
        for k=1:length(smallInterval)
            avg=mean(trace);
            if min(trace(right_edges(smallInterval(k)):left_edges(smallInterval(k)+1)))>avg+(thresh_min-avg)*0.5
                count=count+1;
                realSmallInterval(count)=smallInterval(k);
            end
        end
        right_edges(realSmallInterval)=[];
        left_edges(realSmallInterval+1)=[];
        spike_num=min(length(left_edges), length(right_edges));
        if spike_num==0; break; end

        timeidx=zeros(spike_num,1); tips=zeros(spike_num,1);

        [tips timeidx]=arrayfun(@(x,y)max(trace(x:y)),left_edges,right_edges);
        timeidx=timeidx+left_edges-1;

        % eliminate the spikes exceed the max threshold.
        if length(thres)>1 
            bigSpikes=find(tips>max(thres));
            tips(bigSpikes)=[];
            timeidx(bigSpikes)=[];
        end
        spike_num=length(timeidx);

%         % eliminate small intervals.
%         interval=diff(timeidx)/fs;
%         smallInterval=find(interval<1);
%         rmlist=[];
%         for k=1:length(smallInterval)
%             if min(trace(timeidx(smallInterval(k)):timeidx(smallInterval(k)+1)))>thresh_min/2
%                 rmlist(end+1)=smallInterval(k);
%                 if tips(rmlist(end))>tips(rmlist(end)+1)
%                     rmlist(end)=rmlist(end)+1;
%                 end
%             end
%         end
%         tips(rmlist)=[];
%         timeidx(rmlist)=[];
        tips=tips*direction;
        not_empty=false;
    end

    if min(size(traces)) == 1
        spikeTime = timeidx/fs;
        spikePeak = tips;
    else
        spikeTime{idx} = timeidx/fs;
        spikePeak{idx} = tips;
    end
    n = n+spike_num;
end

% flip the traces back.
thres=thres*direction;
trace=trace*direction;

if isequal(plotit, 'plot') || nargout==0
    m_time = [1:size(trace,1)]'/(fs);
    plot(m_time,trace,'k'); hold on
    for I=1:length(thres)
        plot([0 m_time(end)],[thres(I) thres(I)],'b');
    end
    plot(timeidx/fs, tips, 'ro'); 
    hold off
    ylabel('V/uV')
    xlabel('t/ms')
    zoom on
end

function syllables = findSyllables(t, props)

% findSyllables: Separate the song into syllables and return each as a
% songify object, collected in a cell array
%
% Usage: syls = findSyllables(obj, props)
%
% Properties:
%   threshold: threshold for automatic

% Is there a better way to do this? Maybe Cengiz knows a good way

% Apply a highpass filter
lpFilt = designfilt('highpassfir','PassbandFrequency',0.25, ...
         'StopbandFrequency',0.15,'PassbandRipple',0.5, ...
         'StopbandAttenuation',65,'DesignMethod','kaiserwin');

figure;
     
smoothed_data = smooth(abs(filter(lpFilt, t.data)), 10);

plot(smoothed_data);
hold on;

% Find where the smoothed data crosses a particular threshold
window_size = 1000;
step_size = 100;

% Take transpose if the data is a column vector
if size(smoothed_data, 2) == 1
    smoothed_data = smoothed_data';
end

threshold = 1000;
min_dur = 1;       % Minimum duration of syllables, in milliseconds
min_gap = 4;        % Minimum gap between syllables, in milliseconds

i = 1;

while i < length(smoothed_data)

    i = find(smoothed_data(i:end) > threshold, 1) + i;
    
    if i
        plot([i, i], [0, 8000], 'k');
    end
    
    % Increment i by min_dur
    i = i + min_dur / (1000 * t.dt);
    
    i = find(smoothed_data(i:end) < threshold, 1) + i;
    
    if i
        plot([i, i], [0, 8000], 'k');
    end
    
    % Increment i by min_gap
    i = i + min_gap / (1000 * t.dt);
end

end


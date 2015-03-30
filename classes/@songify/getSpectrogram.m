function s = getSpectrogram(s, window, overlap, nfft)

% Update the object's spectrogram

if isempty(s.data)
    sgram.data = [];
    sgram.freqrange = [0, 0];
    sgram.timerange = [0, 0];
    s.sgram = sgram;
end

if nargin == 1
    % Default values
    datasize = numel(s.data);
    nsamples = 2000;                        % Number of time samples
    N = 512;                                % Size of time bin
    diff = round((datasize-N)/nsamples);    % Difference required to get "nsamples" samples
    sigma = 10;                             % Sigma value used for gaussian window function
    window = gausswin(N, sigma);            % Gaussian window function
end

[sgram, freqs, times] = spectrogram(s.data, window, overlap, nfft, 1 / s.dt);

sgram_info.data = sgram;
sgram_info.freqrange = [freqs(1), freqs(end)];
sgram_info.timerange = [times(1), times(end)];

s.sgram = sgram_info;

end


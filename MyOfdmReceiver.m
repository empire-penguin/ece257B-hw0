
function [decoded_data]= MyOfdmReceiver(data);

%% run transmitter code to load sts and lts and other parameters
OFDM_TX;

%% Rx processing params
should_plot = false;
rx_data = data;          % run OFDM tx code to get raw_rx_dec
LTS_CORR_THRESH = 0.8;         % Normalized threshold for LTS correlation
% Usage: Find all peaks whose magnitude is greater than 0.8 times
% the maximum magnitude after cross correlation (Packet Detection)

% Repeat the following code for each packet

%% Packet Detection

% ideas: Cross correlation of received signal with LTS or use STS to detect the packet?

length_samples= length(rx_data) - 200;
sample=16;

while(sample < length_samples)

    output(sample)= rx_data(sample-length(sts_t) + (1:length(sts_t))) * rx_data(sample + (1:length(sts_t)))' ./ norm(rx_data(sample+(1:length(sts_t))));

    sample= sample+1;

end
output= output./max(abs(output));

while(sample< length_samples)
    % sts correlation

    output(sample) = (rx_data(sample-length(sts_t)+(1:length(sts_t)))* rx_data(sample+(1:length(sts_t)))')./rms(rx_data(sample+(1:length(sts_t))));

    sample= sample+1;
end

output= output./max(abs(output));

figure;
plot((abs(output)));
hold on
plot(abs(rx_data));
hold off

% Output: Single packet extracted from rx_data
% with knowledge of preamble (LTS) indices and payload vector indices

%% CFO estimation and correction
% Use two copies of LTS for cross-correlation (Reference: Thesis)

% Output: Packet with each value multiplied by CFO correction factor

%% CP Removal
% Refer to the process used to add CP at TX
% Converting vector back to matrix form will help

% Output: CP free payload matrix of size (N_SC * N_OFDM_SYMS)

%% FFT
% Refer to IFFT perfomed at TX

% Output: Symbol matrix in frequency domain of same size

%% Channel estimation and correction
% Use the two copies of LTS and find channel estimate (Reference: Thesis)
% Convert channel estimate to matrix form and equlaize the above matrix

% Output : Symbol equalized matrix in frequency domain of same size

%% Advanced topics:
%% SFO estimation and correction using pilots
% SFO manifests as a frequency-dependent phase whose slope increases
% over time as the Tx and Rx sample streams drift apart from one
% another. To correct for this effect, we calculate this phase slope at
% each OFDM symbol using the pilot tones and use this slope to
% interpolate a phase correction for each data-bearing subcarrier.

% Output: Symbol equalized matrix with pilot phase correction applied

%% Phase Error Correction using pilots
% Extract the pilots and calculate per-symbol phase error

% Output: Symbol equalized matrix with pilot phase correction applied
% Remove pilots and flatten the matrix to a vector rx_syms

%% Demodulation
if (should_plot)
    figure(4);
    scatter(real(rx_syms), imag(rx_syms),'filled');
    title(' Signal Space of received bits');
    xlabel('I'); ylabel('Q');
end

% FEC decoder
% Demap_out = demapper(rx_syms,MOD_ORDER,1);

% viterbi decoder
% decoded_data = vitdec(Demap_out,trel,7,'trunc','hard');

decoded_data = [];

% decoded_data is the final output corresponding to tx_data, which can be used
% to calculate BER


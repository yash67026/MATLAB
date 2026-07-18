%% Massive MIMO Simulation - Corrected Version
clc; clear; close all;

%% Parameters
M = 64;              % Number of BS antennas
K = 8;               % Number of users
numBits = 1e4;       % Number of bits per user
SNR_dB = 0:5:30;     % SNR range in dB
modOrder = 4;        % QPSK modulation

%% Generate random bits for each user
bits = randi([0 modOrder-1], K, numBits);

%% QPSK Modulation
txSymbols = pskmod(bits, modOrder, pi/modOrder); % K x numBits

%% Initialize BER and sum-rate
BER_MRT = zeros(length(SNR_dB),1);
BER_ZF  = zeros(length(SNR_dB),1);
sumRate_MRT = zeros(length(SNR_dB),1);
sumRate_ZF  = zeros(length(SNR_dB),1);

%% Main simulation
for snrIdx = 1:length(SNR_dB)
    snr = 10^(SNR_dB(snrIdx)/10);
    
    % Generate Rayleigh channel (M x K)
    H = (randn(M,K) + 1j*randn(M,K))/sqrt(2);
    
    %% MRT Precoding
    W_MRT = H;                  % MRT: use H
    W_MRT = W_MRT ./ vecnorm(W_MRT); % normalize each column
    
    %% ZF Precoding
    W_ZF = H * inv(H'*H);       % ZF precoding
    W_ZF = W_ZF ./ vecnorm(W_ZF); % normalize each column
    
    %% Generate noise (K x numBits)
    noise_MRT = (randn(K,numBits) + 1j*randn(K,numBits))/sqrt(2);
    noise_ZF  = (randn(K,numBits) + 1j*randn(K,numBits))/sqrt(2);
    
    %% Received signal
    y_MRT = H' * W_MRT * txSymbols + noise_MRT / sqrt(snr);
    y_ZF  = H' * W_ZF  * txSymbols + noise_ZF  / sqrt(snr);
    
    %% Demodulate
    rxBits_MRT = pskdemod(y_MRT, modOrder, pi/modOrder);
    rxBits_ZF  = pskdemod(y_ZF, modOrder, pi/modOrder);
    
    %% BER calculation
    BER_MRT(snrIdx) = sum(sum(rxBits_MRT ~= bits)) / (K*numBits);
    BER_ZF(snrIdx)  = sum(sum(rxBits_ZF  ~= bits)) / (K*numBits);
    
    %% Sum-rate calculation
    R_MRT = zeros(K,1);
    R_ZF  = zeros(K,1);
    for k = 1:K
        interference_MRT = sum(abs(H(:,k)'*W_MRT).^2) - abs(H(:,k)'*W_MRT(:,k))^2;
        interference_ZF  = sum(abs(H(:,k)'*W_ZF).^2)  - abs(H(:,k)'*W_ZF(:,k))^2;
        R_MRT(k) = log2(1 + abs(H(:,k)'*W_MRT(:,k))^2 / (interference_MRT + 1/snr));
        R_ZF(k)  = log2(1 + abs(H(:,k)'*W_ZF(:,k))^2  / (interference_ZF + 1/snr));
    end
    sumRate_MRT(snrIdx) = sum(R_MRT);
    sumRate_ZF(snrIdx)  = sum(R_ZF);
end

%% Plot BER
figure;
semilogy(SNR_dB, BER_MRT,'-o','LineWidth',2); hold on;
semilogy(SNR_dB, BER_ZF,'-s','LineWidth',2);
grid on;
xlabel('SNR (dB)'); ylabel('BER');
title('BER vs SNR for Massive MIMO');
legend('MRT','ZF');

%% Plot Sum-rate
figure;
plot(SNR_dB, sumRate_MRT,'-o','LineWidth',2); hold on;
plot(SNR_dB, sumRate_ZF,'-s','LineWidth',2);
grid on;
xlabel('SNR (dB)'); ylabel('Sum-Rate (bits/s/Hz)');
title('Sum-rate vs SNR for Massive MIMO');
legend('MRT','ZF');

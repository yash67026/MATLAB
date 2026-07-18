clc; clear; close all;

%% Parameters
M = 8;                     % Number of sensors
theta = [20 40];           % True DOAs (degrees)
K = length(theta);         % Number of sources
snapshots = 200;
SNR = 10;                  % dB
d = 0.5;                   % Inter-element spacing (λ/2)
lambda = 1;
k = 2*pi/lambda;

%% Signal model
A = exp(-1j*k*d*(0:M-1).' * sind(theta));
S = randn(K, snapshots) + 1j*randn(K, snapshots);
X = awgn(A*S, SNR, 'measured');

%% Covariance matrix
R = (X*X')/snapshots;

%% Eigen-decomposition
[V, D] = eig(R);
[~, idx] = sort(diag(D), 'descend');
En = V(:, idx(K+1:end));   % Noise subspace

%% MUSIC Spectrum
angles = -90:0.1:90;
Pmusic = zeros(size(angles));

for i = 1:length(angles)
    a = exp(-1j*k*d*(0:M-1).' * sind(angles(i)));
    Pmusic(i) = 1 / (a'*(En*En')*a);
end

Pmusic_dB = 10*log10(abs(Pmusic)/max(abs(Pmusic)));

%% Plot
figure;
plot(angles, Pmusic_dB, 'LineWidth', 2);
grid on;
xlabel('Angle (degrees)');
ylabel('MUSIC Spectrum (dB)');
title('MUSIC DOA Spectrum');

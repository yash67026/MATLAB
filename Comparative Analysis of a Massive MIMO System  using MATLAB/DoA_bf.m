clc; clear; close all;

%% Parameters
M = 8;                      % Number of antenna elements
theta_true = [20 40];       % True DOAs (degrees)
K = length(theta_true);
snapshots = 200;
SNR = 10;                   % dB
d = 0.5;                    % λ/2 spacing
lambda = 1;
k = 2*pi/lambda;

%% Signal model
A = exp(-1j*k*d*(0:M-1).' * sind(theta_true));
S = randn(K, snapshots) + 1j*randn(K, snapshots);
X = awgn(A*S, SNR, 'measured');

%% Covariance matrix
R = (X*X')/snapshots;

%% Eigen-decomposition
[V, D] = eig(R);
[~, idx] = sort(diag(D), 'descend');
En = V(:, idx(K+1:end));    % Noise subspace

%% Angle grid (Azimuth & Elevation)
az = -90:2:90;              % Azimuth
el = -90:2:90;              % Elevation

P = zeros(length(el), length(az));

%% 3D MUSIC spectrum computation
for i = 1:length(el)
    for j = 1:length(az)
        a = exp(-1j*k*d*(0:M-1).' * ...
            (sind(az(j))*cosd(el(i))));
        P(i,j) = 1 / abs(a'*(En*En')*a);
    end
end

P_dB = 10*log10(P / max(P(:)));

%% Plot 3D Beamforming Spectrum
figure;
surf(az, el, P_dB, 'EdgeColor', 'none');
xlabel('Azimuth Angle (degrees)');
ylabel('Elevation Angle (degrees)');
zlabel('Spatial Spectrum (dB)');
title('3D MUSIC DOA Beamforming Spectrum');
colorbar;
view(45,35);
grid on;

clc; clear; close all;

%% PARAMETERS
M = 16;                     % Number of antennas
theta = [20 40];            % True DOAs (degrees)
K = length(theta);          % Number of sources
snapshots = 200;            % Snapshots
SNR_dB = 10;                % SNR (fixed for DOA plot)

lambda = 1;
d = lambda/2;
k = 2*pi/lambda;

%% SIGNAL MODEL
A = exp(-1j*k*d*(0:M-1).' * sind(theta));     % Steering matrix
S = randn(K,snapshots) + 1j*randn(K,snapshots);
X = A*S;
X = awgn(X, SNR_dB, 'measured');

%% COVARIANCE MATRIX
R = (X*X')/snapshots;

%% EIGEN-DECOMPOSITION
[V,D] = eig(R);
[~,idx] = sort(diag(D),'descend');
Es = V(:,idx(1:K));          % Signal subspace

%% ESPRIT ALGORITHM
Es1 = Es(1:end-1,:);
Es2 = Es(2:end,:);
Phi = pinv(Es1)*Es2;

psi = angle(eig(Phi));

% ---- Correct inversion & ambiguity handling ----
arg = real(psi/pi);          % Normalized phase
arg = max(min(arg,1),-1);    % Numerical safety
est_theta = sort(abs(asind(arg)));   % Final DOA estimates

%% DOA PLOT (PAPER READY)
figure; hold on;

% Estimated DOAs
stem(est_theta, ones(size(est_theta)), ...
    'r','LineWidth',2,'Marker','o');

% True DOAs
for i = 1:length(theta)
    xline(theta(i),'k--','LineWidth',2);
end

xlabel('Angle (degrees)');
ylabel('Normalized Amplitude');
title('ESPRIT DOA Estimation');
legend('Estimated DOAs','True DOAs','Location','northeast');
grid on;
ylim([0 1.05]);

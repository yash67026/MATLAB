clc; clear; close all;

%% ---------------- PARAMETERS ----------------
M = 16;                      % Number of antennas
theta = [20 40];             % True DOAs (degrees)
K = length(theta);           % Number of sources
snapshots_vec = [5 10 20 40 80 150 300];  % Snapshot sweep
SNR = -5;                    % Fixed low SNR (important!)
MC = 200;                    % Monte Carlo runs

lambda = 1;
d = lambda/2;
k = 2*pi/lambda;

rmse_music = zeros(length(snapshots_vec),1);

%% ---------------- MAIN LOOP ----------------
for s = 1:length(snapshots_vec)
    snapshots = snapshots_vec(s);
    rmse_mc = zeros(MC,1);

    for mc = 1:MC

        % ----- Steering matrix -----
        A = exp(-1j*k*d*(0:M-1).' * sind(theta));

        % ----- Signal + noise -----
        S = (randn(K,snapshots) + 1j*randn(K,snapshots))/sqrt(2);
        X = A*S;
        X = awgn(X, SNR, 'measured');

        % ----- Covariance matrix -----
        R = (X*X')/snapshots;

        % ----- Eigen-decomposition -----
        [V,D] = eig(R);
        [~,idx] = sort(diag(D),'descend');
        En = V(:,idx(K+1:end));   % Noise subspace

        % ----- MUSIC spectrum -----
        ang = -90:0.2:90;
        P = zeros(size(ang));
        for i = 1:length(ang)
            a = exp(-1j*k*d*(0:M-1).' * sind(ang(i)));
            P(i) = 1/(a'*(En*En')*a);
        end

        % ----- DOA estimation -----
        [~,loc] = findpeaks(abs(P), ang, ...
            'SortStr','descend','NPeaks',K);
        est_theta = sort(loc);

        % ----- CORRECT RMSE (nearest neighbor) -----
        err = zeros(K,1);
        for m = 1:K
            err(m) = min(abs(est_theta - theta(m)));
        end
        rmse_mc(mc) = sqrt(mean(err.^2));
    end

    rmse_music(s) = mean(rmse_mc);
end

%% ---------------- PLOT ----------------
figure;
plot(snapshots_vec, rmse_music,'-o','LineWidth',2);
grid on;
xlabel('Number of Snapshots');
ylabel('RMSE (degrees)');
title('MUSIC RMSE vs Number of Snapshots');
set(gca,'FontSize',12);

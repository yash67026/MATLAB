clc; clear; close all;

%% PARAMETERS
M = 8;                          % Number of sensors
theta = [-20 30];               % True DOAs (degrees)
K = length(theta);              % Number of sources
snapshots = 100;                % Snapshots
SNR_dB = -10:5:20;              % SNR range
MC = 200;                       % Monte Carlo runs

lambda = 1;
d = lambda/2;
k = 2*pi/lambda;

rmse_music  = zeros(size(SNR_dB));
rmse_esprit = zeros(size(SNR_dB));

%% MAIN LOOP
for s = 1:length(SNR_dB)
    snr = SNR_dB(s);
    err_music  = 0;
    err_esprit = 0;

    for mc = 1:MC
        %% Signal model
        A = exp(-1j*k*d*(0:M-1)'*sind(theta));
        S = (randn(K,snapshots)+1j*randn(K,snapshots))/sqrt(2);
        X = A*S;
        X = awgn(X,snr,'measured');

        %% Covariance
        R = (X*X')/snapshots;

        %% Eigen-decomposition
        [V,D] = eig(R);
        [~,idx] = sort(diag(D),'descend');
        Es = V(:,idx(1:K));
        En = V(:,idx(K+1:end));

        %% -------- MUSIC --------
        ang = -90:0.5:90;
        P = zeros(size(ang));

        for i = 1:length(ang)
            a = exp(-1j*k*d*(0:M-1)'*sind(ang(i)));
            P(i) = 1/(a'*En*En'*a);
        end

        [~,locs] = findpeaks(real(P),ang,'SortStr','descend','NPeaks',K);
        est_music = sort(locs);

        err_music = err_music + mean((est_music - theta).^2);

        %% -------- ESPRIT --------
        Es1 = Es(1:end-1,:);
        Es2 = Es(2:end,:);
        Phi = pinv(Es1)*Es2;
        psi = angle(eig(Phi));

        est_esprit = sort(asind(psi/(k*d)));

        err_esprit = err_esprit + mean((est_esprit(:) - theta(:)).^2);
    end

    rmse_music(s)  = sqrt(err_music/MC);
    rmse_esprit(s) = sqrt(err_esprit/MC);
end

%% PLOT
figure;
plot(SNR_dB,rmse_music,'-o','LineWidth',2); hold on;
plot(SNR_dB,rmse_esprit,'-s','LineWidth',2);
grid on;
xlabel('SNR (dB)');
ylabel('RMSE (degrees)');
legend('MUSIC','ESPRIT','Location','northeast');
title('RMSE vs SNR Comparison of MUSIC and ESPRIT');

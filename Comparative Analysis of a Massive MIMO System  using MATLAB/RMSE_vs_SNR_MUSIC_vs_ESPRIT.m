clc; clear; close all;

M = 32;
theta = [20 25];
K = length(theta);
snapshots = 30;
SNR_dB = -10:5:20;
MC = 100;

lambda = 1;
d = lambda/2;
k = 2*pi/lambda;

rmse_music = zeros(size(SNR_dB));

for s = 1:length(SNR_dB)
    snr = SNR_dB(s);
    sq_err = 0;
    success = 0;

    for mc = 1:MC
        A = exp(-1j*k*d*(0:M-1)'*sind(theta));
        S = randn(K,snapshots) + 1j*randn(K,snapshots);
        X = awgn(A*S, snr,'measured');

        R = (X*X')/snapshots;
        [V,D] = eig(R);
        [~,idx] = sort(diag(D),'descend');
        En = V(:,idx(K+1:end));

        ang = -90:1:90;
        Pm = zeros(size(ang));
        for i = 1:length(ang)
            a = exp(-1j*k*d*(0:M-1)'*sind(ang(i)));
            Pm(i) = 1/real(a'*(En*En')*a);
        end

        [pks,loc] = findpeaks(Pm,ang,'SortStr','descend');

        if length(loc) >= K
            est = sort(loc(1:K));
            sq_err = sq_err + mean((est(:)-theta(:)).^2);
            success = success + 1;
        end
    end

    rmse_music(s) = sqrt(sq_err / max(success,1));
end

figure;
plot(SNR_dB,rmse_music,'-o','LineWidth',2);
grid on;
xlabel('SNR (dB)');
ylabel('RMSE (degrees)');
title('RMSE vs SNR for MUSIC');

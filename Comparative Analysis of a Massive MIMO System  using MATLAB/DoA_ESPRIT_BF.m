%% 3D Beamforming using ESPRIT-estimated DOAs

az = -90:2:90;
el = -90:2:90;
P_esprit = zeros(length(el), length(az));

for i = 1:length(el)
    for j = 1:length(az)
        a = exp(-1j*k*d*(0:M-1).' * ...
            (sind(az(j))*cosd(el(i))));
        
        % Projection on ESPRIT signal subspace
        P_esprit(i,j) = abs(a'*(Es*Es')*a);
    end
end

P_esprit_dB = 10*log10(P_esprit/max(P_esprit(:)));

%% Plot
figure;
surf(az, el, P_esprit_dB,'EdgeColor','none');
xlabel('Azimuth Angle (degrees)');
ylabel('Elevation Angle (degrees)');
zlabel('Beam Response (dB)');
title('3D ESPRIT-Based Beamforming Response');
colorbar;
view(45,35);
grid on;

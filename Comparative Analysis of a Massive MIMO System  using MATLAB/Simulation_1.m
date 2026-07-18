clc;
clear;
close all;

%% Parameters
N = 4;               % Number of antenna elements (linear array)
d = 0.5;             % Element spacing in wavelengths

% Angular grid (azimuth phi, elevation theta)
phi = linspace(-180, 180, 360);   % azimuth (deg)
theta = linspace(0, 180, 180);    % elevation (deg)

[Phi, Theta] = meshgrid(phi, theta);

% Convert angles to radians for calculations
Phi_rad = deg2rad(Phi);
Theta_rad = deg2rad(Theta);

% Steering angle (desired beam direction) in degrees
% For 1D array along x-axis, beamforming varies with azimuth (phi)
steer_phi = 30; % steer beam to 30 degrees azimuth
steer_theta = 90; % elevation fixed at 90 degrees (horizontal plane)

% Convert to radians
steer_phi_rad = deg2rad(steer_phi);
steer_theta_rad = deg2rad(steer_theta);

% Calculate array factor for each (theta, phi)
% For linear array along x-axis:
% AF = sum_n=0^(N-1) w_n * exp(j*2*pi*d*n*sin(theta)*cos(phi))
n = 0:N-1; % element indices

% Calculate steering weights (beam steering)
w = exp(1j*2*pi*d*n*sin(steer_theta_rad)*cos(steer_phi_rad));

% Calculate array factor over grid
AF = zeros(size(Phi));
for idx = 1:numel(Phi)
    steering_vector = exp(-1j*2*pi*d*n*sin(Theta_rad(idx))*cos(Phi_rad(idx)));
    AF(idx) = w * steering_vector.';
end

% Normalize AF magnitude
AF_mag = abs(AF);
AF_mag = AF_mag / max(AF_mag(:));

% Convert spherical to Cartesian coordinates for plotting
X = AF_mag .* sin(Theta_rad) .* cos(Phi_rad);
Y = AF_mag .* sin(Theta_rad) .* sin(Phi_rad);
Z = AF_mag .* cos(Theta_rad);

%% Plot 3D beamforming pattern

figure;
surf(X, Y, Z, AF_mag, 'EdgeColor', 'none');
colormap jet;
colorbar;
title('3D Beamforming Pattern of 1x4 Patch Array Antenna');
xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal;
view(45, 30);
grid on;
camlight headlight;
lighting gouraud;

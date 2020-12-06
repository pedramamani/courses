%% Harmonic oscillator
clear, clc, hold on, grid on;
tRange = [0, 3 * pi];
[ts6, ~, ~] = timeGrid(tRange, 6);
[ts7, ~, ~] = timeGrid(tRange, 7);
[ts8, ~, ~] = timeGrid(tRange, 8);

f = @(t, y) [y(2); -y(1)];
y0 = [0; 1];

[~, ys6] = rk4(f, ts6, y0);
[~, ys7] = rk4(f, ts7, y0);
[~, ys8] = rk4(f, ts8, y0);

dx67 = ys6(1, :) - ys7(1, 1: 2: end);
dx78 = ys7(1, 1: 2: end) - ys8(1, 1: 4: end);

plot(ts6, dx67, 'r');
plot(ts6, 2 ^ 4 * dx78, '-.b');
xlim(tRange);
xlabel('Time');
ylabel('Scaled \Deltax between adjacent levels');
legend('\Deltax_{6,7}', '16 \Deltax_{7,8}');

%% Van der Pol oscillator
clear, clc, hold on, grid on;
tRange = [0, 100];
[ts, ~, ~] = timeGrid(tRange, 12);

f = @(t, y) [y(2); -5 * (y(1) ^ 2 - 1) * y(2) - y(1)];
y0 = [1; -6];
[~, ys] = rk4(f, ts, y0);

figure(1);
plot(ts, ys(1, :), 'k');
xlim(tRange);
xlabel('Time');
ylabel('Position');

figure(2);
plot(ys(1, :), ys(2, :), '.k');
xlabel('Position');
ylabel('Momentum');

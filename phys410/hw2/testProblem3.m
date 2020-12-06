%% Harmonic oscillator
clear, clc, hold on, grid on;
tspan = linspace(0, 3 * pi, 65);

f = @(t, y) [y(2); -y(1)];
y0 = [0; 1];
rtols = [1E-5, 1E-7, 1E-9, 1E-11];

for rtol = rtols
    [ts, ys, yErrors] = rk4Ad(f, tspan, y0, rtol);
    semilogy(ts, abs(yErrors(1, :)));
    xlim([min(ts), max(ts)]);
    xlabel('Time');
    ylabel('|error in position|');
end
legend('rtol = 1E-5', 'rtol = 1E-7', 'rtol = 1E-9', 'rtol = 1E-11');
set(gca, 'YScale', 'log');

%% Van der Pol oscillator
clear, clc, hold on, grid on;
tspan = linspace(0, 100, 4097);
rtol = 1E-10;

f = @(t, y) [y(2); -5 * (y(1) ^ 2 - 1) * y(2) - y(1)];
y0 = [1; -6];
[ts, ys, yErrors] = rk4Ad(f, tspan, y0, rtol);

figure(1);
plot(ts, ys(1, :), 'k');
plot(ts, yErrors(1, :) * 5E9, 'r');
xlabel('Time');
ylabel('Position');
legend('Value', 'Error * 5E9')

figure(2);
plot(ys(1, :), ys(2, :), '.k');
xlabel('Position');
ylabel('Momentum');

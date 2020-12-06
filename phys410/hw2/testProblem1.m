clear, clc, hold on, grid on;
tRange = [0, 2 * pi];
[ts6, dt6, nt6] = timeGrid(tRange, 6);
[ts7, dt7, nt7] = timeGrid(tRange, 7);

f = @(t, y) cos(t);
ys6 = zeros(size(ts6));
ys7 = zeros(size(ts7));

for i = 1: nt6 - 1
    ys6(i + 1) = rk4Step(f, ts6(i), dt6, ys6(i));
end
for i = 1: nt7 - 1
    ys7(i + 1) = rk4Step(f, ts7(i), dt7, ys7(i));
end

solution = sin(ts6);
error6 = ys6 - solution;
error7 = ys7(1:2:end) - solution;

plot(ts6, error6, 'r');
plot(ts6, 2 ^ 4 * error7, '-.b');
xlim(tRange)
xlabel('Time');
ylabel('Scaled true errors');
legend('e_6', '16 e_7');

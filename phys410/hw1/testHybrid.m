clear, clc
format long, format compact

f = @(x) 512*x^10 - 5120*x^9 + 21760*x^8 - 51200*x^7 + 72800*x^6 ...
    - 64064*x^5 + 34320*x^4 - 10560*x^3 + 1650*x^2 - 100*x + 1;
dfdx = @(x) 5120*x^9 - 46080*x^8 + 174080*x^7 - 358400*x^6 + 436800*x^5 ...
    - 320320*x^4 + 137280*x^3 - 31680*x^2 + 3300*x - 100;

seps = findSeparators(f, -1E3, 1E3, 0.1);
nroots = length(seps) - 1;  % number of roots found

roots_hybrid = zeros(1, nroots);
roots_fzero = zeros(1, nroots);
for i = 1 : nroots
    roots_hybrid(i) = hybrid(f, dfdx, seps(i), seps(i+1), 5E-3, 1E-12);
    roots_fzero(i) = fzero(f, seps(i:i+1));
end
errors = abs(roots_hybrid - roots_fzero) ./ roots_fzero;

% plot root estimates and relative errors
hold on
axis tight
grid on
x = linspace(seps(1), seps(end), 501);
plot(x, arrayfun(f, x), 'k');
plot(roots_hybrid, zeros(1, nroots), 'sb', 'MarkerSize', 5, 'MarkerFaceColor', 'b');
plot(roots_hybrid, errors * 1E12, '.r-', 'MarkerSize', 10);
legend('Function', 'Root estimates', 'Relative error (1E-12)', 'Location', 'northwest');
hold off
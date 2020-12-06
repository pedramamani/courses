x = linspace(-2*pi, 2*pi, 101);
sinx = sin(x);
cosx = cos(x);
expx = exp(x) / 100;

plot(x, sinx, x, cosx, x, expx)
title('Random Plots')
xlabel('\alpha (radians)')
ylabel('Values')
legend('sin(\alpha)', 'cos(\alpha)', 'exp(\alpha)')

grid on
axis tight
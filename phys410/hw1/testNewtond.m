clear, clc
format long, format compact

f = @(x) [
    x(1)^2 + x(2)^4 + x(3)^6 - 2; ...
    cos(x(1)*x(2)*x(3)^2) - x(1) - x(2) - x(3); ...
    x(2)^2 + x(3)^3 - (x(1) + x(2) - x(3))^2
];

root_newtond = newtond(f, @jacfd, 1E-5, [-1.00; 0.75; 1.50], 1E-12);
root_fsolve = fsolve(f, [-1.00; 0.75; 1.50]);
error = norm(root_newtond - root_fsolve) / norm(root_fsolve);  % relative error of root estimates

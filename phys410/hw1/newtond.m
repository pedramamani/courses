function x = newtond(f, jacfd, h, x0, tol)
%{
Find a root of a d-dimensional nonlinear system using Newton's method.
Inputs
    f: Function which implements the nonlinear system of equations.
        Function is of the form f(x) where x is a length-d vector, and 
        returns length-d column vector.
    jacfd: Function which is of the form jacfd(f, x, h) where f is the above
        function, x is a length-d vector, and h is the finite difference
        parameter. jacfd returns the d x d matrix of approximate Jacobian
        matrix elements.
    h: Finite differencing parameter.
    x0: Initial estimate for iteration (length-d column vector).
    tol: Convergence criterion: routine returns when relative magnitude
        of update from iteration to iteration is <= tol.
Output
    x: Estimate of root (length-d column vector)
%}
niters = 20;  % maximum number of iterations
d = length(x0);
xs = zeros(d, niters + 1);
res = zeros(1, niters);

xs(:, 1) = x0;
xs(:, 2) = x0 - jacfd(f, x0, h) \ f(x0);
res(1) = norm(xs(:, 2) - x0) / norm(xs(:, 2));
i = 2;

while res(i-1) > tol  % not yet converged
    xs(:, i+1) = xs(:, i) - jacfd(f, xs(:, i), h) \ f(xs(:, i));
    if i == niters
        i = i + 1;
        break
    end
    res(i) = norm(xs(:, i+1) - xs(:, i)) / norm(xs(:, i+1));
    i = i + 1;
end
x = xs(:, i);
plotResiduals(res);
end


function plotResiduals(res)
%{
Plot residuals from iteration values.
Input
    res: Residual values of iteration.
%}
axis tight
semilogy(res, '.-k', 'MarkerSize', 10)
xlabel('Iteration Number')
ylabel('Log(Residual)')
grid on
end


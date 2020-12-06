function x = hybrid(f, dfdx, xmin, xmax, tol1, tol2)
%{
Find the root of the function within given interval using a combination of bisection and Newton’s method.
Inputs
    f: Function whose root is sought.
    dfdx: Derivative function.
    xmin: Initial bracket minimum.
    xmax: Initial bracket maximum.
    tol1: Relative convergence criterion for bisection.
    tol2: Relative convergence criterion for Newton iteration.
Output
    x: Estimate of root.
Requires
    One and only one root exists in given interval.
%}
x = bisectSolve(f, xmin, xmax, tol1);
x = newtonSolve(f, dfdx, x, tol2, 14);
end


function x = bisectSolve(f, xmin, xmax, tol)
%{
Find the root of the function within given interval using bisection recursively.
Inputs
    f: Function whose root is sought.
    xmin: Initial bracket minimum.
    xmax: Initial bracket maximum.
    tol: Relative convergence criterion.
Output
    x: Estimate of root.
Requires
    One and only one root exists in given interval.
%}
x = (xmin + xmax) / 2.;

if (xmax - xmin) / (2 * abs(x)) <= tol
    % we have converged
elseif f(x) * f(xmin) < 0
    x = bisectSolve(f, xmin, x, tol);
elseif f(x) * f(xmax) < 0
    x = bisectSolve(f, x, xmax, tol);
end
end


function x = newtonSolve(f, dfdx, x0, tol, niters)
%{
Find a root of the function within given interval using Newton's method.
Inputs
    f: Function whose root is sought.
    dfdx: Derivative function.
    x0: Initial guess for the root.
    tol: Relative convergence criterion.
    niters: Maximum number of iterations.
Output
    x: Estimate of root.
Requires
    The initial guess is a good guess (i.e. close enough to the root).
    The function is well-behaved near its root.
%}
xs = zeros(1, niters + 1);
xs(1) = x0;
xs(2) = x0 - f(x0) / dfdx(x0);
i = 2;

while abs((xs(i) - xs(i-1)) / xs(i)) > tol  % have not converged yet
    xs(i+1) = xs(i) - f(xs(i)) / dfdx(xs(i));
    if i == niters
        i = i + 1;
        break
    end
    i = i + 1;
end
x = xs(i);
end


function J = jacfd(f, x, h)
%{
Find the Jacobian matrix for a d-dimensional system.
Inputs
    f: Function which implements the nonlinear system of equations.
        Function is of the form f(x) where x is a length-d vector, and 
        returns length-d column vector.
    x: Length-d column vector to find Jacobian at.
    h: Finite differencing parameter.
Output:
    J: dxd matrix of approximate Jacobian matrix elements.
%}
d = length(x);
J = zeros(d);

for i = 1:d
    xph = x;
    xph(i) = xph(i) + h;
    J(:, i) = (f(xph) - f(x)) / h;
end
end
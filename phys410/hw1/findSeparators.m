function separators = findSeparators(f, xmin, xmax, dx)
%{
Find a list of x values that separate the roots of the function.
Inputs
    f: Function to find Ranges for.
    xmin: Range lower limit.
    xmax: Range upper limit.
    dx: Minimum root searching step size.
Output
    separators: Ordered list of x values that separate function roots.
Requires
    All roots have a multiplicity of 1.
%}
n = (xmax - xmin) / dx;
x = linspace(xmin, xmax, n+1);
separators = [];

for i = 1:n
    if f(x(i)) * f(x(i+1)) < 0
        separators(end + 1) = x(i);
        xlast = x(i+1);
    end
end
separators(end + 1) = xlast;
end

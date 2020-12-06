function ret = cosTaylor(x, tol, kmax)
ret = 0;
k = 0;
while true
    newTerm = taylorTerm(x, k);
    ret = ret + newTerm;
    if abs(newTerm) < tol || k > kmax
        break;
    end
    k = k + 1;
end
end


function ret = taylorTerm(x, k)
ret = (-1)^k * x^(2*k) / factorial(2*k);
end
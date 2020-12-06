function max = max3(a, b, c)
max = max2(max2(a, b), c);
end

function max = max2(a, b)
if a >= b
    max = a;
elseif a < b
    max = b;
end
end
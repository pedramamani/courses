function xs = randsInRange(range, count)
    xs = (range(2) - range(1)) .* rand(count, 1) + range(1);
end

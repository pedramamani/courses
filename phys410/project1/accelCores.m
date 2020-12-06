function a = accelCores(mc, rc)
    nc = length(mc);
    a = zeros(size(rc));
    for i = 1: nc
        for j = i + 1: nc
            rij = rc(i, :) - rc(j, :);
            fij = rij / norm(rij) ^ 3;
            a(i, :) = a(i, :) - mc(j) * fij;
            a(j, :) = a(j, :) + mc(i) * fij;
        end
    end
end

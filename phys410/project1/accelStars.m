function a = accelStars(mc, rc, rs)
    nc = length(mc);
    a = zeros(size(rs));
    for i = 1: nc
        delta_r = rc(i, :) - rs;
        a = a + mc(i) * delta_r ./ vecnorm(delta_r, 2, 2) .^ 3;
    end
end

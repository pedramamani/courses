function [rc, rs] = iterate(i, rc, rs, mc, dt)
    rc(:, :, i + 1) = 2 * rc(:, :, i)  - rc(:, :, i - 1) + accelCores(mc, rc(:, :, i)) * dt ^ 2;
    rs(:, :, i + 1) = 2 * rs(:, :, i) - rs(:, :, i - 1) + accelStars(mc, rc(:, :, i), rs(:, :, i)) * dt ^ 2;
end

function [t, x] = trackX(rc, rs, mc, tmax, level)
% Track the x position of first star/core for a simulation at given level
    nt = 2 ^ level + 1;
    t = linspace(0, tmax, nt);
    dt = t(2) - t(1);
    x = zeros(1, nt);
    
    if ~isempty(rs)  % track a star if any, otherwise track core
        x(1) = rs(1, 1, 1);
        for i = 2: nt
            x(i) = rs(1, 1, i);
            [rc, rs] = iterate(i, rc, rs, mc, dt);
        end
    else
        x(1) = rc(1, 1, 1);
        for i = 2: nt
            x(i) = rc(1, 1, i);
            [rc, rs] = iterate(i, rc, rs, mc, dt);
        end
    end
end

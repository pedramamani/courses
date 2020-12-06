%% ----- CONFIGURATION OPTIONS -----
clear, clc, clf, hold on;

% ----- PARAMETERS & INITIAL CONDITIONS -----
mc = [1; 1];  % mass of cores
ns = [1000; 1000];  % number of stars for each core

rc0 = [-1, 1, 0; 1, -1, 0];  % initial position of cores
vc0 = [0, -1, 0; 0, 1, 0];  % initial velocity of cores

range_rs = [0.1, 0.8; 0.2, 0.8];  % range of initial star radii for each core
range_thetas = [pi/2, pi/2; pi/2, pi/2];  % range of initial star thetas for each core
range_phis = [0, 2 * pi; 0, 2 * pi];  % range of initial star phis for each core
range_alphas = [pi/2, pi/2; pi/2, pi/2];  % range of initial star alphas for each core

% ----- DISCRETIZATION -----
tmax = 4;
level = 9;

% ----- ANIMATE AND SAVE OPTIONS -----
do_save = true;
trace_cores = true;
delay = 0;
padding = 2;
save_name = 'toomre.avi';

color_cores = [[9, 18, 110] / 255; [173, 3, 3] / 255];
color_stars = ['b'; 'r'];
size_cores = 10 * mc .^ (1 / 3);  % scale core size with its mass
size_stars = 3;

%% ----- SIMULATION CODE -----
% ----- SOME DEFINITIONS FOR EASE -----
nc = length(mc);
nt = 2 ^ level + 1;
t = linspace(0, tmax, nt);
dt = t(2) - t(1);
plot_lims = [-max(rc0, [], 1) - padding; max(rc0, [], 1) + padding]';

% ----- RANDOM SAMPLING OF STAR POSITIONS AND VELOCITIES -----
rs0 = zeros(0, 3);
vs0 = zeros(0, 3);

for i = 1: nc
    rs = randsInRange(range_rs(i, :), ns(i));
    thetas = randsInRange(range_thetas(i, :), ns(i));
    phis = randsInRange(range_phis(i, :), ns(i));
    alphas = randsInRange(range_alphas(i, :), ns(i));

    [x, y, z] = sph2cart(phis, pi / 2 - thetas, rs);
    vhats = [-sin(alphas) .* sin(phis) - cos(alphas) .* cos(thetas) .* cos(phis), ...
            sin(alphas) .* cos(phis) - cos(alphas) .* cos(thetas) .* sin(phis), ...
            cos(alphas) .* sin(thetas)];

    rs0 = cat(1, rs0, [x, y, z] + rc0(i, :));
    vs0 = cat(1, vs0, sqrt(mc(i) ./ rs) .* vhats + vc0(i, :));
end

% ----- INITIALIZE CORE AND STAR POSITIONS -----
rc = zeros(nc, 3, nt);
rs = zeros(sum(ns), 3, nt);
rc(:, :, 1) = rc0;
rs(:, :, 1) = rs0;
rc(:, :, 2) = rc0 + dt * vc0 + 0.5 * dt ^ 2 * accelCores(mc, rc(:, :, 1));
rs(:, :, 2) = rs0 + dt * vs0 + 0.5 * dt ^ 2 * accelStars(mc, rc(:, :, 1), rs(:, :, 1));

% ----- DEFINE MAP FROM CORE TO ITS STARS -----
c2s = cell(1, nc);
for j = 1: nc
    prev = sum(ns(1: j - 1));
    c2s{j} = prev + 1: prev + ns(j);
end

% ----- 4-LEVEL CONVERGENCE TEST -----
levels = [level - 3, level - 2, level - 1, level];
[t1, x1] = trackX(rc, rs, mc, tmax, levels(1));
[t2, x2] = trackX(rc, rs, mc, tmax, levels(2));
[~, x3] = trackX(rc, rs, mc, tmax, levels(3));
[~, x4] = trackX(rc, rs, mc, tmax, levels(4));

dx12 = x1 - x2(1: 2: end);
dx23 = (x2(1: 2: end) - x3(1: 4: end)) * 4;
dx34 = (x3(1: 4: end) - x4(1: 8: end)) * 16;
plot(t1, dx12, 'g');
plot(t1, dx23, 'r');
plot(t1, dx34, 'k');
xlabel('time');
ylabel('scaled \Deltax between adjacent levels');
legend(sprintf('\\Deltax_{%d,%d}', levels(1), levels(2)), ...
    sprintf('4\\Deltax_{%d,%d}', levels(2), levels(3)), ...
    sprintf('16\\Deltax_{%d,%d}', levels(3), levels(4)), 'interpreter', 'tex');
pause(5);

% ----- ANIMATE AND SAVE -----
if do_save
    writer = VideoWriter(save_name);
    open(writer);

    for i = 2: nt
        clf, hold on, box on, axis equal, axis manual;
        xlim(plot_lims(1, :));
        ylim(plot_lims(2, :));
        zlim(plot_lims(3, :));
        xlabel('x');
        ylabel('y');
        title(sprintf('step: %d of %d, time: %.2f', i - 1, nt - 1, t(i)));
        plot(0, 0, 'ok', 'MarkerSize', 3);

        for j = 1: nc
            plot(rs(c2s{j}, 1, i), rs(c2s{j}, 2, i), '.', 'MarkerSize', size_stars, 'MarkerEdgeColor', color_stars(j, :));
            plot(rc(j, 1, i), rc(j, 2, i), '.', 'MarkerSize', size_cores(j), 'MarkerEdgeColor', color_cores(j, :));
            if trace_cores
                trace = reshape(rc(j, :, 1: i), 3, []);
                plot(trace(1, :), trace(2, :), '--', 'Color', color_cores(j, :));
            end
        end

        drawnow;
        writeVideo(writer, getframe(gcf));
        pause(delay);
        [rc, rs] = iterate(i, rc, rs, mc, dt);
    end
    close(writer);
end

close all;

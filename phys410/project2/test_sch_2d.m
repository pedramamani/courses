mode = 2; % 1 through 3 for the following modes
titles = {'Simulation', 'Relative Conv', 'Absolute Error'};

% Parameters used for different experiments
% sinusoid IC: 0.05, 6, 9, 0.05, 0, [2, 3], 0, []
% finite barrier: 0.04, 5, 8, 0.01, 1, [0.25, 0.5, 0.1, 0.1, 10, 0], 1, [0.45, 0.55, 0, 1, 1E3]
% finite well: 0.04, 5, 8, 0.01, 1, [0.25, 0.5, 0.1, 0.1, 10, 0], 1, [0.45, 0.65, 0.2, 0.8, -1E3]
% double slit: 0.0025, 5, 8, 0.001, 1, [0.5, 0.125, 0.3, 0.05, 0, 100], 2, [0.35, 0.4, 0.6, 0.65, 1E6]

fig = figure('Name', titles{mode});
set(fig, 'WindowKeyPressFcn', @onKeyPress);
global key
key = '';
hold on, grid on;

if mode == 1
    [x, y, t, psi, psire, psiim, psimod, v] = sch_2d_adi(0.04, 7, 0.01, 1, [0.25, 0.5, 0.1, 0.1, 10, 0], 1, [0.45, 0.55, 0, 1, 1000]);
    nt = length(t);
    writer = VideoWriter('sim_2d.avi');
    open(writer);
    
    xlabel('$x$', 'Interpreter', 'Latex');
    ylabel('$y$', 'Interpreter', 'Latex');
    c = colorbar;
    c.Label.Interpreter = 'Latex';
    c.Label.String = '$|\psi|$';
    caxis([0, 1]);
    %zlim([-1,1]);
    %view(3);
    
    for j = 1: nt
        cla;
        %contourf(x, y, squeeze(psire(j, :, :)));
        %surf(x, y, squeeze(psiim(j, :, :)));
        contourf(x, y, squeeze(psimod(j, :, :)));
        %legend('$Re(\psi)$', '$Im(\psi)$', '$|\psi|$', 'Interpreter', 'Latex');
        title(sprintf('Step %d of %d', j, nt));
        drawnow;
        writeVideo(writer, getframe(gcf));
        pause(0);
        if strcmpi(key, 'q')
            close all;
            break
        end
    end
    close(writer);

elseif mode == 2
    xlabel('$t$', 'Interpreter', 'Latex');
    [levels, tConv, dpsiNormsX, labels] = sch_2d_conv(0.0025, 5, 8, 0.001, 1, [0.5, 0.125, 0.3, 0.05, 0, 100], 2, [0.35, 0.4, 0.6, 0.65, 1E6]);
    for k = 1: length(levels)
        plot(tConv, dpsiNormsX(k, :), 'DisplayName', labels{k});
    end
    legend show;
    
elseif mode == 3
    xlabel('$t$', 'Interpreter', 'Latex');
    [levels, tConv, dpsiNormsX, labels] = sch_2d_err(0.05, 6, 9, 0.05, 0, [2, 3], 0, []);
    for k = 1: length(levels)
        plot(tConv, dpsiNormsX(k, :), 'DisplayName', labels{k});
    end
    legend show;
end


function onKeyPress(~, event)
    global key
    key = event.Key;
end

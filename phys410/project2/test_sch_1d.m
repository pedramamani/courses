mode = 1; % 1 through 5 for the following modes
titles = {'Simulation', 'Relative Conv', 'Absolute Error', 'Finite Barrier', 'Finite Well'};

% Parameters used for different experiments
% sinusoid IC: 0.25, 6, 9, 0.1, 0, [3], 0, []
% boosted Gaussian IC: 0.01, 6, 9, 0.01, 1, [0.5, 0.075, 0], 0, []
% finite barrier: 0.1, 6, 9, 0.01, 1, [0.4, 0.075, 20], 1, [0.6, 0.8, ~]
% finite well: 0.1, 6, 9, 0.01, 1, [0.4, 0.075, 20], 1, [0.6, 0.8, ~]

fig = figure('Name', titles{mode});
set(fig, 'WindowKeyPressFcn', @onKeyPress);
global key
key = '';
hold on, grid on;

if mode == 1
	[x, t, psi, psire, psiim, psimod, prob, v] = sch_1d_cn(0.1, 9, 0.01, 1, [0.4, 0.075, 20], 1, [0.6, 0.8, -200]);
    nt = length(t);
    writer = VideoWriter('sim_1d.avi');
    open(writer);
    ylim([-0.1, 1.1]);
    xlabel('$x$', 'Interpreter', 'Latex');
    
    for it = 1: nt
        cla;
        %plot(x, psire(it, :), 'g');
        %plot(x, psiim(it, :), 'r');
        plot(x, psimod(it, :), 'b');
        %legend('$Re(\psi)$', '$Im(\psi)$', '$|\psi|$', 'Interpreter', 'Latex');
        title(sprintf('Step %d of %d', it, nt));
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
    [levels, tConv, dpsiNormsX, labels] = sch_1d_conv(0.1, 6, 9, 0.01, 1, [0.4, 0.075, 20], 1, [0.6, 0.8, -200]);
    for il = 1: length(levels)
        plot(tConv, dpsiNormsX(il, :), 'DisplayName', labels{il});
    end
    legend show;
    
elseif mode == 3
    xlabel('t');
    [levels, tConv, dpsiNormsX, labels] = sch_1d_err(0.25, 6, 9, 0.1, 0, [3], 0, []);
    for il = 1: length(levels)
        plot(tConv, dpsiNormsX(il, :), 'DisplayName', labels{il});
    end
    legend show;
    
elseif mode == 4
    v0 = exp(linspace(-2, 5, 251));
    Fe = zeros(size(v0));
    
    for iv = 1: length(v0)
        [x, t, psi, psire, psiim, psimod, prob, v] = sch_1d_cn(0.1, 9, 0.01, 1, [0.4, 0.075, 20], 1, [0.6, 0.8, v0(iv)]);
        nx = length(x);
        i1 = round(0.8 * nx);
        i2 = round(1.0 * nx);
        
        pbar = mean(prob, 1);
        pbar = pbar / pbar(end);
        Fe(1, iv) = (pbar(i2) - pbar(i1)) / 0.2;
    end
    plot(log(v0), log(Fe));
    xlabel('$\ln(|V_0|)$', 'Interpreter', 'Latex');
    ylabel('$\ln(\bar{F}_e(0.8, 1.0))$', 'Interpreter', 'Latex');
    
elseif mode == 5
    v0 = -exp(linspace(2, 10, 251));
    Fe = zeros(size(v0));
    
    for iv = 1: length(v0)
        [x, t, psi, psire, psiim, psimod, prob, v] = sch_1d_cn(0.1, 9, 0.01, 1, [0.4, 0.075, 20], 1, [0.6, 0.8, v0(iv)]);
        nx = length(x);
        i1 = round(0.6 * nx);
        i2 = round(0.8 * nx);
        
        pbar = mean(prob, 1);
        pbar = pbar / pbar(end);
        Fe(1, iv) = (pbar(i2) - pbar(i1)) / 0.2;
    end
    plot(log(v0), log(Fe));
    xlabel('$\ln(|V_0|)$', 'Interpreter', 'Latex');
    ylabel('$\ln(\bar{F}_e(0.6, 0.8))$', 'Interpreter', 'Latex');
end


function onKeyPress(~, event)
    global key
    key = event.Key;
end

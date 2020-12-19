function [levels, t, dpsiNormsX, labels] = sch_2d_conv(tmax, lmin, lmax, lambda, idtype, idpar, vtype, vpar)
% Calculate the relative error in 2D SE solution across a range of levels.
% 
% Inputs
% tmax: Maximum integration time
% level: Discretization level
% lambda: dt/dx
% idtype: Selects initial xfrog_assets type
% idpar: Vector of initial xfrog_assets parameters
% vtype: Selects potential type
% vpar: Vector of potential parameters
% nLevels: Number of levels for convergence test, must be 3 minimum
%
% Outputs
% t: Vector of coarsened t coordinates [nt]
% dpsiNormsX: Array of computed scaled dpsi norms [nl x nt]

    nl = lmax - lmin;
    levels = lmin: lmax-1;
    labels = cell(1, nl);
    [~, ~, t, psiPrev, ~, ~, ~, ~] = sch_2d_adi(tmax, lmin, lambda, idtype, idpar, vtype, vpar);
    dpsiNormsX = zeros(nl, length(t));
    
    for il = 1: nl
        level = lmin + il;
        [~, ~, ~, psi, ~, ~, ~, ~] = sch_2d_adi(tmax, level, lambda, idtype, idpar, vtype, vpar);
        psi = psi(1:2^il:end, 1:2^il:end, 1:2^il:end);
        dpsiNorm = vecnorm(vecnorm(psi - psiPrev, 2, 2), 2, 3);
        dpsiNormsX(il, :) = 4^(il-1) * dpsiNorm;
        labels{il} = ['4^', num2str(il-1), '\cdot ||d\psi^{', num2str(level - 1), '}||'];
        psiPrev = psi;
    end
end

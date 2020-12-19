function [levels, t, dpsiNormsX, labels] = sch_2d_err(tmax, lmin, lmax, lambda, idtype, idpar, vtype, vpar)
% Calculate the absolute error in 2D SE solution across a range of levels.
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
% t: Vector of coarse t coordinates [nt]
% dpsiNormsX: Array of computed scaled dpsi norms [nl x nt]

    nl = lmax - lmin + 1;
    levels = lmin: lmax;
    labels = cell(1, nl);
    [x, y, t, ~, ~, ~, ~, ~] = sch_2d_adi(tmax, lmin, lambda, idtype, idpar, vtype, vpar);
    dpsiNormsX = zeros(nl, length(t));
    mx = idpar(1);
    my = idpar(2);
    psiTrue = exp(-1i * (mx^2 + my^2) * pi^2 * t') .* sin(mx * pi * permute(x, [1, 3, 2])) .* sin(my * pi * y);
    
    for il = 1: nl
        level = lmin + il - 1;
        [~, ~, ~, psi, ~, ~, ~, ~] = sch_2d_adi(tmax, level, lambda, idtype, idpar, vtype, vpar);
        psi = psi(1:2^(il-1):end, 1:2^(il-1):end, 1:2^(il-1):end);
        dpsiNorm = vecnorm(vecnorm(psi - psiTrue, 2, 2), 2, 3);
        dpsiNormsX(il, :) = 4^(il-1) * dpsiNorm;
        labels{il} = ['4^', num2str(il-1), '\cdot ||E(\psi^{', num2str(level), '})||'];
    end
end

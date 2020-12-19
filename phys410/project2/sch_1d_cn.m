function [x, t, psi, psire, psiim, psimod, prob, v] = sch_1d_cn(tmax, level, lambda, idtype, idpar, vtype, vpar)
% Solve the 1D SE problem using the Crank-Nicolson approach.
% 
% Inputs
% tmax: Maximum integration time
% level: Discretization level
% lambda: dt/dx
% idtype: Selects initial xfrog_assets type
% idpar: Vector of initial xfrog_assets parameters
% vtype: Selects potential type
% vpar: Vector of potential parameters
%
% Outputs
% x: Vector of x coordinates [nx]
% t: Vector of t coordinates [nt]
% psi: Array of computed psi values [nt x nx]
% psire Array of computed psi_re values [nt x nx]
% psiim Array of computed psi_im values [nt x nx]
% psimod Array of computed sqrt(psi psi*) values [nt x nx]
% prob Array of computed running integral values [nt x nx]
% v Array of potential values [nx]

   nx = 2^level + 1;
   x = linspace(0.0, 1.0, nx);
   dx = x(2) - x(1);
   dt = lambda * dx;
   nt = round(tmax / dt) + 1;
   t = (0:nt-1) * dt;

   psi = zeros(nt, nx);  % initialize psi
   if idtype == 0
      psi(1, :) = sin(idpar(1) * pi * x);
   elseif idtype == 1
      psi(1, :) = exp(1i * idpar(3) * x - ((x - idpar(1)) ./ idpar(2)) .^ 2);
   end

   v = zeros(1, nx);  % calculate potential
   if vtype == 1
       imin = round(vpar(1) * (nx-1)) + 1;
       imax = round(vpar(2) * (nx-1)) + 1;
       v(imin:imax) = vpar(3);
   end

   dl = 0.5 / dx^2 * ones(nx, 1);
   d = (1i / dt - 1 / dx^2) * ones(nx, 1) - 0.5 * v';
   du = dl;
   dl(nx-1) = 0.0;
   d([1, nx]) = 1.0;
   du(2) = 0.0;

   A = spdiags([dl, d, du], -1:1, nx, nx);
   f = zeros(nx,1);
   
   for it = 1:nt-1
      f(2:nx-1) = (1i / dt + 0.5 * v(2:nx-1)) .* psi(it, 2:nx-1) - 0.5 * (psi(it, 1:nx-2) - 2 * psi(it, 2:nx-1) + psi(it, 3:nx)) / dx^2;
      psi(it+1, :) = A \ f;
   end

   psire = real(psi);
   psiim = imag(psi);
   psimod = sqrt(psi .* conj(psi));
   
   prob = zeros(nt, nx);
   prob(:, 1) = dx * psimod(:, 1) .^ 2;
   for ix = 2: nx
      prob(:, ix) = prob(:, ix-1) + dx * psimod(:, ix) .^ 2;
   end
end

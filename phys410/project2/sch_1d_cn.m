function [x t psi psire psiim psimod prob v] = sch_1d_cn(tmax, level, lambda, idtype, idpar, vtype, vpar)
% Inputs
% tmax: Maximum integration time
% level: Discretization level
% lambda: dt/dx
% idtype: Selects initial data type
% idpar: Vector of initial data parameters
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
   t = [0 : nt-1] * dt;

   psi = zeros(nt, nx);  % initialize psi
   if idtype == 0
      psi(1, :) = sin(idpar(1) * pi * x);
   elseif idtype == 1
      psi(1, :) = exp(i * idpar(3) * x) .* exp(-((x - idpar(1)) ./ idpar(2)) .^ 2);
   end

   v = zeros(1, nx);  % calculate potential
   if vtype == 0
       v(1, :) = 0
   elseif vtype == 1
       imin = round(vpar(1) * (nx-1)) + 1;
       imax = round(vpar(2) * (nx-1)) + 1;
       v(1, imin: imax) = vpar(3);
   end

   dl = zeros(nx, 1);
   d  = zeros(nx, 1);
   dpsi = zeros(nx, 1);
   f  = zeros(nx, 1);

   % Set up tridiagonal system ...
   dl = -1.0 / dx^2 * ones(nx, 1);
   d  = (1.0 / dt + 2.0 / dx^2) * ones(nx, 1);
   dpsi = dl;
   % Fix up boundary cases ...
   d(1) = 1.0;
   dpsi(2) = 0.0;
   dl(nx-1) = 0.0;
   d(nx) = 1.0;
   % Define sparse matrix ...
   A = spdiags([dl d dpsi], -1: 1, nx, nx);

   for n = 1: nt-1
      f(2: nx-1) = u(n, 2: nx-1) / dt;
      f(1) = 0.0;
      f(nx) = 0.0;
      psi(n+1, :) = A \ f;
   end

   psire = real(psi);
   psiim = imag(psi);
   psimod = norm(psi);

   prob = zeros(nt, nx);
   prob(:, 1) = psi(:, 1);
   for j = 2: nx
      prob(:, j) = prob(:, j-1) + psi(:, j);
   end




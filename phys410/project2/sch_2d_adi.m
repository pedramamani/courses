function [x, y, t, psi, psire, psiim, psimod, v] = sch_2d_adi(tmax, level, lambda, idtype, idpar, vtype, vpar)
% Solve the 2D SE problem using the ADI method.
% 
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
% y: Vector of y coordinates [ny]
% t: Vector of t coordinates [nt]
% psi: Array of computed psi values [nt x nx x ny]
% psire Array of computed psi_re values [nt x nx x ny]
% psiim Array of computed psi_im values [nt x nx x ny]
% psimod Array of computed sqrt(psi psi*) values [nt x nx x ny]
% v Array of potential values [nx x ny]


   nx = 2^level + 1;
   x = linspace(0.0, 1.0, nx);
   y = x;
   dx = x(2) - x(1);
   dt = lambda * dx;
   nt = round(tmax / dt) + 1;
   t = (0:nt-1) * dt;

   psi = zeros(nt, nx, nx);  % initialize psi
   if idtype == 0
      psi(1, :, :) = sin(idpar(1) * pi * x) .* sin(idpar(2) * pi * y');
   elseif idtype == 1
      psi(1, :, :) = exp(1i * (idpar(5) * x + idpar(6) * y') - ((x - idpar(1)) ./ idpar(3)) .^ 2 - ((y' - idpar(2)) ./ idpar(4)) .^ 2);
   end

   v = zeros(nx, nx);  % calculate potential
   if vtype == 1
       ixMin = round(vpar(1) * (nx-1)) + 1;
       ixMax = round(vpar(2) * (nx-1)) + 1;
       iyMin = round(vpar(3) * (nx-1)) + 1;
       iyMax = round(vpar(4) * (nx-1)) + 1;
       v(iyMin:iyMax, ixMin:ixMax) = vpar(5);

   elseif vtype == 2
       ix1 = round(vpar(1) * (nx-1)) + 1;
       ix2 = round(vpar(2) * (nx-1)) + 1;
       ix3 = round(vpar(3) * (nx-1)) + 1;
       ix4 = round(vpar(4) * (nx-1)) + 1;
       vc = vpar(5);

       jp = (nx - 1) / 4;
       v(jp:jp+1, :) = vc;
       v(jp:jp+1, ix1:ix2) = 0;
       v(jp:jp+1, ix3:ix4) = 0;
   end

   % y sweep
   a = dt / dx^2;
   dl = -0.5i * a * ones(nx, 1);
   d = (1 + 1i * a) * ones(nx, 1);
   du = dl;
   dl(nx-1) = 0.0;
   d([1, nx]) = 1.0;
   du(2) = 0.0;
   
   A = spdiags([dl, d, du], -1:1, nx, nx);
   f = zeros(nx, 1);

   for it = 1: nt-1
       for iy = 2:nx-1
           f(2:nx-1) = (1 - 1i * a) * (1 - 1i * a - 0.5i * dt * v(2:nx-1, iy)') .* psi(it, 2:nx-1, iy) ...
           + 0.5i * a * (1 - 1i * a - 0.5i * dt * v(2:nx-1, iy)') .* (psi(it, 1:nx-2, iy) + psi(it, 3:nx, iy)) ...
           + 0.5i * a * (1 - 1i * a) * (psi(it, 2:nx-1, iy-1) + psi(it, 2:nx-1, iy+1)) ...
           - 0.25 * a^2 * (psi(it, 1:nx-2, iy-1) + psi(it, 3:nx, iy-1) + psi(it, 1:nx-2, iy+1) + psi(it, 3:nx, iy+1));
            psi(it+1, :, iy) = A \ f;
       end

       for ix = 2:nx-1
           d = (1 + 1i * a) * ones(nx, 1) + 0.5i * dt * v(ix, :)';
           d([1, nx]) = 1.0;
           B = spdiags([dl, d, du], -1:1, nx, nx);
           psi(it+1, ix, :) = B \ squeeze(psi(it+1, ix, :));
       end
   end

   psire = real(psi);
   psiim = imag(psi);
   psimod = sqrt(psi .* conj(psi));
end

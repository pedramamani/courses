function [x t u] = diff_1d_imp(tmax, level, dtbydx, ...
                               omega, x0, delta, idtype, trace)
% diff_1d_imp: Solves 1D diffusion equation using O(dt,dx^2) implicit scheme.
% Diffusion constant, sigma = 1.
%
%  Inputs
%
%        tmax:    Maximum integration time.
%        level:   Spatial discretization level.
%        dtbydx:  Ratio of spatial and temporal mesh spacings.
%        omega:   Initial data parameter (sinusoidal data).
%        x0:      Initial data parameter (Gaussian data).
%        delta:   Initial data parameter (Gaussian data).
%        idtype:  Selects initial data type.
%        trace:   Controls tracing output.
%
%  Outputs
%
%        x:       Discrete spatial coordinates.
%        t:       Discrete temporal coordinates.
%        u:       Computed solution.

   % Define mesh and derived parameters ...
   nx = 2^level + 1;
   x = linspace(0.0, 1.0, nx);
   dx = x(2) - x(1);
   dt = dtbydx * dx;
   nt = tmax / dt + 1;
   t = [0 : nt-1] * dt;

   if nargin < 8
      trace = 0;
   end
   if trace
      trace = max((nt - 1) / 32, 1);
   end

   % Initialize solution, and set initial data ...
   u = zeros(nt, nx);
   if idtype == 0
      u(1, :) = sin(omega * x);
   elseif idtype == 1
      u(1, :) = exp(-((x - x0) ./ delta) .^ 2);
   else
      fprintf('diff_1d_imp: Invalid idtype=%d\n', idtype);
      return
   end

   % Initialize storage for sparse matrix and RHS ...
   dl = zeros(nx,1);
   d  = zeros(nx,1);
   du = zeros(nx,1);
   f  = zeros(nx,1);

   % Set up tridiagonal system ...
   dl = -1.0 / dx^2 * ones(nx, 1);
   d  = (1.0 / dt + 2.0 / dx^2) * ones(nx,1);
   du = dl;
   % Fix up boundary cases ...
   d(1) = 1.0;
   du(2) = 0.0;
   dl(nx-1) = 0.0;
   d(nx) = 1.0;
   % Define sparse matrix ...
   A = spdiags([dl d du], -1:1, nx, nx);

   % Compute solution using implicit scheme ...
   for n = 1 : nt-1
      % Define RHS of linear system ...
      f(2:nx-1) = u(n, 2:nx-1) / dt;
      f(1) = 0.0;
      f(nx) = 0.0;
      % Solve system, thus updating approximation to next time 
      % step ...
      u(n+1, :) = A \ f;

      if trace && ~mod(n,trace)
         fprintf('diff_1d_imp: Step %d of %d\n', n, nt);
      end
   end
end

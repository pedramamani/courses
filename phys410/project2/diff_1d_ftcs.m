function [x t u] = diff_1d_ftcs(tmax, level, alpha, ...
                                omega, x0, delta, idtype, trace)
% diff_1d_ftcs: Solves 1D diffusion equation using O(dt,dx^2) explicit 
% scheme (forward time, centred space)
%
%  Inputs
%
%        tmax:    Maximum integration time.
%        level:   Spatial discretization level.
%        alpha:   dt / dx^2
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
   dt = alpha * dx^2;
   nt = round(tmax / dt) + 1;
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
      fprintf('diff_1d_ftcs: Invalid idtype=%d\n', idtype);
   end

   % Compute solution using FTCS formula ...
   for n = 1 : nt-1
      u(n+1, 2:nx-1) = u(n, 2:nx-1) + (dt / dx^2) *  ( ...
         u(n, 1:nx-2) - 2 * u(n, 2:nx-1) + u(n, 3:nx) );
      if trace && ~mod(n,trace)
         fprintf('diff_1d_ftcs: Step %d of %d\n', n, nt);
      end
   end
end

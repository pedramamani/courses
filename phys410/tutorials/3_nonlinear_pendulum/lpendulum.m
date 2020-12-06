function [t, theta, omega] = lpendulum(tmax, level, theta0, omega0, tracefreq)
%  lpendulum Solves the linear pendulum equation using an O(deltat^2) FDA [phys210-pendulum]
%  
%  Input arguments
%
%      tmax:      (real scalar) Final solution time.
%      level:     (integer scalar) Discretization level.
%      theta0:    (real scalar) Initial angular displacement of pendulum.
%      omega0:    (real scalar) Initial angular velocity of pendulum.
%      tracefreq: (optional integer scalar) Frequency of tracing output, 
%                 0 disables tracing.
%
%  Output arguments
%
%      t:      (real vector) Vector of length nt = 2^level + 1 containing
%              discrete times (time mesh).
%      theta:  (real vector) Vector of length nt containing computed 
%              angular displacement at discrete times t(n).
%      omega:  (real vector) Vector of length nt containing computed
%              angular velocity at discrete times t(n).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   % Tracing control: if 5th arg is supplied base tracing on that input,
   % otherwise use local defaults.
   if nargin > 4
      if tracefreq == 0
         trace = 0;
      else
         trace = 1;
      end
   else
      trace = 1;
      tracefreq = 100;
   end

   if trace
      fprintf('In lpendulum: Argument dump follows\n');
      tmax, level, theta0, omega0
   end

   % Define number of time steps and create t, theta and omega arrays of 
   % appropriate size for efficiency.
   nt = 2^level + 1;
   t = linspace(0.0, tmax, nt);
   theta = zeros(1, nt);
   omega = zeros(1, nt);

   % Determine discrete time step from t array.
   deltat = t(2) - t(1);

   % Initialize first two values of the pendulum's angular displacement.
   theta(1) = theta0;
   theta(2) = theta0 + deltat * omega0 - 0.5 * deltat^2 * theta0;
   
   if trace 
      fprintf('deltat=%g theta(1)=%g theta(2)=%g\n',...
              deltat, theta(1), theta(2));
   end

   % Initialize first value of the angular velocity.
   omega(1) = omega0;

   % Evolve the oscillator to the final time using the discrete equations
   % of motion.  Also compute an estimate of the angular velocity at 
   % each time step.
   for n = 2 : nt - 1
      % This generates tracing output every 'tracefreq' steps.
      if rem(n, tracefreq) == 0
         fprintf('lpendulum: Step %g of %g\n', n, nt);
      end

      theta(n+1) = 2 * theta(n) - theta(n-1) - deltat^2 * theta(n);

      omega(n) = (theta(n+1) - theta(n-1)) / (2 * deltat);
   end
   % Use linear extrapolation to determine the value of omega at the 
   % final time step.
   omega(nt) = 2 * omega(nt-1) - omega(nt-2);
end

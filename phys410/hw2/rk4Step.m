function y = rk4Step(f, t0, dt, y0)
% Takes a single fourth-order RK step
% Inputs
%   f: Function handle for ODEs, returns (n x 1)
%   t0: Initial value of time (independent variable)
%   dt: Time step
%   y0: (n x 1) vector of initial values
% Outputs
%   y: Output values after RK step (n x 1)

    k1 = f(t0, y0);
    k2 = f(t0 + dt / 2, y0 + k1 * dt / 2);
    k3 = f(t0 + dt / 2, y0 + k2 * dt / 2);
    k4 = f(t0 + dt, y0 + k3 * dt);

    slope = (k1 + 2 * k2 + 2 * k3 + k4) / 6;
    y = y0 + slope * dt;
end
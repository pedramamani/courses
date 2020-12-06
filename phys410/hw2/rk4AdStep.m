function [y, yError] = rk4AdStep(f, t0, dt, y0, rtol)
% Takes an adaptive RK step that satifies relative error condition
% Inputs
%   f: Function handle for ODEs, returns (n x 1)
%   t0: Initial value of time (independent variable)
%   dt: Time step
%   y0: (n x 1) vector of initial values
%   rtol: Relative tolerance parameter
% Outputs
%   y: Output values after RK step (n x 1)
%   yError: Error in output values (n x 1)

    y1 = rk4Step(f, t0, dt, y0);
    y2 = rk4Step(f, t0, dt / 2, y0); y2 = rk4Step(f, t0 + dt / 2, dt / 2, y2);
    e1 = 16 / 15 * (y1 - y2);
    dtAd = dt * (norm(rtol * y2) / norm(e1)) ^ 0.2;

    if dtAd < dt
        dtAd = max(dtAd, 1E-4);
        nAdSteps = ceil(dt / dtAd);
        dtAd = dt / nAdSteps;

        ys = zeros(length(y0), nAdSteps + 1); ys(:, 1) = y0;
        for i = 1: nAdSteps
            ys(:, i + 1) = rk4Step(f, t0 + (i - 1) * dtAd, dtAd, ys(:, i));
        end
        y = ys(:, end);
        yError = e1 * (dtAd / dt) ^ 5;
    else
        y = rk4Step(f, t0, dt, y0);
        yError = e1;
    end
end

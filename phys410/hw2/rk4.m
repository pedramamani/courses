function [ts, ys] = rk4(f, tspan, y0)
% RK4 integrator
% Inputs
%   f: Function handle for ODEs, returns (n x 1)
%   tspan: (1 x m) vector of output times, first value must be 0
%   y0: (n x 1) vector of initial values
% Outputs
%   ts: Output times, identical to tspan
%   ys: Output values (n x m)

nDim = length(y0);
nSteps = length(tspan) - 1;

ts = tspan;
ys = zeros(nDim, nSteps + 1);
ys(:, 1) = y0;

for i = 1: nSteps
    dt = ts(i + 1) - ts(i);
    ys(:, i + 1) = rk4Step(f, ts(i), dt, ys(:, i));
end
end
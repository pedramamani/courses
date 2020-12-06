function [ts, dt, nt] = timeGrid(range, level)
% Generate a time grid for given range and level
nt = 2 ^ level + 1;
ts = linspace(range(1), range(2), nt);
dt = ts(2) - ts(1);
end
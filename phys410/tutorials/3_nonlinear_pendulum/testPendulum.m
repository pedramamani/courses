clear, clc
format compact

tmax = 40.0;
level = 8;
theta0 = 0;
omega0 = 0.01;

[t theta omega]   =  pendulum(tmax, level, theta0, omega0);
[t ltheta lomega] = lpendulum(tmax, level, theta0, omega0);
clf; hold on; plot(t, theta, 'r'); plot(t, ltheta, 'og');
clf; plot(t, theta-ltheta);

[t6 theta6 omega6]   =  pendulum(tmax, 6, theta0, omega0);
[t7 theta7 omega7]   =  pendulum(tmax, 7, theta0, omega0);
[t8 theta8 omega8]   =  pendulum(tmax, 8, theta0, omega0);
[t9 theta9 omega9]   =  pendulum(tmax, 9, theta0, omega0);

clf; hold on; plot(t6, theta6, 'r-.o');
plot(t7, theta7, 'g-.+'); plot(t8, theta8, 'b-.*');

theta7 = theta7(1:2:end);
theta8 = theta8(1:4:end);
theta9 = theta9(1:8:length(theta9));
dtheta67 = theta6 - theta7;
dtheta78 = theta7 - theta8;
dtheta89 = theta8 - theta9;
dtheta78 = 4 * dtheta78;
dtheta89 = 16 * dtheta89;

clf; hold on;
plot(t6, dtheta67, 'r-.o'); plot(t6, dtheta78, 'g-.+'); plot(t6, dtheta89, 'b-.*');

tmax = 40; level = 8; theta0 = 0;

for omega0 = [0.1 0.3 1.0 1.5 1.9]
  [t theta omega]   =  pendulum(tmax, level, theta0, omega0);
  [t ltheta lomega] = lpendulum(tmax, level, theta0, omega0);
  clf; hold on; ptitle = sprintf('omega_0 = %g',omega0);
%  plot(t, theta, 'r'); plot(t, ltheta, '-.og');
  title(ptitle);
  input('Type ENTER to continue: ');
  clf; hold on; ptitle = sprintf('Phase space plot: omega_0 = %g',omega0);
  plot(theta, omega, 'r'); plot(ltheta, lomega, '-.og');
  title(ptitle);
  xlabel('theta');
  ylabel('omega');
  input('Type ENTER to continue: ');
end

[t thetalo omegalo]   =  pendulum(tmax, level, theta0, 2);
[t thetahi omegahi]   =  pendulum(tmax, level, theta0, 2.05);
clf; hold on;
plot(t, thetalo, 'g'); plot(t, thetahi, 'r');
title('"low" and "high" behaviour');

D1 = 0.1; % KcKp
D2 = 1; % TI/(tau+theta)
%D3 = 0.19; % TD/(tau+theta)

% Value of damping coefficient
zeta = 0.7;
% Nominal value of independent variable tau/(tau+theta)
V = 0.7; % ô/(è+ô)


[num,den] = pade(1-V, 2);

Gtda = tf(num,den);

Gpid = D1*tf([D2 1],[D2 0]);

Gp = tf([1],[V^2 2*zeta*V 1]);

Gcl0 = feedback(Gpid*Gtda*Gp,1);

[y0,t0]=step(Gcl0);
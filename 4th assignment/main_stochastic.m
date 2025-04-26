% this is a script to run the simulated annealing and the genetic
% algorithms

%% Objective function
num_var = 2;

% the objective is defined in the evaluation function so no need to define
% it here.
% f = @(x) sum((x(1:num_var-1) + x(2:num_var) - 3).^2 + (x(1:num_var-1) - x(2:num_var) + 1).^4);

pres = 1e-6;      % precision required
max_iter = 300; % maximum iterations for evolutionary algorithm

% domain for each variable
% B = [1.0368, 1.3699, 1.5, 1.6301, 1.9632

if num_var == 2
    lower_bounds = [0 1.5];
    upper_bounds = [2.5 2.5];

elseif num_var == 5
    lower_bounds = [0 1.5 0.5 0.6 1];
    upper_bounds = [2.5 2.5 2.5 2.5 3];
end



%% genetic algorithm call
tic
[GA_opt_value, GA_opt_sol, GA_req_iters, X, GA_Z_opt_history] = genetic_algorithm(num_var, lower_bounds, upper_bounds, max_iter, pres);
toc

if num_var == 2
% Define the meshgrid
[x1, x2] = meshgrid(0:0.01:2.5, 1.5:0.01:2.5);

% Modify the function to work with matrices
f = @(x1, x2) (x1 + x2 - 3).^2 + (x1 - x2 + 1).^4;

% Calculate z values
z = f(x1, x2);  % This will now return a matrix

% Create the contour plot
figure;
contourf(x1, x2, z);
hold on;
colorbar;

% Plot the convergence path
x1_opt = GA_Z_opt_history(1:GA_req_iters,1)';
x2_opt = GA_Z_opt_history(1:GA_req_iters,2)';
plot(x1_opt, x2_opt, 'r.-', 'MarkerSize', 15);

% Enhancements
xlabel('x1');
ylabel('x2');
title('Contour Plot with best fit');
legend('Function Contours', 'Convergence Path');
hold off;
end

aaa = zeros(1, GA_req_iters);

for i = 1:GA_req_iters
    aaa(1, i)= i;
end

% plot z

figure
hold on 
plot( aaa, GA_Z_opt_history(1:GA_req_iters,num_var+1), 'r-');
xlabel('Generation');
ylabel('Objective Value');
hold off




%% simulated annealing call


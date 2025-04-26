function [fitness_values] = evaluation(X, num_var)
    n = size(X, 1); % number of solutions in the population
    fitness_values = zeros(n, 1);

    for i = 1:n
        sol = X(i, :); % extract every solution from the population

        % Calculate the fitness value using the provided function
        fitness_value = sum((sol(1:num_var-1) + sol(2:num_var) - 3).^2 + (sol(1:num_var-1) - sol(2:num_var) + 1).^4);

        % Store the fitness value
        fitness_values(i) = fitness_value;
    end
end

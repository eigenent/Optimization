function [GA_opt_value, GA_opt_sol, GA_req_iters, X, GA_Z_opt_history] = genetic_algorithm(num_var, lower_bounds, upper_bounds, max_iter, pres)
    % This is the function that is being called to provide the optimal solution
    % to a minimization problem using a binary genetic algorithm.
    
    % inputs are
    % - number of variables
    % - the upper and lower bounds for the population
    % - maximum evolutionary iterations
    
    
    % outputs are
    % - the optimal value
    % - the optimal solution coordinates
    % - number of iterations required
    % - the last population
    % - the history of each step's best chromosome and their fit value
    
    kappa = 1; % iterations counter
    tol = pres;
     
    % how many bits in a chromosome
    req_bits = zeros(1,num_var);
    for i = 1:num_var
        a = (upper_bounds(i) - lower_bounds(i)) / pres;   % how many numbers
        req_bits(i) = ceil(log2(a)); % rounding up
    end
        
    % population initialization
    
    % population size
    population_number = 10;
    x_reduced = rand(population_number, num_var);
    X = zeros(population_number, 2);
    
    for i = 1:population_number
        for j = 1:num_var
             X(i, j) = lower_bounds(j) + x_reduced(i,j)*(upper_bounds(j) - lower_bounds(j));
        end
    end
    
    X_new = X;  % this is for consistency
    
    GA_Z_opt_history = zeros(max_iter, num_var + 1); % initializing history matrix

    %% evaluation, fitness function
    [fitness_values] = evaluation(X_new, num_var);
    X_ranked = [X_new, fitness_values]; % adding the fitness as part of the solution matrix
    X_ranked = sortrows(X_ranked, size(X_ranked,2)); % sorting X matrix, the last column 
    % is the fit score, it is ascending because it is minimization
    GA_Z_opt_history(kappa, :) = X_ranked(1, :);
    X_ranked(:, num_var + 1) = []; % removing the last column to encode them in order

    while kappa <= max_iter       
        %% encoding
        [chromo_sorted] = encoding_gpt(X_ranked, req_bits, lower_bounds, upper_bounds);
    
        %% crossover 
        [chromo_upper_50, chromo_offsprings] = crossover(chromo_sorted);

        %% mutation
        mutation_rate = 0.2;
        mutation_probability = 0.1;
        [chromo_mutated_offsprings] = mutations(chromo_offsprings, mutation_rate, mutation_probability);

        % chromo_mutated = chromo_new_pop;
        chromo_new_pop = [chromo_upper_50; chromo_mutated_offsprings];


    
        %% decode, new set of solutions to evaluate!
        [X_new] = decoding_gpt(chromo_new_pop, req_bits, lower_bounds, upper_bounds);

        %% evaluation, fitness function
        [fitness_values] = evaluation(X_new, num_var);
        X_ranked = [X_new, fitness_values]; % adding the fitness as part of the solution matrix
        X_ranked = sortrows(X_ranked, size(X_ranked,2)); % sorting X matrix, the last column 
        % is the fit score, it is ascending because it is minimization
        GA_Z_opt_history(kappa, :) = X_ranked(1, :);
        X_ranked(:, num_var + 1) = []; % removing the last column to encode them in order

        %% early termination condition

        if GA_Z_opt_history(kappa, num_var+1) <= tol
            break
        end

        kappa = kappa + 1; % counter
    end

    if kappa >=2
        GA_opt_value = GA_Z_opt_history(kappa-1, size(GA_Z_opt_history, 2));
        GA_opt_sol = GA_Z_opt_history(kappa-1, 1:(size(GA_Z_opt_history, 2)-1));
        GA_req_iters = kappa - 1;
    else
        GA_opt_value = GA_Z_opt_history(kappa, size(GA_Z_opt_history, 2));
        GA_opt_sol = GA_Z_opt_history(kappa, 1:(size(GA_Z_opt_history, 2)-1));
        GA_req_iters = kappa;
    end


end


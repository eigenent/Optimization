function [mutated_chromosomes] = mutations(chromosomes, mutation_rate, mutation_probability)
    num_chromosomes = size(chromosomes, 1);
    num_bits = size(chromosomes, 2);
    
    % Ensure the number of chromosomes to mutate is at least 1
    num_to_mutate = max(1, round(num_chromosomes * mutation_rate));

    % Select chromosomes for mutation
    indices_to_mutate = randperm(num_chromosomes, num_to_mutate);

    % Copy chromosomes to avoid modifying the original
    mutated_chromosomes = chromosomes;

    % Perform mutation
    for i = 1:num_to_mutate
        index = indices_to_mutate(i);
        for j = 1:num_bits
            if rand <= mutation_probability
                % Flip the bit
                mutated_chromosomes(index, j) = 1 - mutated_chromosomes(index, j);
            end
        end
    end
end

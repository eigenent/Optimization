function [chromo_upper_50, chromo_offsprings] = crossover(chromo_sorted)

    % I first need to select the best 50% of the solutions to mate
    upper_50 = ceil(size(chromo_sorted, 1)/2);
    first_part = ceil(size(chromo_sorted, 2)/2); % this is to cut the chromosome in the middle
    
    % ensures that we have 2 parent in each pair with no chromo remaining
    if mod(upper_50,2) ~= 0
        upper_50 = upper_50 + 1;
    end
    
    chromo_upper_50 = chromo_sorted(1:upper_50, :);
    
    % time for pairs
    chromo_offsprings = zeros(size(chromo_upper_50)); % initialize the offspring population
    num_of_pairs = upper_50/2;

    % suppose that the chromosomes pair randomly, I do not like this but hey
    % ho this is a simple exercise
    
    % steps
    % 1. randomly chose half of the numbers between 1 and upper_50
    % 2. shuffle them and assign them in the first column of the pair matrix
    % 3. remove this half from the 1 to upper_50 number range
    % 4. shuffle the remaining and assign them to the second column of the pair matrix
    person = 1:upper_50; % we all start as women fetuses but here it is reverse
    male_indices = randperm(int32(upper_50), num_of_pairs); % Generate a random permutation of indices 
    male = person(male_indices);                          % Select elements using these indices

    female = setdiff(person, male);                % remove the first half

    pairs = [male', female'];

    % uniform crossover, p1 = [a b c d], p2 = [e f g h], 
    % then c1 = [a b g h] and c2 = [e f c d]
    for i = 1:num_of_pairs
        chromo_offsprings(i, :) = [chromo_sorted(pairs(i,1), 1:first_part), ...
                                   chromo_sorted(pairs(i,2), (first_part+1):size(chromo_upper_50, 2))];
        j = i+num_of_pairs; % this is to have 2 offsprings per pair
        chromo_offsprings(j, :) = [chromo_sorted(pairs(i,2), 1:first_part), ...
                                                chromo_sorted(pairs(i,1), (first_part+1):size(chromo_upper_50, 2))];
    end

end

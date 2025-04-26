function [chromo] = encoding_gpt(X, req_bits, lower_bounds, upper_bounds)
    n_enc = size(X, 1); % number of solutions
    num_variables = size(X, 2); % number of variables
    total_bits = sum(req_bits); % total number of bits for a chromosome
    chromo = zeros(n_enc, total_bits);

    for i = 1:n_enc
        % For each solution
        binaryString = '';

        for j = 1:num_variables
            % Normalize and scale
            range = upper_bounds(j) - lower_bounds(j);
            scaledValue = (X(i,j) - lower_bounds(j)) / range;
            intVal = round(scaledValue * (2^req_bits(j) - 1));

            % Convert to binary string and pad with zeros
            binStr = dec2bin(intVal, req_bits(j));
            binaryString = [binaryString binStr]; % concatenate
        end

        % Convert binary string to array of digits
        chromo(i,:) = arrayfun(@(x) str2double(x), binaryString);
    end
end

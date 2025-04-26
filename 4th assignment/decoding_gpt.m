function [X_decoded] = decoding_gpt(chromo, req_bits, lower_bounds, upper_bounds)
    n = size(chromo, 1); % number of solutions
    num_variables = length(req_bits); % number of variables
    X_decoded = zeros(n, num_variables);
    startIdx = 1;

    for i = 1:n
        for j = 1:num_variables
            % Extract binary string for current variable
            endIdx = startIdx + req_bits(j) - 1;
            binStr = chromo(i, startIdx:endIdx);
            binStr = num2str(binStr);
            binStr(binStr == ' ') = ''; % Remove any spaces

            % Convert binary to integer
            intVal = bin2dec(binStr);

            % Scale and normalize to original range
            range = upper_bounds(j) - lower_bounds(j);
            scaledValue = intVal / (2^req_bits(j) - 1);
            X_decoded(i,j) = lower_bounds(j) + scaledValue * range;

            startIdx = endIdx + 1;
        end
        startIdx = 1; % Reset start index for next solution
    end
end

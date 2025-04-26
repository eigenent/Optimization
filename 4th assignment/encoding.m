function [chromo] = encoding(X, req_bits)

% for x1 and x2 number
% initialize chromosome matrix
% chromo = zeros(size(x1, 1), req_bits1 + req_bits2);
% convert x to binary string
% chromosome1 = dec2bin(round(x1 * (2^req_bits1 - 1)), req_bits1);
% chromosome2 = dec2bin(round(x2 * (2^req_bits2 - 1)), req_bits2);
% chromo = cat(2, chromosome1, chromosome2);

% initialize chromosome matrix
chromo = zeros(size(X,1), sum(req_bits));

% for X

% turning each component into a binary expression, x2 for ith sol is chromosome(i,2)
%chromosome = zeros(size(X,1), req_bits);

for i = 1:size(X,1)
    for j = 1:size(X,2)
        chromosome_char(i,j) = dec2bin(round(X(i,j) * (2^req_bits(1,j) - 1)), req_bits(1,j));
        chromosome(i,j, :) = double(chromosome_char) - 48;

    end
end 


for i = 1:size(X,1)
    chromosome_exp(i,1) = chromosome(i,1);
    for j = 2:size(X,2)
        chromosome_exp(i,j) = cat(2, chromosome_exp(i,j-1), chromosome(i,j));
    end
    chromo(i,:) = chromosome_exp(i,:);
end

end


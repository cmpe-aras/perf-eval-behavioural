function [ y ] = sigmoid( x )
%SIGMOID

y = 1.0 ./ (1.0 + exp(-x));

end


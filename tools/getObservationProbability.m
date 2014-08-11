function B_out = getObservationProbability(observation, observationModel)
% Q  : number of states
% N  : number of observation symbols if observation is a scalar and number
%      of sensors if observation is a vector
% observation : is either a scalar giving the value of the symbol or 
%                         a N x 1 vector gives the values of each sensor
% observationModel : Q x N matrix 
%                    if observation is a scalar sum of rows = 1
%                    if observation is a vector and the elements 
%                    matrix gives the probabilities for the positive value 
%                    for the binary sensor value (i.e. 1)
% B_out : Q x 1 vector that gives the proability of observation for each
%         state

if isscalar(observation) % observation is a symbol
    B_out = observationModel(:,observation);
else % observation is a Nx1 vector where N is the number of sensors
    % find the positive values of sensors
    pos = observationModel(:, find(observation == 1));
    neg = observationModel(:, find(observation == 0));
    B_out = prod([pos 1.- neg],2);
end
end
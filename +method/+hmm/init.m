function [method pars] = init(pars)
    % Name contains the folder the required functions are stored
    method.name = 'hmm';
    % add this method to the parameter structure
    if(~isfield(pars.method, 'name'))
        pars.method.name = 'hmm';
    else
        pars.method.name = {pars.method.name ;'hmm'}; 
    end
end


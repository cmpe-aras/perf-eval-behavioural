function [method pars] = init(pars)
    % Name contains the folder the required functions are stored
    method.name = 'twnn';
    % add this method to the parameter structure
    if(~isfield(pars.method, 'name'))
        pars.method.name = 'twnn';
    else
        pars.method.name = {pars.method.name ;'twnn'}; 
    end
end


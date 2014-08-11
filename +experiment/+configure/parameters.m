function pars = parameters(experimentType)

switch lower(experimentType)
    case 'activity recognition'
        pars = defaultTypeParametersActivityRecognition;
    case 'active learning'
        pars = defaultTypeParametersActiveLearning;
    otherwise
        error('Unknown experiment type, please add type to the parameters function');
end
pars.general.experimentType = experimentType;
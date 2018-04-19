function [ model ] = loadModel( )
%loadModel
%
%   Function used for loading a genome scale metabolic model
%
%   Requests user to provide the name of the genome scale metabolic model
%   that should be assigned annotation
%
%   Returns the genome scale metabolid model in it's matlab structure form
%
%      
%   Usage: model = loadModel
%
%   Dimitra Lappa, 2015-01-24

    prompt = 'Please type in the name of the genome-scale metabolic model you wish to load: \n \n';
    str = input(prompt,'s');
    if isempty(str)
        prompt = 'Please provide a proper name';
        str = input(prompt,'s');
    else
        model = load(str);
    end

end


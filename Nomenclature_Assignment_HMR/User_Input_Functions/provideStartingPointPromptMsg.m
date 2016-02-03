function [ startingPoint ] = provideStartingPointPromptMsg( model )
%provideStartingPointPromptMsg
%
%   Function used for printing communication messages to the user for
%   providing input
%
%   Takes as input a GEM model and requests user input for
%   a variable called startingPoint, which is the index of the metabolite
%   the assignment is going to start from. If it is the first time
%   Nomenclature script is being run, it is going to be 1, otherwise it has
%   the index value of the metabolite that the program stopped at.
%
%   Usage: startingPoint = provideStartingPointPromptMsg(startingPoint)
%
%   Dimitra Lappa, 2016-01-24

fprintf('Please type in startingPoint \n');
fprintf('startingPoint is the index of the metabolite where the assignment is starting from \n');
fprintf( 'If it is the first time Nomenclature script is being run, please type 1 \n');
prompt = 'Otherwise type the index value of the metabolite that the program stopped at: \n \n';
str = input(prompt,'s');

if isempty(str)
    while isempty(str)
        prompt = 'Please provide a proper startingPoint';
        str = input(prompt,'s');
    end
end
startingPoint = str2num(str);

if startingPoint > length(model.ihuman.mets)
    fprintf('Cannot proceeding in identifiers assignment, index out of range \n \n');
else
    if isempty(str)
        while isempty(str)
            prompt = 'Please provide a proper startingPoint';
            str = input(prompt,'s');
        end
    end
    startingPoint = str2num(str);
end

end


function [ continuing ] = continueAssigningIdsPromptMsg(startingPoint)
% continueAssignIdsPromptMsg
%
%   Function used for printing communication messages to the user for
%   providing input
%
%   Takes as input n integer variable called starting_point, is the index of the metabolite
%   the assignment is going to start from. If it is the first time
%   Nomenclature script is being run, it is going to be 1, otherwise it has
%   the index value of the metabolite that the program stopped at. 
%
%   Returns binary variable. If true, Nomeclature Script Will Continue to
%   Run, if false,Nomeclature Script will be terminated.
%
%      
%   Usage: continuing = continueAssigningIdsPromptMsg(startingPoint)
%
%   Dimitra Lappa, 2015-12-10
    prompt = 'Do you want to continue assigning metabolites? y/n: \n \n';
    str = input(prompt,'s');
    if isempty(str)
        while isempty(str)
            prompt = 'Please provide a proper y/n answer';
            str = input(prompt,'s');
        end
    elseif strcmpi(str, 'y')
        fprintf('Proceeding in identifiers assignment \n \n');
        continuing = 1;
    elseif strcmpi(str, 'n')
        fprintf('Not wishing to continue, aborting assignment mission! \n \n');
        fprintf('Please keep in mind that you were in index: \n \n');
        startingPoint
        fprintf('Please do not forget to replace starting point with this number, \n');
        fprintf('if you wish to proceed later on with the assignment \n \n');
        continuing = 0;
        return
    else
        fprintf('Should the assignment mission be aborted? \n \n');
        continuing = 1;
    end
     
    
end
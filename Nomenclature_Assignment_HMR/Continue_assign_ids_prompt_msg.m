function [ continuing ] = Continue_assign_ids_prompt_msg(starting_point)
% Continue_assign_ids_prompt_msg
%
%   Function used for printing communication messages to the user for
%   providing input
%
%   INPUT: An integer variable called starting_point, is the index of the metabolite
%   the assignment is going to start from. If it is the first time
%   Nomenclature script is being run, it is going to be 1, otherwise it has
%   the index value of the metabolite that the program stopped at. 
%
%   OUTPUT: A binary variable. If true, Nomeclature Script Will Continue to
%   Run, if false,Nomeclature Script will be terminat.
%
%      
%   Usage: continuing = Continue_assign_ids_prompt_msg(Continue_assign_ids_prompt_msg)
%
%   Dimitra Lappa, 2015-12-10
    prompt = 'Do you want to continue assigning metabolites? y/n: \n \n';
    str = input(prompt,'s');
    if isempty(str)
        str = 'y';
    elseif strcmpi(str, 'y')
        fprintf('Proceeding in identifiers assignment \n \n');
        continuing = 1;
    elseif strcmpi(str, 'n')
        fprintf('Not wishing to continue, aborting assignment mission! \n \n Please keep in mind that you were in index: \n \n');
        starting_point
        fprintf('Please do not forget to replace starting point with this number, if you wish to proceed later on with the assignment \n \n');
        continuing = 0;
        return
    else
        fprintf('Should the assignment mission be aborted? \n \n');
        continuing = 1;
    end
     
    
end
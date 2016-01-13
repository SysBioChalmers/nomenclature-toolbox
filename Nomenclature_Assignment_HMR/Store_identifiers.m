function [ model ] = Store_identifiers(model, i,stored_chebi_2, stored_inchi_2, stored_chebi_3, stored_inchi_3 )
%Store_identifiers
%   Function for storing Inchi and ChEBI identifiers in the genome scale
%   metabolic model matlab struct.
% 
%   INPUT: The GEM model, the index of the metabolite (current iteration), the InChi-ChEBI identifiers values that were found to correspond to the metabolite 
%     
%   OUTPUT: A new model containing annotation
%   
%   Usage: model = Store_identifiers(model, i,stored_chebi_2, stored_inchi_2, stored_chebi_3, stored_inchi_3)
%
%
%   Dimitra Lappa, 2015-12-10

    prompt = 'Please type your choice of annotation \n';
    choice = input(prompt,'s');
    
    if isempty(choice)
        choice ='1';
    elseif strcmpi(choice, '1')
        model.inchis{i,1} = '';
        model.chebis{i,1} = '';
    elseif strcmpi(choice, '2')
        model.inchis{i,1} = stored_inchi_2;
        model.chebis{i,1} = stored_chebi_2;
        fprintf('Proper Storing of Identifiers \n');
    elseif strcmpi(choice, '2')
        model.inchis{i,1} = stored_inchi_3;
        model.chebis{i,1} = stored_chebi_3;
        fprintf('Proper Storing of Identifiers \n');
    else
        fprintf('NOT Proper Storing of Identifiers, moving on to the next metabolite \n');
    end



end


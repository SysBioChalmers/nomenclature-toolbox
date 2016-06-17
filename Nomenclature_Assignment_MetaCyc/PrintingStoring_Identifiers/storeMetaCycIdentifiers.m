function [ model ] = storeMetaCycIdentifiers(model, metaCycAnnotation, startingPoint, inChI2ChEBIMap)
%storeMetaCycIdentifiers
%   Function for storing Inchi and ChEBI identifiers in the genome scale
%   metabolic model matlab struct.
% 
%   Takes as input:
%           a.a genome scale metabolic model
%           b.the MetaCyc Annotation Matrix corresponding to this metabolite
%           b.the index of the metabolite (current iteration),
%           c.the InChi-ChEBI identifiers values that were found to correspond to the metabolite
%
%   Requests as input:
%           a.an integer number corresponding to the choice of annotation of
%           the user
%     
%   Returns a new model containing the assigned annotation in the
%   respective model structure fields:
%           a.MetaCyc Id
%           b.MetaCyc Metabolite Name
%           c.MetaCyc Annotated InChI
%           d.MetaCyc Annotated ChEBI
%   
%   Usage: model = storeMetaCycIdentifiers(model, metaCycAnnotation, startingPoint, inChI2ChEBIMap)
%
%
%   Dimitra Lappa, 2016-06-10

    %Requesting Annotation
    prompt = 'Please type your choice of annotation \n';
    str = input(prompt,'s');
    
    if isempty(str)
        while isempty(str)
            prompt = 'Please provide a proper choice of annotation';
            str = input(prompt,'s');
        end
    end
    choice = str2num(str);

    if choice > length(metaCycAnnotation)
        fprintf('Cannot proceeding in storing MetaCyc identifiers assignment, index out of range \n \n');
        prompt = 'Please type your choice of annotation \n';
        str = input(prompt,'s');
        if isempty(str)
            while isempty(str)
                prompt = 'Please provide a proper choice of annotation';
                str = input(prompt,'s');
            end
        end
        choice = str2num(choice);
    end
    
                
    %Store the choice ito the model's structure
    model.metaCycMetId{startingPoint,1} = metaCycAnnotation{choice, 1};
    model.metaCycMetName{startingPoint,1} = metaCycAnnotation{choice, 2};
    model.inchis{startingPoint,1} = metaCycAnnotation{choice, 3};
    
    %Get ChEBI Id from InChI String and stores it to the model
    if isKey(inChI2ChEBIMap, metaCycAnnotation{choice, 3})
                chebi = inChI2ChEBIMap(metaCycAnnotation{choice, 3});
                model.metaCycChEBI{startingPoint,1} = chebi;
    end



end
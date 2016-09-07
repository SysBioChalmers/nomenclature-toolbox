function [ model ] = assignChemicalProperties( model, property )
%assignChemicalProperties
%   Function for assigning Chemical Properties to a Genome-Scale Metabolic
%   Model reconstructed from ModelSEED. The properties are chemical
%   formulas for metabolites and 
%   and DeltaG for metabolites and reactions
% 
% Takes as input argument:
%       a. a Genome-Scale Metabolic Model
%       b. a string representing the desired annotation, e.g.
%           i.  'formula'
%           ii. 'deltaG'
%
%   Returns one Genome-Scale Metabolic
%   Model structure with additional fields that represent these chemical properties.
%   The function is calling other functions for
%       a. loading the necessary flatfiles
%       b. creating the Matlab model structures for storing the information
%       c. calculating DeltaG 
%   
%   Usage: model = assignChemicalProperties(property)
%   Dimitra Lappa, 2016-09-01




    if isempty(property)
            while isempty(property)
                fprintf( 'Please provide a proper input argument \n');
                fprintf( 'for assigning chemical properties such as:\n');
                fprintf( ' "formula" or \n');
                fprintf( ' " deltaG"\n');
                prompt = 'Please provide a proper answer\n';
                property = input(prompt,'s');
                property = input(prompt,'s');
            end
    end
    
    if strcmpi(property, 'formula')
        %Loading flatifile for MdodelSEED metabolites and their chemical formulas
        modelSeedMetNameFormula = loadmodelSeedMetNameFormula('modelSEEDcompounds.txt');
            
       for i=1:length(model)
            %Adding a metabolite formula field to the model 
            model(i).metFormula=cell(length(model(i).mets),1);

            %Assign Formula to ModelSeed Ids
            model(i).metFormula = assignModelSeedFormula(model(i).mets, modelSeedMetNameFormula);
        end
    elseif strcmpi(property, 'deltaG')
        modelSeedMetIdDeltaG = loadmodelSeedMetIdDeltaG('DeltaG.txt');
        for i=1:length(model)
            %Adding a metabolite DeltG, DeltaG error field to the model
            model(i).metDeltaG = cell(length(model(i).mets),2);

            %Adding a reaction DeltG field to the model
            model(i).rxnDeltaG = cell(length(model(i).rxns),1);

            %Assign DeltaG values to to ModelSeed Ids
            model(i).metDeltaG = assignModelSeedDeltaG(model(i).mets, modelSeedMetIdDeltaG);

            %Calculate Delta Gs for all the reactions in the models
            model(i) = calculateDeltaG(model(i), modelSeedMetIdDeltaG);
        end
    else
        fprintf( 'No proper input argument,cannot assign chemical properties,re-run your command \n');
    end


end
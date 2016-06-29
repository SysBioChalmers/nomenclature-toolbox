function [ model ] = calculateDeltaG( model, modelSeedMetIdDeltaG )
%calculateDeltaG
%   Creating cella arrays and structures for
%   "calculating":
%       a.DeltaG and reversibility for modelSEED metabolite names and each
%       models reaction
%   
%   Takes as input :
%       a.a GEM Model
%       b.ModelSeed Metabolite id-DeltaG cell array that corresponds to the
%       mapping
%   Returns 1 (nx1) cell array structure that represents Calculated Delta G for the reaction.
%       
%   
%   Usage: model = calculateDeltaG( model, modelSeedMetIdDeltaG )
%
%   Dimitra Lappa, 2016-06-14


        for j=1:length(model.rxns)
            printRxnFormula (model, model.rxns{j, 1});
            [metList, coeffList, reversibility]=parseRxnFormula(ans{1,1});
            deltaG = {};
            deltaGError = {};
            for k=1:length(metList)
                index = find(ismember([modelSeedMetIdDeltaG.textdata(:,1)], metList{1,k}));
                if index ~=0
                    DeltaG = modelSeedMetIdDeltaG.data(index, 1);
                    DeltaGError = modelSeedMetIdDeltaG.data(index, 2);
                else
                    DeltaG = 0;
                    DeltaGError = 0;
                end
                deltaG{1,k} = DeltaG;
                deltaGError{1,k} = DeltaGError;
            end
            %Convert Cell Arrays to matrices
            deltaG=cell2mat(deltaG);
            deltaGError=cell2mat(deltaGError);

            %Calculate DG and append it to the model structure
            DG= coeffList * (deltaG + deltaGError)';
%             DG= coeffList * (deltaG - deltaGError)';
%             DG= coeffList * (deltaG)';
            model.rxnDeltaG{j,1} = DG;
        end
        







end


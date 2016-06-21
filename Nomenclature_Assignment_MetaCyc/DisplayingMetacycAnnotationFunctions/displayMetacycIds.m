function [ metaCycAnnotation ] = displayMetacycIds( model, starting_point,metaCycIdFormulaInChiMapping, metaCycIdMetName, metaCycMetNameSynonyms)
% loadmodelSeedMetNameSynonyms
%   Takes as input:
%           a.a genome-scale metabolic model and MetaCyc data Mapping
%           b.the index of the metabolite (current iteration),
%           c.MetaCyc metabolite's Id-ChemicalFormula-InChI Mapping 
%           d.MetaCyc Ids to metabolite names data Mapping   
%           e.MetaCyc Metabolites name to Synonyms data Mapping   
%   
%   Finds if the Metabolite exists in MetaCyc archives via Chemical Formula
%   and present the respective Metacyc Ids, the
%   standardised MetaCyc metabolite names and their respective synonyms.
%   
%   Returns an(1x3) cell structure including:
%           a.MetaCyc metabolite id in the first cell array
%           b.MetaCyc chemical formulas in the following cell arrays that correspond to the MetaCyc metabolite names
%           in the first one
%           c.InChI strings for MetaCyc Metabolite
%   
%   Usage: metaCycAnnotation = displayMetacycIds(model, metaCycIdFormulaInChiMapping, metaCycIdMetName, metaCycMetNameSynonyms)
%
%   Dimitra Lappa, 2016-05-30

    %Find if the Metabolite exists in MetCyc archives via Chemical Formula
    %Present  Metacyc name
       metaCycAnnotation = {};
       j=starting_point;
       index=find(ismember(metaCycIdFormulaInChiMapping{1,2},model.metFormulas(j)));
       fprintf('\nMetabolite name and formula as annotated in the model\n');
       disp(model.metNames(j));
       disp(model.metFormulas(j));
       if (~isempty(model.metFormulas{j,1})) && (~isempty(index))
           fprintf('There are %i instances of this Metabolite in MetaCyc Archives \n', length(index));
           for k=1:length(index)
                   fprintf('\nMetabolite ID as found in Metacyc based on metabolites chemical formula \n');
                   disp(metaCycIdFormulaInChiMapping{1,1}{index(k),1});
                   metaCycId = metaCycIdFormulaInChiMapping{1,1}{index(k),1};
                   metaCycName = displayMetaCycName(metaCycId, metaCycIdMetName );

                   displayMetaCycSynonyms(metaCycName, metaCycMetNameSynonyms);

                   fprintf('\nMetabolite formula as found in Metacyc based on metabolites chemical formula \n');
                   disp(metaCycIdFormulaInChiMapping{1,2}{index(k),1});

                   fprintf('\nMetabolite InChI string as found in Metacyc based on metabolites chemical formula \n');
                   disp(metaCycIdFormulaInChiMapping{1,3}{index(k),1}), fprintf('\n');
                   disp('--------------------------------------------------------------------------------------------------------');
                   fprintf('This choice of annotation is %i \n', k);
                   metaCycAnnotation{k,1} = metaCycIdFormulaInChiMapping{1,1}{index(k),1};
                   metaCycAnnotation{k,2} = metaCycName;
                   metaCycAnnotation{k,3} = metaCycIdFormulaInChiMapping{1,3}{index(k),1};
           end
       else
           fprintf('\nMetabolite ID was not found in Metacyc based on metabolites chemical formula \n');
           metaCycAnnotation{1,1} = '';
           metaCycAnnotation{1,2} = '';
           metaCycAnnotation{1,3} = '';
           disp('--------------------------------------------------------------------------------------------------------');
           fprintf('This choice of annotation is 1 \n');
       end
           

end


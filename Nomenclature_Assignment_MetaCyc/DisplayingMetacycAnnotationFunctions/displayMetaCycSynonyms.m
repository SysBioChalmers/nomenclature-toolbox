function displayMetaCycSynonyms( metaCycName, metaCycMetNameSynonyms)
% displayMetaCycSynonyms
%   Void Function
%   Takes as input:
%           a.a MetaCyc metabolite's name 
%           b.MetaCyc Synonym data Mapping
%   Finds the metabolite in MetaCyc archives and presents the 
%   respective Metacyc synonyms.
%   
%   
%   Usage: displayMetaCycSynonyms(metaCycName, metaCycMetNameSynonyms)
%
%   Dimitra Lappa, 2016-05-30

           
    Index=find(ismember([metaCycMetNameSynonyms{:}], metaCycName));
    if Index ~= []
        fprintf('\nMetabolite synonyms as found in Metacyc based on metabolites chemical formula \n');
        disp(metaCycMetNameSynonyms{Index,2});
    end

end


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
    if ~isempty(Index)
        fprintf('\nMetabolite synonyms as found in Metacyc based on metabolites chemical formula \n');
        for i=1:length(Index)
            disp(metaCycMetNameSynonyms{Index(i),2});
        end
    else
        fprintf('\n NO Metabolite synonyms \n');
    end
    
    
end


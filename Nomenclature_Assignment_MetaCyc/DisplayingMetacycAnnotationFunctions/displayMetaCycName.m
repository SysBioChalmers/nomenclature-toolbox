function [ metaCycName ] = displayMetaCycName( metaCycId, metaCycIdMetName )
% displayMetaCycName
%   Takes as input:
%           a.a MetaCyc metabolite's Id 
%           b.MetaCyc Ids to metabolite namesdata Mapping
%   
%   Finds the metabolite in MetaCyc archives and presents the 
%   respective Metacyc synonyms.
%   Returns the metabolite's Metacyc Name
%   
%   Usage: metaCycName = displayMetaCycName( metaCycId, metaCycIdMetName )
%
%   Dimitra Lappa, 2016-05-30
    

    Index=find(ismember(metaCycIdMetName{1,1}, metaCycId));
    fprintf('\nMetabolite name as found in Metacyc based on metabolites chemical formula \n');
    metaCycName = metaCycIdMetName{1,2}{Index,1};
    disp(metaCycIdMetName{1,2}{Index,1});
    
    
    
end


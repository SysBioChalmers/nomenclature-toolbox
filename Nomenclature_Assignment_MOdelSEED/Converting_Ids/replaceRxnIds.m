function [ newComponents ] = replaceRxnIds( components )
% replaceRxnIds
%   Takes as input a cell array containing ModelSEED Reaction IDs and converts
%   them by removing their compartment id from their name
%
%   
%   Returns an(1x1) cell structure including:
%       a.the newly assigned metabolite IDs
%   
%   Returns an(1x1) cell structure including:
%       a.the newly assigned reaction IDs
%       
%      
%   Usage: newComponents = replaceRxnIds(components)
%
%   Dimitra Lappa, 2016-03-24

    for i=1:length(components)
        metabolite = char(components{i,1});
        str = '_c0';
        [C,matches] = strsplit(metabolite,{str});
        newComponents{i,1} = char(C{1});
    end

end


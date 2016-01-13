function [ new_components ] = replace_rxn_ids( components )
% replace_rxn_ids
%   Takes as input a cell array containing Reaction IDs and converts
%   them according to the SysBio naming ID standrads for human GEM models:
%       i)  starting with HMR
%       ii) followed by an underscore '_'
%       iii)followed by 4 zeros
%       iv) followed by a four-digit number representing the reaction
%
%   
%   Returns an(1x1) cell structure including:
%       a.the newly assigned reaction IDs
%       
%      
%   Usage: new_components = replace_rxn_ids(components)
%
%   Dimitra Lappa, 2015-12-10
tic
    SysBio_addition = '_0000';
    for i=1:length(components)
        if find(ismember(components{i,1}, '_'))
            temp = strsplit(components{i,1}, '_');
            if strcmp(temp(1), 'HMR')
                new_components{i,1} = strcat(temp(1), SysBio_addition, temp(2));
            else
                temp = components{i,1};
                new_components{i,1} = temp;
            end
        else
            temp = components{i,1};
            new_components{i,1} = temp;
        end
    end
    
toc
end


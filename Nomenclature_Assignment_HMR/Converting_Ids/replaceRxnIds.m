function [ newComponents ] = replaceRxnIds( components )
% replaceRxnIds
%   Takes as input a cell array containing Reaction IDs and converts
%   them according to the SysBio naming ID standrads for human GEM models:
%       a.starting with HMR
%       b.followed by an underscore '_'
%       c.followed by 4 zeros
%       d.followed by a four-digit number representing the reaction
%
%   
%   Returns an(1x1) cell structure including:
%       a.the newly assigned reaction IDs
%       
%      
%   Usage: newComponents = replaceRxnIds(components)
%
%   Dimitra Lappa, 2015-12-10

    sysBioAddition = '_0000';
    for i=1:length(components)
        if find(ismember(components{i,1}, '_'))
            temp = strsplit(components{i,1}, '_');
            if strcmp(temp(1), 'HMR')
                newComponents{i,1} = strcat(temp(1), sysBioAddition, temp(2));
            else
                temp = components{i,1};
                newComponents{i,1} = temp;
            end
        else
            temp = components{i,1};
            newComponents{i,1} = temp;
        end
    end
    

end


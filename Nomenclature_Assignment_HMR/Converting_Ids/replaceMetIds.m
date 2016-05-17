function [ newComponents ] = replaceMetIds( components )
% replaceMetIds
%  Takes as input a cell array containing Metabolite IDs and converts
%   them according to the SysBio naming ID standrads for human GEM models:
%       a.starting with m
%       b.followed by an underscore '_'
%       c.followed by 4 zeros
%       d.followed by a six-digit number representing the metabolite and
%       compartment
%
%   
%   Returns an(1x1) cell structure including:
%       a.the newly assigned metabolite IDs
%       
%   
%
%   Usage: newComponents = replaceMetIds(components)
%   
%   Dimitra Lappa, 2015-12-10

newComponents=components;
    for i=1:length(components)
        metabolite = char(components{i,1}); 
        if strcmp(metabolite(1:1), 'm')
            temp1 = 'm';
            temp2 = metabolite(2:length(metabolite));
            newComponents{i,1} = strcat(temp1, '_000_', temp2);
        elseif strcmp(metabolite(1:4), 'temp')
            temp1 = 'temp';
            temp2 = metabolite(5:length(metabolite));
            newComponents{i,1} = strcat(temp1, '_00_', temp2);
        end
    end 
end



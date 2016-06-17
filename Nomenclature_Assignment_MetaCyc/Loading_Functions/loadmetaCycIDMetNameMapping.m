function [ metaCycIdMetName ] = loadmetaCycIDMetNameMapping( filename )
% loadmetaCycIDMetNameMapping
%   Loads Flatfile downloaded from www.metacyc.org that contains the list of:
%   standardised MetaCyc metabolite names and their respective names.
%   
%   Returns an(1x2) cell structure including:
%       a.MetaCyc metabolite names in the first cell array
%       b.MetaCyc metabolite synonyms in second cell array that correspond 
%       to the MetaCyc metabolite names in the first one
%   
%   Usage: metaCycIdMetName = loadmetaCycIDMetNameMapping('filename.txt')
%
%   Dimitra Lappa, 2016-05-30


    %Reading the file
    fileID = fopen('metaCycIDMetNameMapping.txt');
    A = textscan(fileID,'%s %s %s %s %s %s');
    fclose(fileID);
    %Merging the two columns properly
    A2=strcat(A{1, 2}, A{1, 3});
    %removing quotes from characters
    A2=strrep(A2, '"', '');
    %Creating the proper Cell Array for the mapping
    fprintf('Loading Flatfile for corresponding annotation from MetaCyc metabolite Ids to their names \n \n')
    metaCycIdMetName = {A{1, 1},A2};
    


end


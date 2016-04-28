function [ Lipid_Maps ] = loadLipidMaps( filename )
% loadLipidMaps
%   Loads Flatfile downloaded from www.lipidmaps.org, [http://www.lipidmaps.org/resources/downloads/index.html]
%   that contains the list of:
%   standardised lipid names and LipidMaps Identifiers.
%   
%   Returns an(1x2) cell structure including:
%       a.LipidMaps ids in the first cell array
%       b.Names of lipids in the second cell array that correspond to the ChEBI
%       ids in the first one
%   
%   Usage: Lipid_Maps = loadLipidMaps('filename.txt')
%
%
%   Dimitra Lappa, 2015-12-07


    %Reading the file
    fileID = fopen('lipids.txt');
    Lipid_Maps = textscan(fileID,'%s \t %s \t %s');
    fclose(fileID);